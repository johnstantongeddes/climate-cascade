#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"
oasesout="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-oases-assembly"
trinityout="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-oases-assembly"

mkdir -p $outdir 
mkdir -p $trinityout

## Assemble using velvet-oases
# Include both paired reads (.notCombined) and unpaired (.extendedFrags) that were merged 

# velveth. Use k of 21 based on digital normalization to k cutoff of 20. 
velveth $outdir/A22-oases-21 21 -fastq -short ${indir}/A22-**.extendedFrags.fastq.keep.abundfilt -shortPaired ${indir}/A22-**-.notCombined.fastq.keep.abundfilt.pe  ${indir}/A22-**-.notCombined.fastq.keep.abundfilt.se 

# velvetg 
velvetg $outdir/A22-oases-21 -read_trkg yes

# oases
oases $outdir/A22-oases-21 -ins_length 200

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py 100 $outdir/A22-oases-21/transcripts.fa



## Assemble using Trinity
# concatenate files into left and right
Trinity.pl --seqType fq --JM 50G --left A22-r1.fq --right A22-r2.fq --output $trinityout 
