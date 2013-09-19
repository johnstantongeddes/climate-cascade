#!/bin/bash

module load java/1.6.0_26
module load python
module load cutadapt
module load fastqc

## Script to trim low-quality ends from reads, and then remove adapter sequences using the [trim_galore](http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/) wrapper tool.

indir="/N/dc/scratch/tg-johnsg/Project_Stanton-Geddes_Project_001" 
outdir="/N/dc/scratch/tg-johnsg/results"

# Create outdir directory for fastq files
mkdir -p $outdir

# Array of samples
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38)

# Loop across all the fastq files in the `indir` data directory
for samp in "${samples[@]}"
do
    echo "QC for $samp"
    # Run `trim_galore`.
    ~/software/trim_galore --quality 20 --phred33 --fastqc_args "--o $outdir" --length 20 --paired --output_dir $outdir $indir/${samp}-R1.fastq $indir/${samp}-R2.fastq
done


