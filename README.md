# 🧬 Herring Chromosomal Inversions

This repository contains all scripts, datasets, and analysis pipelines used in our study:

**The origin and maintenance of supergenes contributing to ecological adaptation in Atlantic herring**  
*Minal Jamsandekar, Mafalda S. Ferreira, Mats E. Pettersson, Edward D. Farrell, Brian W. Davis, Leif Andersson*  
Published in **Nature Communications** (2024)  
[🔗 Read the paper](https://www.nature.com/articles/s41467-024-53079-7)

---

## 🧠 Project Overview

This study investigates the origin, structure, and evolutionary consequences of four megabase-scale chromosomal inversions in the Atlantic herring (*Clupea harengus*), which are associated with ecological adaptation to water temperature in North and South Atlantic Ocean. The sequencing data used are - 12 Atlantic herring individuals sequenced with PacBio HiFi, 49 Atlantic herring individuals sequenced with Illumina short-read, 30 Pacific herring individuals sequenced with Illumina short-read, and one European sprat sequenced with PacBio HiFi.

We characterize inversions on:
- **Chromosome 6 (~7.8 Mb)**
- **Chromosome 12 (~2.7 Mb)**
- **Chromosome 17 (~8.3 Mb)**
- **Chromosome 23 (~4.6 Mb)**

### Key findings:
- Inversions are originated via **ectopic recombination** between inverted duplications flanking the inversion.
- Inversion haplotypes are **ancient** (1–5 million years old) and are formed **after the split between Atalntic and Pacific herring**.
- Despite recombination suppression, inverted haplotypes show **no significant mutational load**.

---

## 📂 Repository Structure

| Folder | Description |
|--------|-------------|
| `PacBio HiFi data analysis/` | Long-read (HiFi) assemblies construction, assembly statistics, genome-to-genome alignment, read based bam alignments, annotation of genome assemblies |
| `Short read data analysis/` | SNP-based recombination analysis using delta allele frequency estimates |
| `S_and_N_alleles/` | Nucleotide sequence of S and N alleles for all four inversions |
| `README.md` | Project overview and navigation (this file) |

---
