#!/bin/bash

###################################################################################################
## Script for transcriptome assembly using [velvet-oases](http://www.ebi.ac.uk/~zerbino/oases/) after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
###################################################################################################

indir="../data/diginorm"
oasesout="../data/A22-merge-diginorm-oases-assembly"

mkdir -p $oasesout 

## Assemble using velvet-oases
# Include both paired reads (.notCombined) and unpaired (.extendedFrags) that were merged 

# velveth. Use k of 21 based on digital normalization to k cutoff of 20. 
velveth $oasesout/A22-oases-21 21 -fastq -short ${indir}/A22-**.extendedFrags.fastq.keep.abundfilt  ${indir}/A22-**.notCombined.fastq.out.keep.abundfilt.se -shortPaired ${indir}/A22-**.notCombined.fastq.out.keep.abundfilt.pe

# velvetg 
velvetg $oasesout/A22-oases-21 -read_trkg yes

# oases
oases $oasesout/A22-oases-21 -ins_length 200

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py 100 $oasesout/A22-oases-21/transcripts.fa


##---------Post-process contigs-----------------------------

# Use [CAP3](http://computing.bio.cam.ac.uk/local/doc/cap3.txt) to reduce redundancy in contigs
# -f 80 # max gap length of overlap 
# -k 0 # specifies no read clipping as reads already quality trimmed
# -p 95 # require 95% overlap similarity
# -r 0 # all reads in forward orientation as already assembled
#
# specify reads are in forward orientation only '-r 0'
# output is a file of combined reads (*.cap.contigs) and remaining un-combined reads (*.cap.singlets)

cd $oasesout
cap3 A22-oases-21/transcripts.fa > transcripts.out

# Move files
mkdir -p cap3
mv transcripts.out cap3
mv transcripts.fa.c* cap3

# Concatenate contigs and singlets as final transcripts file
cd cap3
cat transcripts.fa.cap.contigs transcripts.fa.cap.singlets > transcripts-cap3.fa

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py 100 transcripts-cap3.fa
