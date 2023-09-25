#!/bin/sh

in_dir="/data1/CluHar/PacBio/CCS_data/Raw_data/FASTQ/"
out_dir="/data1/CluHar/PacBio/CCS_data/Alignments/Minimap2/for_GATK/Baltic/"
genome="/data1/CluHar/Genomes/Assembly_v2.0.2/Ch_v2.0.2.fasta"

samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6"

for i in ${samples};
do /data1/_software/minimap2/minimap2 -ayYL --MD --eqx -x asm20 -R @RG\\tID:${i}\\tSM:${i}\\tPL:SequelII ${genome} ${in_dir}${i}.ccs.fastq.gz | samtools sort -o ${out_dir}${i}.bam 2> ${out_dir}${i}.log &
done;