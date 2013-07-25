#!/bin/bash


filedir="/home/jstantongeddes/climate-cascade/projects/AphTranscriptome/results/02-shuffled"
outdir="/home/jstantongeddes/climate-cascade/projects/AphTranscriptome/results/A22-velvet_61"

mkdir -p $outdir 

# Run velveth to make hash tables

velveth $outdir 61 -fastq -shortPaired $filedir/A22-00-shuffled.fastq

# Run velvetg

velvetg $outdir -read_trkg yes

# Run oases

oases $outdir -ins_length 200

