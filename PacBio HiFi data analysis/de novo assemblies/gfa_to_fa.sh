#!/bin/sh
samples="CS7 CS8 CS10 F4 F5 F6"
dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/"

for i in ${samples}; do
cd ${dir}${i} &
awk '/^S/{print ">"$2;print $3}' ${dir}${i}/${i}.asm.bp.hap1.p_ctg.gfa > ${dir}hap1_contigs/${i}.hap1.fa &
awk '/^S/{print ">"$2;print $3}' ${dir}${i}/${i}.asm.bp.hap2.p_ctg.gfa > ${dir}hap2_contigs/${i}.hap2.fa &

done;