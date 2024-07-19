################## all ####################
rm(list=ls())
library(tidyr)
library(dplyr)
library(gridExtra)
library(purrr)
library(stringr)
library(readr)
library(grid)


## reading and writing files into dataframes

# all
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/recombination/dAF/all")
filenames_all <- list.files()
all <- purrr::map_df(filenames_all,
                     ~read.delim(.x, stringsAsFactors = FALSE, row.names = NULL) %>%
                       dplyr::mutate(filename = .x))

# CS
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/recombination/dAF/CS")
filenames_CS <- list.files()
CS <- purrr::map_df(filenames_CS,
                    ~read.delim(.x, stringsAsFactors = FALSE, row.names = NULL) %>%
                      dplyr::mutate(filename = .x))

# F
setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/recombination/dAF/F")
filenames_F <- list.files()
F <- purrr::map_df(filenames_F,
                   ~read.delim(.x, stringsAsFactors = FALSE, row.names = NULL) %>%
                     dplyr::mutate(filename = .x))


setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/recombination/dAF/")

# tidy the dataframes

tidy <- function(dataframe) {
  tidy_dataframe <- dataframe %>%
    separate(col = "filename", into = c("chr", "samples", "maf_threshold"), sep = "_") %>%
    select(-chr) %>%
    mutate(maf_threshold = str_replace(maf_threshold, "maf", "")) %>%
    mutate(maf_threshold = str_replace(maf_threshold, ".frq", "")) %>%
    `colnames<-`(c("chr", "pos", "n_alleles", "n_chr", "ref", "alt", "samples", "maf_threshold")) %>%
    arrange(chr, maf_threshold) %>%
    separate(col = ref, into = c("ref_allele", "ref_freq"), ":") %>%
    separate(col = alt, into = c("alt_allele", "alt_freq"), ":") %>%
    select(chr, pos, ref = ref_freq, alt = alt_freq, samples, maf_threshold)
}

tidy_all <- tidy(all)
tidy_CS <- tidy(CS)
tidy_F <- tidy(F)


###### determine the minor allele ########

tidy_all <- tidy_all %>%
  mutate(minor = ifelse(ref>alt, "ALT", ifelse(alt>ref, "REF", "NA")))

##### determine minor allele frequency in CS and F populations ####

# create new tables where we fetch the frequency of the minor allele
minor_ref_sites <- tidy_all %>% filter(minor=="REF") %>%  select(chr, pos)
minor_alt_sites <- tidy_all %>% filter(minor=="ALT") %>% select(chr, pos)


#rownames(CS_frq) <- CS_frq$pos
#rownames(F_frq) <- F_frq$pos

# retrieve minor allele information and rename columns

MA_ref <- function(SampleFile, RefMinorAlleleFile){
  semi_join(SampleFile, RefMinorAlleleFile, by = c("chr", "pos")) %>%
    select(chr, pos, ref) %>%
    dplyr::rename(MAF = ref)
}

MA_alt <- function(SampleFile, AltMinorAlleleFile){
  semi_join(SampleFile, AltMinorAlleleFile, by = c("chr", "pos")) %>%
    select(chr, pos, alt) %>%
    dplyr::rename(MAF = alt)
}
CS_RefMinor <- MA_ref(tidy_CS, minor_ref_sites)
F_RefMinor <- MA_ref(tidy_F, minor_ref_sites)
CS_AltMinor <- MA_alt(tidy_CS, minor_alt_sites)
F_AltMinor <- MA_alt(tidy_F, minor_alt_sites)

# rbind
CS_minor <- rbind(CS_RefMinor, CS_AltMinor)
F_minor <- rbind(F_RefMinor, F_AltMinor)

# Combine everything into single table
minor_freq <- merge(CS_minor, F_minor, by=c("chr", "pos"), suffixes=c(".CS", ".F")) %>%
  arrange(match(chr, c("chr6", "chr12", "chr17", "chr23")), pos)

## calculate dAF and dAF' ##

# let's start with dAF across the chromosome
dAF <- minor_freq %>%
  mutate(MAF.CS = as.numeric(MAF.CS), MAF.F = as.numeric(MAF.F)) %>%
  mutate(dAF = abs(MAF.CS - MAF.F), maxAF = pmax(MAF.CS, MAF.F), dAF_prime = dAF/maxAF) %>%
  select(chr, pos, MAF.CS, MAF.F, dAF, dAF_prime)
write_delim(dAF, "dAF_inv_chr.tsv", delim="\t")


# let's now get dAF for the plotting purpose (inversion regions + flanking)

## extracting inversion and flanking regions' sites ##
chr6 <- dAF %>% filter(chr == "chr6", pos >= 21782765, pos <= 25368581) #500 kb flanking
chr12 <- dAF %>% filter(chr == "chr12", pos >= 17326318, pos <= 26103093) #500 kb flanking
chr17 <- dAF %>% filter(chr == "chr17", pos >= 24805445) # 1Mb upstream flanking
chr23 <- dAF %>% filter(chr == "chr23", pos >= 15726443, pos <= 18104273) #500 kb flanking


dAF_temp1 <- merge(chr6, chr12, all = TRUE)
dAF_temp2 <- merge(dAF_temp1, chr17, all = TRUE)
dAF_inv <- merge(dAF_temp2, chr23, all = TRUE) %>%
  arrange(match(chr, c("chr6", "chr12", "chr17", "chr23")), pos)

write_delim(dAF_inv, "dAF_inv_with_flanking.tsv", delim = "\t")


## remove files that are not required for the further analysis
rm(chr6, chr12, chr17, chr23, dAF_temp1, dAF_temp2, minor_ref_sites, 
   minor_alt_sites, CS_RefMinor, F_RefMinor, CS_AltMinor, F_AltMinor, CS_minor, F_minor, minor_freq,
   all, CS, F, tidy_all, tidy_CS, tidy_F)



### arrow for the plots
arrow <- data.frame(x = c(22282765, 24868581,
                          17826318, 25603093,
                          25805445, 27568510,
                          16226443, 17604273),
                    xend = c(22282765, 24868581,
                             17826318, 25603093,
                             25805445, 27568510,
                             16226443, 17604273),
                    y = rep(1, 8),
                    yend = rep(0.8, 8),
                    chr = rep(c("chr6", "chr12", "chr17", "chr23"), each = 2))



################# plotting ################
# dAF for an entire chromosome
mid=0.5
dAF_plot <- ggplot(dAF, aes(x=pos, y=dAF, color=dAF_prime)) +
  geom_point(alpha =  0.3)+
  #scale_color_gradient2(midpoint=mid, low="blue", mid="yellow", high="red") +
  scale_color_gradient2(midpoint=mid, high="steelblue2", low="tomato3", mid="gold", name = "dAF'") +
  geom_segment(data = arrow, 
               aes(x = x, xend = xend, y = y, yend = yend),
               color = "black", lwd = 0.8,
               arrow = arrow(length = unit(0.15, "cm"))) +
  facet_wrap(~factor(chr, levels = c("chr6", "chr12", "chr17", "chr23")), scales = "free_x", nrow=4,
             labeller = as_labeller(c(`chr6` = "Chr 6",
                                      `chr12` = "Chr 12",
                                      `chr17` = "Chr 17",
                                      `chr23` = "Chr 23"))) +
  scale_x_continuous(labels = function(x)round(x/1000000, 2)) +
  labs(x = "Position on the reference assembly (Mb)",
       y = "dAF") +
  theme(strip.background = element_blank(),
        strip.text.x = element_text(face = "bold", size = 11),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey"))
ggsave("dAF.pdf", width = 8, height = 8)
ggsave("dAF.png", width = 8, height = 8)


# dAF_inv plot
mid=0.5
dAF_inv_plot <- ggplot(dAF_inv, aes(x=pos, y=dAF, color=dAF_prime)) +
  geom_point(alpha =  0.3)+
  #scale_color_gradient2(midpoint=mid, low="blue", mid="yellow", high="red", name = "dAF'") +
  scale_color_gradient2(midpoint=mid, high="steelblue2", low="tomato3", mid="gold", name = "dAF'") +
  geom_segment(data = arrow, 
               aes(x = x, xend = xend, y = y, yend = yend),
               color = "black", lwd = 0.8,
               arrow = arrow(length = unit(0.15, "cm"))) +
  facet_wrap(~factor(chr, levels = c("chr6", "chr12", "chr17", "chr23")), scales = "free_x", nrow=4,
             labeller = as_labeller(c(`chr6` = "Chromosome 6",
                                      `chr12` = "Chromosome 12",
                                      `chr17` = "Chromosome 17",
                                      `chr23` = "Chromosome 23"))) +
  scale_x_continuous(labels = function(x)round(x/1000000, 2)) +
  labs(x = "Position on the reference assembly (Mb)",
       y = "dAF") +
  theme(strip.background = element_blank(),
        strip.text.x = element_text(face = "bold", size = 7),
        panel.background = element_blank(),
        axis.line = element_line(colour = "grey"),
        axis.text.x = element_text(size = 7),
        axis.text.y = element_text(size = 7),
        axis.title.x = element_text(size = 7),
        axis.title.y = element_text(size = 7),
        legend.text = element_text(size = 7),
        legend.title = element_text(size = 7),)
ggsave("dAF_prime_inv.pdf", width = 7.08, height = 7.28)
ggsave("dAF_prime_inv.png", width = 7.08, height = 7.28)

ggsave("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/Manuscript_prep/Revisions_2/All_figures/Fig.8_dAF_prime_inv.pdf", width = 7.08, height = 7.28)
ggsave("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/Manuscript_prep/Revisions_2/All_figures/Fig.8_dAF_prime_inv.png", width = 7.08, height = 7.28)


