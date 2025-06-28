#!/bin/sh
snps_vcf="/data1/CluHar/PacBio/CCS_data/Inversions/recombination/vcf/SNPs/"
out="/data1/CluHar/PacBio/CCS_data/Inversions/recombination/vcf/all/"

############## get all sample names in one file ###############
CHR="chr6 chr12 chr17 chr23"
for chr in ${CHR}; do cat ${out}CS_${chr}.txt ${out}F_${chr}.txt > ${out}all_${chr}.txt; done


############### FILTERING with bcftools: samples, region, F_missing, and MAF ################
array=("chr6" "chr12" "chr17" "chr23")
array2=("chr6:21782765-25368581" "chr12:17326318-26103093" "chr17:25305445-27568510" "chr23:15726443-18104273")

for i in "${!array[@]}" # && pos in {POS[@]} #(( i=0; i<${#CHR[@]}; i++ ));
do
        ## all CS and F samples
        bcftools view -S ${out}all_"${array[i]}".txt -r "${array2[i]}" -e 'F_MISSING > 0.2' -O z -o ${out}"${array[i]}"_all_maf0.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        bcftools view -S ${out}all_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2 || MAF <= 0.1" -O z -o ${out}"${array[i]}"_all_maf0.1.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        bcftools view -S ${out}all_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2 || MAF <= 0.2" -O z -o ${out}"${array[i]}"_all_maf0.2.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        ## only CS samples
        bcftools view -S ${out}CS_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2" -O z -o ${out}"${array[i]}"_CS_maf0.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        bcftools view -S ${out}CS_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2 || MAF <= 0.1" -O z -o ${out}"${array[i]}"_CS_maf0.1.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        bcftools view -S ${out}CS_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2 || MAF <= 0.2" -O z -o ${out}"${array[i]}"_CS_maf0.2.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        ## only F samples
        bcftools view -S ${out}F_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2" -O z -o ${out}"${array[i]}"_F_maf0.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        bcftools view -S ${out}F_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2 || MAF <= 0.1" -O z -o ${out}"${array[i]}"_F_maf0.1.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
        bcftools view -S ${out}F_"${array[i]}".txt -r "${array2[i]}" -e "F_MISSING > 0.2 || MAF <= 0.2" -O z -o ${out}"${array[i]}"_F_maf0.2.vcf.gz ${snps_vcf}"${array[i]}"_SNPs.vcf.gz &
done;

wait;

############## calculate allele frequency using vcftools ##############
cd ${out}

for i in *.vcf.gz; do
        vcftools --gzvcf ${i} --freq --out ${i}
done;

###### rename frq file ####
for i in *.vcf.gz.frq; do
        newname=$(echo $i | sed 's/vcf.gz.frq/frq/')
        mv $i $newname
done;
