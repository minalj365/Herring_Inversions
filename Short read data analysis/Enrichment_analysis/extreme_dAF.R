####### dAF>0.95, if missense, which genes #####
## Q: what fraction of allelic SNPs are missense mutations 
## Q: what fraction of SNPs with dAF>0.95
# do enrichment analysis only for the most extreme category
## make a table with different categories of SNPs, their numbers and their proportion in the entire set 
# and for those with dAF>0.95

rm(list=ls())
library(tidyverse)
library(dplyr)
library(gridExtra)
library(purrr)
library(ggforce)

setwd("C:/Users/minal03/OneDrive - Texas A&M University/U-Drive/Inversion/recombination")


# reading annotation file
annotation <- read.table("Mafalda_material/Her_86_pools.UG.SNPs.hf.GQ20.mono.miss20.mac3.DPq5-99.snpEff.ANNO")
# reading dAF file
dAF_inv <- read.delim("dAF/dAF_inv.tsv")

## processing annotation file
colnames(annotation)<-c("chr", "pos", "REF", "ALT", "raw")
# Keep colnames CHR and POS for WGS

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




##### join two files for inversion regions
dAF_ann <- left_join(dAF_inv,annotation,by=c("chr","pos"))  # dAF_inv only
dAF_ann <-  dAF_ann %>% select(chr, pos, dAF, NonSyn, Syn, Intron_nr, Five, Three, Down_nr, Up_nr, Inter_nr)

## all sites don't have SNPeff annotation. Hence, ref and alt columns are NA for those.
## exclude sites with NA
dAF_ann <- na.omit(dAF_ann)


### make raw tables to do the stats

# sum of sites under each category for each inversion
total_sum <- dAF_ann %>% group_by(chr) %>% summarise(across(NonSyn:Inter_nr, sum),
                                                      total = sum(c_across(NonSyn:Inter_nr))) 
# proportion of sites under each category for each inversion
total_prop <- total_sum %>% mutate_at(vars(NonSyn:Inter_nr), function(x)x/.$total) %>% 
  group_by(chr) %>% 
  mutate(total_prop = sum(c_across(NonSyn:Inter_nr)))

# number of sites under each category with dAF>0.95 (extreme dAF) for each inversion
obs <- dAF_ann %>%
  filter(dAF >= 0.95) %>%
  group_by(chr) %>% summarise(across(NonSyn:Inter_nr, sum),
                              total = sum(c_across(NonSyn:Inter_nr)))
# expected values 
exp <- data.frame(total_prop[, 1:9],
                  total = obs$total) %>%
  mutate_at(vars(NonSyn:Inter_nr), function(x)round(x*.$total))


write.csv(obs, "extreme_dAF/observed.csv")
write.csv(exp, "extreme_dAF/expected.csv")


################# obtaining gene info for NonSyn mutations with dAF > 0.95 ###########

dAF_ann <- left_join(dAF_inv,annotation,by=c("chr","pos"))
gene_IDs_NonSyn <- dAF_ann %>%
  filter(dAF >= 0.95) %>%
  group_by(chr) %>%
  filter(NonSyn == "TRUE") %>%
  mutate(geneID = str_extract(raw, "ENSCHAG[0-9]{11}")) %>%
  mutate(AA_change = str_extract(raw, "p.[A-Z][a-z]*[0-9]*[A-Z][a-z]*")) %>%
  select(chr, pos, dAF, dAF_prime, REF, ALT, geneID, AA_change)
write.csv(gene_IDs_NonSyn, "extreme_dAF/gene_IDs_NonSyn.csv")