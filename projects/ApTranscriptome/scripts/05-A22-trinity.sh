#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"
trinityout="/home/projects/climate-cascade/projects/ApTranscriptome/data/A22-oases-assembly"

mkdir -p $trinityout

## Assemble using Trinity
# split interleaved files
for i in *.extendedFrags.fastq.keep.abundfilt
do
    python /home/scripts/khmer/scripts/split-paired-reads.py $i
done

# concatenate files into left and right
cat *.1 > A22-r1.fq
cat *.2 > A22-r2.fq

# add unpaired reads to one file
cat *.notCombined.fastq.keep.abundfilt >> A22-r1.fq

# run trinity
Trinity.pl --seqType fq --JM 50G --left A22-r1.fq --right A22-r2.fq --output $trinityout 

# Summary statistics
python /opt/software/khmer/sandbox/assemstats2.py 100 $outdir/A22-oases-21/transcripts.fa

