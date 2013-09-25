#!/bin/bash

###################################################################################################
## Script to interleave files for velvet-oases
## Author: John Stanton-Geddes
## Created: 2013-09-18
###################################################################################################

module load python

indir="/N/dc/scratch/tg-johnsg/results"

## Interleaved reads for all samples

# Array of samples
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38)

# Loop across all the fastq files in the `indir` data directory

for samp in "${samples[@]}"
do
    echo "Interleave files for $samp"
    ~/climate-cascade/scripts/interleave_fastq.py -l $indir/${samp}-R1_val_1.fq -r $indir/${samp}-R2_val_2.fq -o $indir/${samp}-interleaved.fq
done
