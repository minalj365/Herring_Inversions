#!/bin/sh

hap1_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap1_contigs/"
hap2_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap2_contigs/"
out_dir="/data1/CluHar/PacBio/CCS_data/Annotation/ENSEMBL/default_params/"
ref="/data1/CluHar/Genomes/Assembly_v2.0.2/ENSEMBL/Clupea_harengus.Ch_v2.0.2.dna.toplevel.fa"
gff3="/data1/CluHar/Annotation/ENSEMBL/Clupea_harengus.Ch_v2.0.2.104.gff3"
samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6"

for i in ${samples}; do
#hap1

liftoff -g ${gff3} -o ${out_dir}${i}_hap1.gff3 -u ${out_dir}unmapped/${i}_hap1 -dir ${out_dir}intermediate_files/${i}_hap1 -polish -copies ${hap1_dir}${i}.hap1.fa ${ref} &

#hap2
#liftoff -g ${gff3} -o ${out_dir}${i}_hap2.gff3 -u ${out_dir}unmapped/${i}_hap2 -dir ${out_dir}intermediate_files/${i}_hap2 -polish -copies ${hap2_dir}${i}.hap2.fa ${ref} &
done;