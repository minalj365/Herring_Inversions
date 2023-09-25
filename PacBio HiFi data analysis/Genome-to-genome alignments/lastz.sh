#!/bin/sh
lastz="/home/minal03/bin/lastz/src/lastz"
reference="/data1/CluHar/Genomes/Assembly_v2.0.2/Ch_v2.0.2.fasta"
hap1="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap1_contigs/"
hap2="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap2_contigs/"
samples="CS10 F3"

for i in ${samples}; do
${lastz} ${reference}[multiple] ${hap1}${i}.hap1.fa --notransition --step=20 --chain --format=axt --format=rdotplot --output=${i}_hap1.axt &> log_${i}_hap1 &
${lastz} ${reference}[multiple] ${hap2}${i}.hap2.fa --notransition --step=20 --chain --format=axt --format=rdotplot --output=${i}_hap2.axt &> log_${i}_hap2 &
done;