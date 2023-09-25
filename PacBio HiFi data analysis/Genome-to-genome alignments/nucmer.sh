#!/bin/sh
ref="/data1/CluHar/Genomes/Assembly_v2.0.2/Ch_v2.0.2.fasta"
hap1_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap1_contigs/"
hap2_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap2_contigs/"
out_dir="/data1/CluHar/PacBio/CCS_data/Alignments/MUMmer/hifiasm_new/ref_vs_hap1/"
mummer="/home/minal03/bin/mummer-4.0.0rc1/"
samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6"

for i in ${samples}; do
${mummer}nucmer --batch=1 -l 100 -c 500 -t 2 ${ref} ${hap1_dir}${i}.hap1.fa --delta=${out_dir}${i}_ref_vs_hap1 &
${mummer}nucmer --batch=1 -l 100 -c 500 -t 6 ${ref} ${hap2_dir}${i}.hap2.fa --delta=${out_dir}${i}_ref_vs_hap2 &
done;