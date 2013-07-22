#!/bin/bash

## Script to trim low-quality ends from reads, and then remove adapter sequences using the [trim_galore](http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/) wrapper tool.

indir="/home/data/Aphaeno_transcriptome/130509_SN1073_0326_BD25DAACXX/Project_Stanton-Geddes_Project_001" 
outdir="/home/projects/climate-cascade/projects/AphTranscriptome/results/01-trimclip" 

# Create outdir directory if it doesn't exit
mkdir -p ../results/01-trimclip


# Run `trim_galore` 
trim_galore --quality 20 --phred33 --fastqc_args "--o /home/projects/climate-cascade/projets/AphTranscriptome/results/01-trimclip" --length 20 --paired --output_dir $outdir $indir/A22-0_ATCACG_L006_R1_001.fastq $indir/A22-0_ATCACG_L006_R2_001.fastq
