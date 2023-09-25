#!/bin/sh

# alignment of pacbio data
/data1/_software/minimap2/minimap2 -xmap-pb -t 32 /data1/CluHar/PacBio/Celtic_Sea_CCS_data/denovo/HiCanu_2.0/CS5/CS5.contigs.fasta /data1/CluHar/PacBio/Celtic_Sea_CCS_data/Raw_data/CS5.ccs.fastq.gz | gzip -c - > asm.paf.gz

#calculate read depth histogram and base level read depth
/data1/_software/purge_dups/bin/pbcstat asm.paf.gz
# output is PB.base.cov and PB.stat

/data1/_software/purge_dups/bin/calcuts PB.stat > cutoffs 2>calcults.log

#Plot histogram
/data1/_software/purge_dups/scripts/hist_plot.py PB.stat stat.pdf
/data1/_software/purge_dups/scripts/hist_plot.py PB.base.cov hist.base.cov.pdf
# Plotting cutoffs over plot
/data1/_software/purge_dups/scripts/hist_plot.py -c cutoffs PB.stat PB.cov.pdf

# split an assembly and do self-alignment (do simultaneously as 1st minimap2 alignment)
/data1/_software/purge_dups/bin/split_fa /data1/CluHar/PacBio/Celtic_Sea_CCS_data/denovo/HiCanu_2.0/CS5/CS5.contigs.fasta > asm.split
/data1/_software/minimap2/minimap2 -xasm5 -DP -t 12 asm.split asm.split | gzip -c - > asm.split.self.paf.gz



#Purge haplotigs and overlaps
/data1/_software/purge_dups/bin/purge_dups -2 -T cutoffs -c PB.base.cov asm.split.self.paf.gz > dups.bed 2> purge_dups.log

#Get purged primary and haplotig sequences from draft assembly
/data1/_software/purge_dups/bin/get_seqs dups.bed /data1/CluHar/PacBio/Celtic_Sea_CCS_data/denovo/HiCanu_2.0/CS5/CS5.contigs.fasta