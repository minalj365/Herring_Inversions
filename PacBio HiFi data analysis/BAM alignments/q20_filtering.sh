#!/bin/bash
in_dir="/data1/CluHar/PacBio/CCS_data/Alignments/Minimap2/for_GATK/"
out_dir="/data1/CluHar/PacBio/CCS_data/Alignments/Minimap2/for_GATK/q20/"
samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6"
for i in ${samples}; do
        samtools view -h -q 20 -o ${out_dir}${i}.bam ${in_dir}${i}.bam &
done;