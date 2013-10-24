#!/bin/bash

###################################################################################################
## Script to velvet for transcriptome assembly after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

indir="../data/diginorm"
trinityout="../data/A22-merge-diginorm-trinity"

mkdir -p $trinityout

## Assemble using Trinity
# requires reads split into 'left' and 'right' files

# split paired-end .notCombined reads that passed through 
cd $indir
for i in *.notCombined.fastq.out.keep.abundfilt.pe
do
    python /home/scripts/khmer/scripts/split-paired-reads.py $i
done

# concatenate files into left and right
cat *.1 > A22-r1.fq
cat *.2 > A22-r2.fq
# confirm that files are correct length
length1=`wc -l < A22-r1.fq`
length2=`wc -l < A22-r2.fq`
sum=$(bc <<< "scale=0;($length1 + $length2)")
wc -l A22-**.notCombined.fastq.out.keep.abundfilt.pe

# add single-end unpaired reads to one file
cat *.notCombined.fastq.out.keep.abundfilt.se >> A22-r1.fq
# add single-end extendedFrags to one file
cat *.extendedFrags.fastq.keep.abundfilt >> A22-r1.fq

# run trinity
Trinity.pl --seqType fq --JM 50G --left A22-r1.fq --right A22-r2.fq --output $trinityout 

# Summary statistics
cd ../../scripts/
python /home/scripts/khmer/sandbox/assemstats2.py 100 $outdir/Trinity.fasta

