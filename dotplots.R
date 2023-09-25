rm(list=ls())
stringsAsFactors=FALSE
library(tidyverse)
library(patchwork)
library(gridExtra)

my_thm= list( theme_bw(base_size = 10),
              theme(panel.grid.minor = element_blank()),
              theme(panel.grid.major.y = element_line(color = "grey")),
              theme(axis.line = element_line(colour = "black")),
              theme(aspect.ratio =1,legend.position = "none",
                    plot.title = element_text(hjust = 0.5, face = "bold", size=10)))


setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/Writing/Figures/dotplots/one_to_one")

dotplot <- function(chr){
  #chr <- paste0(chr)
  mydot <- read.table(paste0(chr, "_dot.txt"), header = FALSE) #read the coordinates for the dots
  myline <- read.table(paste0(chr, "_line.txt"), header = FALSE) #read the coordinates for the lines
  myxtics <- read.table(paste0(chr, "_xticks.txt"),header = TRUE) #read the x axis ticks
  myytics <- read.table(paste0(chr, "_yticks.txt"),header = TRUE) #read the y-axis ticks
  mycolor <- c("red","blue") #assign the colors to your own color scheme
  names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively
  
  myplot <- ggplot(mydot, aes(x = V1, y=V2, color=V3)) + geom_point() #create the ggplot object with the dots
  #now create the plot. Parameters can be modified
  myplot + geom_segment(data = myline, aes(x=V1, y=V2, xend=V3, yend=V4, color = V5)) + 
    scale_y_continuous(breaks = myytics$ypos, expand = c(0.01, 0.01), labels = myytics$yname, name = expression(paste(italic("N"), " allele"))) +
    scale_x_continuous(breaks = myxtics$xpos, expand = c(0, 0), labels = myxtics$xname, name = expression(paste(italic("S"), " allele"))) +
   # labs(x = expression(paste))
    scale_color_manual(values = mycolor) +
    my_thm
}

p1 <- dotplot("chr6") + ggtitle("Chromosome 6 \n (2.6 Mb)")
p2 <- dotplot("chr12") + ggtitle("Chromosome 12 \n (7.8 Mb)")
p3 <- dotplot("chr17") + ggtitle("Chromosome 17 \n (1.8 Mb)")
p4 <- dotplot("chr23") + ggtitle("Chromosome 23 \n (1.4 Mb)")

plot <- grid.arrange(p1, p2, p3, p4, nrow = 1)
ggsave("one_to_one.png", plot, width = 8, height = 3)
ggsave("one_to_one.pdf", plot, width = 8, height = 3)

################ one to many, against_S #############
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/Writing/Figures/dotplots/one_to_many/against_S")

dotplot <- function(chr){
  #chr <- paste0(chr)
  mydot <- read.table(paste0(chr, "_dot.txt"), header = FALSE) #read the coordinates for the dots
  myline <- read.table(paste0(chr, "_line.txt"), header = FALSE) #read the coordinates for the lines
  myxtics <- read.table(paste0(chr, "_xticks.txt"),header = TRUE) #read the x axis ticks
  myytics <- read.table(paste0(chr, "_yticks.txt"),header = TRUE) #read the y-axis ticks
  mycolor <- c("red","blue") #assign the colors to your own color scheme
  names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively
  
  myplot <- ggplot(mydot, aes(x = V1, y=V2, color=V3)) + geom_point() #create the ggplot object with the dots
  #now create the plot. Parameters can be modified
  myplot + geom_segment(data = myline, aes(x=V1, y=V2, xend=V3, yend=V4, color = V5)) + 
    scale_y_continuous(breaks = myytics$ypos, expand = c(0.01, 0.01), labels = myytics$yname, name = "Inversion scaffolds") +
    scale_x_continuous(breaks = myxtics$xpos, expand = c(0, 0), labels = myxtics$xname, name = expression(paste(italic("S"), " allele"))) +
    # labs(x = expression(paste))
    scale_color_manual(values = mycolor) +
    my_thm +
    theme(axis.text.y = element_text(size = 6))
}

p1 <- dotplot("chr6") + ggtitle("Chr 6")
p2 <- dotplot("chr12") + ggtitle("Chr 12")
p3 <- dotplot("chr17") + ggtitle("Chr 17")
p4 <- dotplot("chr23") + ggtitle("Chr 23")

plot <- grid.arrange(p1, p2, p3, p4, nrow = 2)
ggsave("one_to_many_S.png", plot, width = 8, height = 8)
ggsave("one_to_many_S.pdf", plot, width = 8, height = 8)







################ one to many, against_N #############
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/Writing/Figures/dotplots/one_to_many/against_N")

dotplot <- function(chr){
  #chr <- paste0(chr)
  mydot <- read.table(paste0(chr, "_dot.txt"), header = FALSE) #read the coordinates for the dots
  myline <- read.table(paste0(chr, "_line.txt"), header = FALSE) #read the coordinates for the lines
  myxtics <- read.table(paste0(chr, "_xticks.txt"),header = TRUE) #read the x axis ticks
  myytics <- read.table(paste0(chr, "_yticks.txt"),header = TRUE) #read the y-axis ticks
  mycolor <- c("red","blue") #assign the colors to your own color scheme
  names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively
  
  myplot <- ggplot(mydot, aes(x = V1, y=V2, color=V3)) + geom_point() #create the ggplot object with the dots
  #now create the plot. Parameters can be modified
  myplot + geom_segment(data = myline, aes(x=V1, y=V2, xend=V3, yend=V4, color = V5)) + 
    scale_y_continuous(breaks = myytics$ypos, expand = c(0.01, 0.01), labels = myytics$yname, name = "Inversion scaffolds") +
    scale_x_continuous(breaks = myxtics$xpos, expand = c(0, 0), labels = myxtics$xname, name = expression(paste(italic("N"), " allele"))) +
    # labs(x = expression(paste))
    scale_color_manual(values = mycolor) +
    my_thm +
    theme(axis.text.y = element_text(size = 6))
}

p1 <- dotplot("chr6") + ggtitle("Chr 6")
p2 <- dotplot("chr12") + ggtitle("Chr 12")
p3 <- dotplot("chr17") + ggtitle("Chr 17")
p4 <- dotplot("chr23") + ggtitle("Chr 23")

plot <- grid.arrange(p1, p2, p3, p4, nrow = 2)
ggsave("one_to_many_N.png", plot, width = 8, height = 8)
ggsave("one_to_many_N.pdf", plot, width = 8, height = 8)







################ sprat #############
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/Writing/Figures/dotplots/sprat")

dotplot <- function(chr){
  #chr <- paste0(chr)
  mydot <- read.table(paste0(chr, "_dot.txt"), header = FALSE) #read the coordinates for the dots
  myline <- read.table(paste0(chr, "_line.txt"), header = FALSE) #read the coordinates for the lines
  myxtics <- read.table(paste0(chr, "_xticks.txt"),header = TRUE) #read the x axis ticks
  myytics <- read.table(paste0(chr, "_yticks.txt"),header = TRUE) #read the y-axis ticks
  mycolor <- c("red","blue") #assign the colors to your own color scheme
  names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively
  
  myplot <- ggplot(mydot, aes(x = V1, y=V2, color=V3)) + geom_point() #create the ggplot object with the dots
  #now create the plot. Parameters can be modified
  myplot + geom_segment(data = myline, aes(x=V1, y=V2, xend=V3, yend=V4, color = V5)) + 
    scale_y_continuous(breaks = myytics$ypos, expand = c(0.02, 0.0), labels = c("S allele", "N allele")) +
    scale_x_continuous(breaks = myxtics$xpos, expand = c(0, 0), labels = myxtics$xname, name = "Sprat contig") +
    # labs(x = expression(paste))
    scale_color_manual(values = mycolor) +
    my_thm +
    theme(axis.title.y = element_blank(),
          axis.text.y = element_text(size = 3),
          axis.ticks = element_blank())
}
p1 <- dotplot("chr6") + ggtitle("Chromosome 6") 
p2 <- dotplot("chr12") + ggtitle("Chromosome 12")
p3 <- dotplot("chr17") + ggtitle("Chromosome 17")
p4 <- dotplot("chr23") + ggtitle("Chromosome 23")

plot <- grid.arrange(p1, p2, p3, p4, nrow = 1)
ggsave("sprat.png", plot, width = 8, height = 3)
ggsave("sprat.pdf", plot, width = 8, height = 3)









################ heterozygosity #############
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/dotplot_figures/mplotter/heterozygosity/")

dotplot <- function(chr){
  #chr <- paste0(chr)
  mydot <- read.table(paste0(chr, "_dot.txt"), header = FALSE) #read the coordinates for the dots
  myline <- read.table(paste0(chr, "_line.txt"), header = FALSE) #read the coordinates for the lines
  myxtics <- read.table(paste0(chr, "_xticks.txt"),header = TRUE) #read the x axis ticks
  myytics <- read.table(paste0(chr, "_yticks.txt"),header = TRUE) #read the y-axis ticks
  mycolor <- c("red","blue") #assign the colors to your own color scheme
  names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively
  
  myplot <- ggplot(mydot, aes(x = V1, y=V2, color=V3)) + geom_point() #create the ggplot object with the dots
  #now create the plot. Parameters can be modified
  myplot + geom_segment(data = myline, aes(x=V1, y=V2, xend=V3, yend=V4, color = V5)) + 
    scale_y_continuous(breaks = myytics$ypos, expand = c(0.03, 0.01), labels = myytics$yname, name = "Inversion scaffolds") +
    scale_x_continuous(breaks = myxtics$xpos, expand = c(0.01, 0.01), labels = myxtics$xname, name = expression(paste(italic("S"), " allele"))) +
    # labs(x = expression(paste))
    scale_color_manual(values = mycolor) +
    my_thm +
    theme(axis.text.y = element_text(size = 6))
}
p1 <- dotplot("chr17") + ggtitle("Chromosome 17 (BS5)") 
p2 <- dotplot("chr23") + ggtitle("Chromosome 23 (BS2)")
p3 <- dotplot("chr17_control") + ggtitle("Chromosome 17 (BS1)")
p4 <- dotplot("chr23_control") + ggtitle("Chromosome 23 (BS1)")

plot <- grid.arrange(p1, p2, p3, p4, nrow = 2)
ggsave("het.png", plot, width = 8, height = 4)
ggsave("het.pdf", plot, width = 8, height = 4)



############### chr6 suppl. ############

setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/dotplot_figures/mplotter/chr6_suppl/")

mydot <- read.table("dot.txt", header = FALSE) #read the coordinates for the dots
myline <- read.table("line.txt", header = FALSE) #read the coordinates for the lines
myxtics <- read.table("xticks.txt", header = TRUE) #read the x axis ticks
myytics <- read.table("yticks.txt", header = TRUE) #read the y-axis ticks
mycolor <- c("red","blue") #assign the colors to your own color scheme
names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively

myplot <- ggplot(mydot, aes(x = V1, y=V2, color=V3)) + geom_point() #create the ggplot object with the dots
#now create the plot. Parameters can be modified
myplot <- myplot + geom_segment(data = myline, aes(x=V1, y=V2, xend=V3, yend=V4, color = V5)) + 
  scale_y_continuous(name = "BS3_hap1") +
  scale_x_continuous(name = "BS3_hap2") +
  # labs(x = expression(paste))
  scale_color_manual(values = mycolor) +
  my_thm +
  theme(axis.text.y = element_text(size = 8),
        axis.text.x = element_text(size = 8)) +
  ggtitle("Chromosome 6 inversion scaffold")


ggsave("chr6.png", myplot, width = 8, height = 4)
ggsave("chr6.pdf", myplot, width = 6, height = 4)



