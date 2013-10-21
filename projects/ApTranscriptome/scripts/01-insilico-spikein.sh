#!/bin/bash

###################################################################################################
## Script to generate in silico Illumina reads to include in transcriptome assembly ('spike-in') to validate recapture and assembly rate
## Author: John Stanton-Geddes
## Created: 2013-07-30
###################################################################################################

# File with *Arabidopsis* mRNA transcripts haphazardly selected from [European Nucleotide Archive](http://www.ebi.ac.uk/ena/home)

simfasta="/home/projects/climate-cascade/projects/ApTranscriptome/data/ena100.fasta"

# Assign expression-level to each sequence using the `sel` tool in [rlsim](https://github.com/sbotond/rlsim)

sel -d "1.0:g:(100, 1) + 1.0:g:(1500, 3) + 1.0:g:(10000, 10)" $simfasta > ../data/A22-si.fasta

mv sel_report.pdf ../data # move histogram of simulated expression levels to data directory

# Simulate fragments created during library prep using `rlsim`. Based on length of fragments estimated when using FLASH to pair reads, use empirical length distribution of 180 bp (SD: 20bp).
# 45,000 fragments gives about 100x coverage for 100 transcripts averaging 1000bp length

rlsim -v -n 175000 -d "1.0:n:(180, 20, 100, 500)" ../data/A22-si.fasta > A22-si-frags.fasta

# Generate simulated Illumina paired-end reads using [simNGS](http://www.ebi.ac.uk/goldman-srv/simNGS/)

cat A22-si-frags.fasta | simNGS -p paired -o fastq -O reads /opt/software/simNGS/data/s_3_4x.runfile 
# Clean up
rm A22-si-frags.fasta
mv rlsim_report.json ../data
mv reads_end1.fq ../data/A22-si-R1.fastq
mv reads_end2.fq ../data/A22-si-R2.fastq
