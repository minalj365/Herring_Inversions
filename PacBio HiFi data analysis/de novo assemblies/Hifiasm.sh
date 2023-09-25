#!/bin/sh

in_dir="/data1/CluHar/PacBio/CCS_data/Raw_data/FASTQ/"
out_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/"
samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6"

for i in ${samples}; do

cd ${out_dir}
mkdir ${i} &

~/bin/hifiasm/hifiasm -o ${out_dir}${i}/${i}.asm -t 8 ${in_dir}${i}.ccs.fastq.gz &

done;