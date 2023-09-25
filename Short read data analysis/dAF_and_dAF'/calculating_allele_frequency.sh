#!/bin/sh
out="/data1/CluHar/PacBio/CCS_data/Inversions/recombination/dAF_analysis/nonGATK_way/"
sample_dir="/data1/CluHar/PacBio/CCS_data/Inversions/recombination/dAF_analysis/nonGATK_way/samples/"
vcf="/data1/CluHar/PacBio/CCS_data/Inversions/recombination/original_vcfs/herring_sentieon_91ind_190521.SV.VF.F2.maxDPtriple.setGT.inv."


chr="chr6 chr12 chr17 chr23"
samples="all CS F"

## filter for samples, genotype, MAF
for i in ${chr}; do
        for j in ${samples}; do
                bcftools view -S ${sample_dir}${i}_${j}.txt ${vcf}${i}.vcf.gz | bcftools view -e 'F_MISSING > 0.2' -O z -o ${out}${i}_${j}_maf0.vcf.gz &
                bcftools view -S ${sample_dir}${i}_${j}.txt ${vcf}${i}.vcf.gz | bcftools view -e 'F_MISSING > 0.2 || MAF <= 0.1' -O z -o ${out}${i}_${j}_maf0.1.vcf.gz &
                bcftools view -S ${sample_dir}${i}_${j}.txt ${vcf}${i}.vcf.gz | bcftools view -e 'F_MISSING > 0.2 || MAF <= 0.2' -O z -o ${out}${i}_${j}_maf0.2.vcf.gz &
        done;
done;

wait;

## index
cd ${out}
for i in *.vcf.gz; do tabix -p vcf ${i}; done

wait;

## filter for number of alleles and calculate frequecy
for i in ${chr}; do
        for j in ${samples}; do
                vcftools --keep ${sample_dir}{i}_${j}.txt --max-alleles 2 --min-alleles 2 --gzvcf ${out}${i}_${j}_maf0.vcf.gz --freq --out ${out}${i}_${j}_maf0 &
                vcftools --keep ${sample_dir}${i}_${j}.txt --max-alleles 2 --min-alleles 2 --gzvcf ${out}${i}_${j}_maf0.1.vcf.gz --freq --out ${out}${i}_${j}_maf0.1 &
                vcftools --keep ${sample_dir}${i}_${j}.txt --max-alleles 2 --min-alleles 2 --gzvcf ${out}${i}_${j}_maf0.2.vcf.gz --freq --out ${out}${i}_${j}_maf0.2 &
        done;
done;