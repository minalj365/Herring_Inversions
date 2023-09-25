#!/bin/sh
hap1_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap1_contigs/"
hap2_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap2_contigs/"
out_dir="/data1/CluHar/PacBio/CCS_data/BUSCO/hifiasm/new/"

samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6"

for i in ${samples}; do
        cd ${out_dir}
        mkdir ${i}_hap1 ${i}_hap2

        cd ${out_dir}${i}_hap1
        busco -f -m genome -i ${hap1_dir}${i}.hap1.fa -o Out --out_path ${out_dir}${i}_hap1 -l vertebrata_odb10 -c 4 &

     cd ${out_dir}${i}_hap2
        busco -f -m genome -i ${hap2_dir}${i}.hap2.fa -o Out --out_path ${out_dir}${i}_hap2 -l vertebrata_odb10 -c 4 &
done;