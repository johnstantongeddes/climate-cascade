#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

mergeddir="/home/projects/climate-cascade/projects/ApTranscriptome/data/FLASH"
diginormdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-diginorm-flash-oases"

mkdir -p $outdir 

# velveth. Use k of 21 based on digital normalization to k cutoff of 20. 
# three channels: shortPaired are reads not combined by FLASH. short are reads combined by FLASH. short2 are orphaned reads after diginorm
velveth $outdir/A22-oases-21 21 -fastq.gz -shortPaired ${mergeddir}/A22-**.notCombined.fastq -short ${mergeddir}/A22-**.extendedFrags.fastq  -short2 ${diginormdir}/A22*.abundfilt.se 

# velvetg 
velvetg $outdir/A22-oases-21 -read_trkg yes

# oases
oases $outdir/A22-oases-21 -ins_length 180

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py 100 $outdir/A22-oases-21/transcripts.fa

