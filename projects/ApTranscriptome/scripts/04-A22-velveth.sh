#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-oases"

mkdir -p $outdir 

# Run velveth to make hash tables. Use k of 23 based on digital normalization to k cutoff of 23. 
# Include both paired reads (.notCombined) and unpaired that were merged 

# velveth 
velveth $outdir/A22-oases-21 21 -fastq -shortPaired ${indir}/A22*.fastq.out.keep.keep -short ${indir}/A22*.extendedFrags.fastq.keep.keep 
# velvetg
velvetg $outdir/A22-oases-21 -read_trkg yes
# oases
oases $outdir/A22-oases-21 -min_trans_lgth 200 -ins_length 180
