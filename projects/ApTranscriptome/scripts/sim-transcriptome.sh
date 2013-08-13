#!/bin/bash

###################################################################################################
## Script to generate simulate Illumina RNAseq data and validate transcriptome assembly
## Author: John Stanton-Geddes
## Created: 2013-08-12
###################################################################################################

# File with *Arabidopsis* mRNA transcripts haphazardly selected from [European Nucleotide Archive](http://www.ebi.ac.uk/ena/home)

simfasta="/home/projects/climate-cascade/projects/ApTranscriptome/data/ENA-arabidopsis-random-mRNA.fasta"

# Assign expression-level to each sequence using the `sel` tool in [rlsim](https://github.com/sbotond/rlsim)

sel -d "1.0:n:(1500, 3)" ../data/ena.fasta > ../data/ena-simulated.fasta

# Simulate fragments created during library prep using `rlsim`. Based on length of fragments estimated when using FLASH to pair reads, use empirical length distribution of 180 bp (SD: 20bp).

rlsim -v -n 1000 -d "1:n:(180, 20, 100, 500)" ../data/simulated.fasta > simulated-frags.fasta

# Generate simulated Illumina paired-end reads using [simNGS](http://www.ebi.ac.uk/goldman-srv/simNGS/)
# output is 'reads_end1.fq' and 'reads_end2.fq'

cat simulated-frags.fasta | simNGS -p paired -o fastq -O reads /opt/software/simNGS/data/s_3_4x.runfile > ../data/sim-reads.fastq

# Run through TrimGalore for adapter cutting and quality trimming

simdir="/home/projects/climate-cascade/projects/AphTranscriptome/data" 

trim_galore --quality 20 --phred33 --fastqc_args "--o $simdir" --length 20 --paired --output_dir $simdir $simdir

# Run digital normalization with khmer


# Merge reads with FLASH


# Assemble transcriptome with velvet-oases


# Map simulated reads to velvet-oases transcriptome with BWA


# Assemble transcriptome with Trinity using built-in normalization


# Map simulated reads to Trinity assembly with BWA