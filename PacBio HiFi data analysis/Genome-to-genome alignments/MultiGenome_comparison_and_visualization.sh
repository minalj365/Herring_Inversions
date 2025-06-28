#!/bin/sh
######### 200 kb flanking region of chr12 inversion ######

######## chr12 #########
samtools faidx /data1/CluHar/Genomes/Assembly_v2.0.2/Ch_v2.0.2.fasta chr12:17626318-25803093 > chr12.fasta

hap1_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap1_contigs/"
hap2_dir="/data1/CluHar/PacBio/CCS_data/denovo/hifiasm/hap2_contigs/"
out_dir="/data1/CluHar/PacBio/CCS_data/Inversions/chr12/complete_inversion/200kb_flanking/"

mummer="/home/minal03/bin/mummer-4.0.0rc1/"
samples="CS2 CS4 CS5 CS7 CS8 CS10 F1 F2 F3 F4 F5 F6 NSSH2 NSSH10"

cd ${out_dir}
mkdir hap1 hap2
mkdir -p hap1/nucmer hap2/nucmer
mkdir -p hap1/paf hap2/paf
mkdir -p hap1/analysis hap2/analysis

# nucmer alignments
for i in ${samples}; do
${mummer}nucmer --batch=1 -l 100 -c 500 -t 8 ${out_dir}chr12.fasta ${hap1_dir}${i}.hap1.fa --delta=${out_dir}hap1/nucmer/${i}.delta &
${mummer}nucmer --batch=1 -l 100 -c 500 -t 8 ${out_dir}chr12.fasta ${hap2_dir}${i}.hap2.fa --delta=${out_dir}hap2/nucmer/${i}.delta &
done;


sleep 1000s;


################## processing hap1 ################
# generating paf files
cd ${out_dir}hap1/nucmer
for i in *.delta; do paftools.js delta2paf ${i} > ${out_dir}hap1/paf/${i}.paf; done
sleep 10s;

##### naming directories ###
analysis_dir="${out_dir}hap1/analysis/"
paf_dir="${out_dir}hap1/paf/"

cd ${analysis_dir}
mkdir mummerplot_layout mummerplot

for i in ${samples}; do
cd ${analysis_dir}
mkdir ${i}
done;


#### awk script to parse the paf alignment file #######
for i in ${samples}; do
cd ${analysis_dir}${i}
mkdir awk_out tig_positions spaced_names fasta MUMmer

        cat ${paf_dir}${i}.delta.paf | awk '{if($11>10000) print;}' > ${analysis_dir}${i}/awk_out/${i}
done;

##### Obtaining contig names #####

for i in ${samples}; do

        cat ${analysis_dir}${i}/awk_out/${i} | awk '{print $1}' | uniq > ${analysis_dir}${i}/tig_positions/${i}
done;

##### combining all positions in one line

for i in ${samples}; do

        tr '\n' ' ' < ${analysis_dir}${i}/tig_positions/${i} > ${analysis_dir}${i}/spaced_names/${i}
done;

##### Obtaining sequences corresponding to positions #######


for i in ${samples}; do
names(){
        cat ${analysis_dir}${i}/spaced_names/${i}
}
done;

for i in ${samples}; do
echo "samtools faidx ${hap1_dir}${i}.hap1.fa $(names) > ${analysis_dir}${i}/fasta/${i}.fasta" >> ${analysis_dir}${i}/fasta/samtools_faidx.sh

echo "samtools faidx /data1/CluHar/Genomes/Assembly_v2.0.2/Ch_v2.0.2.fasta chr12:17626318-25803093 > Ref.fasta" >> ${analysis_dir}${i}/fasta/samtools_faidx.sh

cd ${analysis_dir}${i}/fasta
bash samtools_faidx.sh

done;

### MUMmer ########
for i in ${samples}; do
cd ${analysis_dir}${i}/MUMmer
nucmer -c 500 -l 100 --maxmatch ${analysis_dir}${i}/fasta/Ref.fasta ${analysis_dir}${i}/fasta/${i}.fasta &
done;

sleep 30s;

### mummerplot ####

for i in ${samples}; do
mummerplot --postscript --layout -p ${analysis_dir}mummerplot_layout/${i}_hap1 ${analysis_dir}${i}/MUMmer/out.delta
mummerplot --postscript -p ${analysis_dir}mummerplot/${i}_hap1 ${analysis_dir}${i}/MUMmer/out.delta

done;


################## processing hap2 ################
# generating paf files
cd ${out_dir}hap2/nucmer
for i in *.delta; do paftools.js delta2paf ${i} > ${out_dir}hap2/paf/${i}.paf; done
sleep 10s;

##### naming directories ###
analysis_dir="${out_dir}hap2/analysis/"
paf_dir="${out_dir}hap2/paf/"

cd ${analysis_dir}
mkdir mummerplot_layout mummerplot

for i in ${samples}; do
cd ${analysis_dir}
mkdir ${i}
done;


#### awk script to parse the paf alignment file #######
for i in ${samples}; do
cd ${analysis_dir}${i}
mkdir awk_out tig_positions spaced_names fasta MUMmer

        cat ${paf_dir}${i}.delta.paf | awk '{if($11>10000) print;}' > ${analysis_dir}${i}/awk_out/${i}
done;

##### Obtaining contig names #####

for i in ${samples}; do

        cat ${analysis_dir}${i}/awk_out/${i} | awk '{print $1}' | uniq > ${analysis_dir}${i}/tig_positions/${i}
done;

##### combining all positions in one line

for i in ${samples}; do

        tr '\n' ' ' < ${analysis_dir}${i}/tig_positions/${i} > ${analysis_dir}${i}/spaced_names/${i}
done;

##### Obtaining sequences corresponding to positions #######


for i in ${samples}; do
names(){
        cat ${analysis_dir}${i}/spaced_names/${i}
}
done;

for i in ${samples}; do
echo "samtools faidx ${hap2_dir}${i}.hap2.fa $(names) > ${analysis_dir}${i}/fasta/${i}.fasta" >> ${analysis_dir}${i}/fasta/samtools_faidx.sh

echo "samtools faidx /data1/CluHar/Genomes/Assembly_v2.0.2/Ch_v2.0.2.fasta chr12:17626318-25803093 > Ref.fasta" >> ${analysis_dir}${i}/fasta/samtools_faidx.sh

cd ${analysis_dir}${i}/fasta
bash samtools_faidx.sh

done;

### MUMmer ########
for i in ${samples}; do
cd ${analysis_dir}${i}/MUMmer
nucmer -c 500 -l 100 --maxmatch ${analysis_dir}${i}/fasta/Ref.fasta ${analysis_dir}${i}/fasta/${i}.fasta &
done;

sleep 30s;

### mummerplot ####

for i in ${samples}; do
mummerplot --postscript --layout -p ${analysis_dir}mummerplot_layout/${i}_hap2 ${analysis_dir}${i}/MUMmer/out.delta
mummerplot --postscript -p ${analysis_dir}mummerplot/${i}_hap2 ${analysis_dir}${i}/MUMmer/out.delta

done;
