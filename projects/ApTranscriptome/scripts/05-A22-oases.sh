#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/merged"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-oases-assembly"

mkdir -p $outdir 

# Run velveth to make hash tables. Use k of 23 based on digital normalization to k cutoff of 23. 
# Include both paired reads (.notCombined) and unpaired that were merged 

/opt/software/oases/scripts/oases_pipeline.py -m 19 -M 25 -o $outdir -d " -fastq -shortPaired ${indir}/A22-00.notCombined.fastq.out.keep.keep ${indir}/A22-03.notCombined.fastq.out.keep.keep ${indir}/A22-07.notCombined.fastq.out.keep.keep ${indir}/A22-10.notCombined.fastq.out.keep.keep ${indir}/A22-14.notCombined.fastq.out.keep.keep ${indir}/A22-17.notCombined.fastq.out.keep.keep ${indir}/A22-21.notCombined.fastq.out.keep.keep ${indir}/A22-24.notCombined.fastq.out.keep.keep ${indir}/A22-28.notCombined.fastq.out.keep.keep ${indir}/A22-31.notCombined.fastq.out.keep.keep ${indir}/A22-35.notCombined.fastq.out.keep.keep ${indir}/A22-38.notCombined.fastq.out.keep.keep -fastq -short ${indir}/A22-00.extendedFrags.fastq.keep.keep ${indir}/A22-03.extendedFrags.fastq.keep.keep ${indir}/A22-07.extendedFrags.fastq.keep.keep ${indir}/A22-10.extendedFrags.fastq.keep.keep ${indir}/A22-14.extendedFrags.fastq.keep.keep ${indir}/A22-17.extendedFrags.fastq.keep.keep ${indir}/A22-21.extendedFrags.fastq.keep.keep ${indir}/A22-24.extendedFrags.fastq.keep.keep ${indir}/A22-28.extendedFrags.fastq.keep.keep ${indir}/A22-31.extendedFrags.fastq.keep.keep ${indir}/A22-35.extendedFrags.fastq.keep.keep ${indir}/A22-38.extendedFrags.fastq.keep.keep" -p " -min_trans_lgth 200 -ins_length 180 "


