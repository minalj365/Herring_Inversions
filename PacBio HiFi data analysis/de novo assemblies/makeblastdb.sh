#!/bin/sh
genome_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/assemblies/"
out="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/assemblies/BLASTdb/"
samples="CS7 CS8 CS10 F4 F5 F6"
for i in ${samples}; do
#hap1
makeblastdb -in ${genome_dir}${i}_hap1.fa -parse_seqids -dbtype nucl -input_type fasta -out ${out}${i}_hap1
#hap2
makeblastdb -in ${genome_dir}${i}_hap2.fa -parse_seqids -dbtype nucl -input_type fasta -out ${out}${i}_hap2
done;