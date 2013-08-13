#!/bin/bash

###################################################################################################
## Script to generate in silico Illumina reads to include in transcriptome assembly ('spike-in') to validate recapture and assembly rate
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################

# File with *Arabidopsis* mRNA transcripts haphazardly selected from [European Nucleotide Archive](http://www.ebi.ac.uk/ena/home)

simfasta="/home/projects/climate-cascade/projects/ApTranscriptome/data/ENA-arabidopsis-random-mRNA.fasta"

# Assign expression-level to each sequence using the `sel` tool in [rlsim](https://github.com/sbotond/rlsim)

sel -d "1.0:g:(10, 1) + 1.0:n:(1500, 3) + 1.0:n:(10000, 10)" ../data/ENA-arabidopsis-random-mRNA.fasta > ../data/simulated.fasta

# Simulate fragments created during library prep using `rlsim`. Based on length of fragments estimated when using FLASH to pair reads, use empirical length distribution of 180 bp (SD: 20bp).

rlsim -v -n 1000 -d "1:n:(180, 20, 100, 500)" ../data/simulated.fasta > simulated-frags.fasta

# Generate simulated Illumina paired-end reads using [simNGS](http://www.ebi.ac.uk/goldman-srv/simNGS/)

cat simulated-frags.fasta | simNGS -p paired -o fastq -O reads /opt/software/simNGS/data/s_3_4x.runfile 
