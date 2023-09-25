#!/bin/bash

in_dir="/data1/CluHar/PacBio/CCS_data/Raw_data/FASTQ/"
out_dir="/data1/CluHar/PacBio/CCS_data/denovo/HiCanu_2.2/"
samples="CS2 CS4 F1 F2"
for i in ${samples}; do

/home/minal03/bin/canu-2.2/bin/canu -p ${i} -d ${out_dir}${i} genomeSize=785m -pacbio-hifi ${in_dir}${i}.ccs.fastq.gz &

done;