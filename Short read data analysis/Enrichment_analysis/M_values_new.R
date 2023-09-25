rm(list=ls())
library(tidyverse)
library(dplyr)
library(gridExtra)
library(purrr)
library(ggforce)
library(patchwork)

my_thm= list( theme_bw(),
              theme(panel.grid.major = element_blank(), panel.grid.minor= element_blank()),
              theme(panel.border = element_blank()),
              theme(axis.line = element_line(colour = "black")),
              theme(axis.text.y = element_text(colour="grey10",size=10),
                    axis.title.y = element_text(colour="black",size=10),
                    axis.text.x = element_text(colour="grey10",size=10, angle = 90, vjust = 0.5, hjust = 1),
                    axis.title.x = element_text(colour="black",size=10),
                    plot.title = element_text(hjust = 0.5, face = "bold", size=14)))

setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/recombination")

# reading annotation file
annotation <- read.delim("Annotation_files/annotation_inv_chr.tsv")
#annotation <- read.table("Mafalda_material/Her_86_pools.UG.SNPs.hf.GQ20.mono.miss20.mac3.DPq5-99.snpEff.ANNO")
colnames(annotation)<-c("CHR", "POS", "REF", "ALT", "raw")


# reading dAF file
dAF_inv <- read.delim("dAF/dAF_inv.tsv")
colnames(dAF_inv)[1] = "CHR"
colnames(dAF_inv)[2] = "POS"

chr6 <- filter(dAF_inv, CHR == "chr6")
chr12 <- filter(dAF_inv, CHR == "chr12")
chr17 <- filter(dAF_inv, CHR == "chr17")
chr23 <- filter(dAF_inv, CHR == "chr23")
#annotation <- annotation %>% filter(CHR == c("chr6", "chr12", "chr17", "chr23"))
### for WGS dAF
DAF.Baltic_vs_Atlantic <- read.table("Mafalda_material/Baltic_vs_Atlantic_MB16.DAF.tx",header=T)
colnames(DAF.Baltic_vs_Atlantic)[5] = "dAF"

## processing annotation file
annotation[,"NonSyn"] <- grepl("missense_variant", annotation$raw)
annotation[,"Syn"] <- grepl("synonymous_variant", annotation$raw)
annotation[,"Intron"] <- grepl("intron_variant", annotation$raw)
annotation[,"Five"] <- grepl("5_prime_UTR_variant", annotation$raw)
annotation[,"Three"] <- grepl("3_prime_UTR_variant", annotation$raw)
annotation[,"Down"] <- grepl("downstream_gene_variant", annotation$raw)
annotation[,"Up"] <- grepl("upstream_gene_variant", annotation$raw)
annotation[,"Inter"] <- grepl("intergenic_region", annotation$raw)

annotation[,"Down_nr"] <- annotation[,"Down"] & !(annotation[,"NonSyn"] | annotation[,"Syn"] | annotation[,"Intron"] | annotation[,"Five"] | annotation[,"Three"])
annotation[,"Up_nr"] <- annotation[,"Up"] & !(annotation[,"NonSyn"] | annotation[,"Syn"] | annotation[,"Intron"] | annotation[,"Five"] | annotation[,"Three"])
annotation[,"Inter_nr"] <- annotation[,"Inter"] & !(annotation[,"Down"] | annotation[,"Up"] | annotation[,"NonSyn"] | annotation[,"Syn"] | annotation[,"Intron"] | annotation[,"Five"] | annotation[,"Three"])
annotation[,"Intron_nr"] <- annotation[,"Intron"] & !(annotation[,"NonSyn"] | annotation[,"Syn"] | annotation[,"Five"] | annotation[,"Three"])




# chr <- chr17

####### FUNCTION ###########
myplot <- function(chr){
  
  ann_df <- merge(chr, annotation, by=c("CHR","POS"))  # dAF_inv only
  ann_df <- na.omit(ann_df)
  
  M_value_df <- data.frame(total_freq = colSums(ann_df[,c("NonSyn", "Syn", "Intron_nr", "Five", "Three", "Down_nr", "Up_nr", "Inter_nr")])/dim(ann_df)[1], stringsAsFactors = F, row.names = c("NonSyn", "Syn", "Intron_nr", "Five", "Three", "Down_nr", "Up_nr", "Inter_nr"))
  
  # This is a table that will store the total counts of SNPs per category
  bin_size_df <- data.frame(row.names = c("total"), stringsAsFactors = F )
  bin_size_df["total","all"] <- dim(ann_df)[1]
  
  freq_bin_vec <-c(0, 0.05, 0.1, 0.15, 0.2, 0.3, 0.5, 1)
  for(i in 1:(length(freq_bin_vec)-1)){
    
    #Obtain bin size:
    bin_start <- freq_bin_vec[i]
    bin_end <- freq_bin_vec[i+1]
    bin_name <- paste(bin_start, bin_end, sep = "_")
    # Grab the SNPs that have DAF equal or greater than bin start; or smaller than bin end
    bin_filter <- abs(ann_df$dAF) >= bin_start & abs(ann_df$dAF) < bin_end
    # Calculate the total number of SNPs in each category
    bin_size_df["total",bin_name] <- sum(bin_filter)
    
    # This calculates the observed frequency of each category in each bin of DAF
    M_value_df[,paste0(bin_name, "_tot")] <- colSums(ann_df[bin_filter,c("NonSyn", "Syn", "Intron_nr", "Five", "Three", "Down_nr", "Up_nr", "Inter_nr")])/bin_size_df["total",bin_name]
    
  }
  
  for(freq_col in names(M_value_df)){
    M_value_df[,paste0(freq_col,"_M")] <- log2(M_value_df[,freq_col]/M_value_df[,"total_freq"])
  }  
  
  M_value_df$category<-rownames(M_value_df)
  
  M_value_df %>%
    pivot_longer(cols=1:16, values_to = "freq", names_to = "bin") -> to_plot
  
  to_plot[grepl("tot_M",to_plot$bin),]->to_plot_M_values
  
  to_plot_M_values$xaxisplot <- c(rep(seq(1,7),length(unique(to_plot_M_values$category))))
  
  to_plot_M_values[to_plot_M_values$category=="NonSyn",][,1]<-"non-synonymous"
  to_plot_M_values[to_plot_M_values$category=="Syn",][,1]<-"synonymous"
  to_plot_M_values[to_plot_M_values$category=="Intron_nr",][,1]<-"intron"
  to_plot_M_values[to_plot_M_values$category=="Five",][,1]<-"5_prime_UTR"
  to_plot_M_values[to_plot_M_values$category=="Three",][,1]<-"3_prime_UTR"
  to_plot_M_values[to_plot_M_values$category=="Down_nr",][,1]<-"downstream"
  to_plot_M_values[to_plot_M_values$category=="Up_nr",][,1]<-"upstream"
  to_plot_M_values[to_plot_M_values$category=="Inter_nr",][,1]<-"intergenic"
  
  colours = c("non-synonymous" = "#FF1A01", 
              "synonymous" = "#338BFF", 
              "intron" = "#F08901", 
              "5_prime_UTR" = "#009A00",
              "3_prime_UTR" = "#00DE00",
              "downstream" = "#7F689A", 
              "upstream" = "#B24E45", 
              "intergenic" = "#AEA369")
  
  plot <- to_plot_M_values %>%
    ggplot() +
    #geom_hline(yintercept = 1, color="gray", linetype="dashed")+ 
    #geom_hline(yintercept = 1.5, color="gray", linetype="dashed")+
    #geom_hline(yintercept = 0, color="gray", linetype="dashed")+
    #geom_hline(yintercept = -1.5, color="gray", linetype="dashed")+
    #geom_hline(yintercept = -1, color="gray", linetype="dashed")+
    geom_line(aes(x=xaxisplot, y=freq, color=category), cex=2) +
    xlab("dAF") +
    ylab("M value") +
    #ggtitle(chr) +
    ylim(-7,2)  +
    scale_color_manual(values = colours) +
    scale_x_continuous(breaks = seq(1,7), 
                       labels=c("0 - 0.05", "0.05 - 0.1", "0.1 - 0.15", "0.15 - 0.2", "0.2 - 0.3", "0.3 - 0.5", "0.5 - 1")) +
    my_thm
  
  plot
  #ggsave(filename = paste0(chr, ".png"), plot = plot, device = "png")
  
}

p1 <- myplot(chr6) + ggtitle("chr6") 
p2 <- myplot(chr12) + ggtitle("chr12")
p3 <- myplot(chr17) + ggtitle("chr17")
p4 <- myplot(chr23) + ggtitle("chr23")
p5 <- myplot(DAF.Baltic_vs_Atlantic) # whole genome

p1 + p2 + p3 + p4 + plot_layout(guides = "collect")

grid.arrange(p1, p2, p3, p4, nrow = 2, shared_legend)
