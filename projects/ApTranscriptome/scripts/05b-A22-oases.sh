#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/03-flash"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-diginorm-flash-oases"

mkdir -p $outdir 

# velveth. Use k of 21 based on digital normalization to k cutoff of 20. 
velveth $outdir/A22-oases-21 21 -fastq.gz -shortPaired ${indir}/A22*.fq.gz.keep.abundfilt -short ${indir}/A22*.fq.gz.keep.abundfilt.se 

# velvetg 
velvetg $outdir/A22-oases-21 -read_trkg yes

# oases
oases $outdir/A22-oases-21 -ins_length 180

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py $outdir/A22-oases-21/transcripts.fa