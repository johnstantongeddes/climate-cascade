#!/bin/bash

###################################################
## Script to merge paired reads using [FLASH](http://sourceforge.net/projects/flashpage/)
## John Stanton-Geddes
## 2013-07-26
####################################################i

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/merged"

# Set variables
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38 A22-spikein)

# Make output directory for files
mkdir -p $outdir

# Loop across samples, running FLASH to merge reads. Specify phred-offset 33, interleaved output for velvet, and output-prefix to samp
for samp in "${samples[@]]}"
do
    echo "Running FLASH for $samp"
    flash --phred-offset 33 --interleaved-output --output-directory $outdir --output-prefix $samp ${indir}/${samp}-R1_val_1.fq ${indir}/${samp}-R2_val_2.fq
    date
    eacho "$samp done"
done
