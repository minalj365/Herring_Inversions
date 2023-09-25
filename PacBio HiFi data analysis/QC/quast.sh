#!/bin/sh
samples="NSSH1 NSSH2 NSSH10"
genome_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/"
out_dir="/data1/CluHar/PacBio/CCS_data/QUAST/hifiasm/"

for i in ${samples}; do

mkdir ${i}_Primary
mkdir ${i}_hap1
mkdir ${i}_hap2

#primary
/home/minal03/bin/quast-5.0.2/quast-lg.py --threads 4 --large --eukaryote --output-dir ${out_dir}${i}_Primary ${genome_dir}Primary_contigs/${i}.p_ctg.fa &

#hap1
/home/minal03/bin/quast-5.0.2/quast-lg.py --threads 4 --large --eukaryote --output-dir ${out_dir}${i}_hap1 ${genome_dir}hap1_contigs/${i}.hap1_ctg.fa &

#hap2
/home/minal03/bin/quast-5.0.2/quast-lg.py --threads 4 --large --eukaryote --output-dir ${out_dir}${i}_hap2 ${genome_dir}hap2_contigs/${i}.hap2_ctg.fa &

done;