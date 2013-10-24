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

# Use [CAP3]() to reduce redundancy in contigs
cd $oasesout
cap3 A22-oases-21/transcripts.fa > transcripts.out
mv transcripts.out
mv transcripts.fa.c* ../

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py 100 transcripts.fa.cap.contigs
