#!/bin/bash

###################################################################################################
## Script to generate simulate Illumina RNAseq data and validate transcriptome assembly
## Author: John Stanton-Geddes
## Created: 2013-08-12
###################################################################################################

# Set PYTHONPATH to khmer module
export PYTHONPATH=/opt/software/khmer/python

# File with *Arabidopsis* mRNA transcripts haphazardly selected from [European Nucleotide Archive](http://www.ebi.ac.uk/ena/home)

simfasta="/home/projects/climate-cascade/projects/ApTranscriptome/data/ENA-arabidopsis-random-mRNA.fasta"
datadir="/home/projects/climate-cascade/projects/ApTranscriptome/data" 

## Assign expression-level to each sequence using the `sel` tool in [rlsim](https://github.com/sbotond/rlsim)

sel -d "1.0:g:(1500, 3)" $simfasta > ../data/ena-simulated.fasta
echo "Done with expression levels: " `date`

## Simulate fragments created during library prep using `rlsim`. Based on length of fragments estimated when using FLASH to pair reads, use empirical length distribution of 180 bp (SD: 20bp).

rlsim -v -n 100000 -d "1:n:(180, 20, 100, 500)" ../data/ena-simulated.fasta > ../data/ena-simulated-frags.fasta
echo "Done with simulated fragmentation levels: " `date`

## Generate simulated Illumina paired-end reads using [simNGS](http://www.ebi.ac.uk/goldman-srv/simNGS/)
# output is 'reads_end1.fq' and 'reads_end2.fq'
cat ../data/ena-simulated-frags.fasta | simNGS -p paired -o fastq -O reads /opt/software/simNGS/data/s_3_4x.runfile
# Move files to data directory
mv reads_end[12].fq ../data/.
echo "Done with Illumina read simulation: " `date`

## Run through TrimGalore for adapter cutting and quality trimming
trim_galore --quality 20 --phred33 --fastqc_args "--o $datadir" --length 20 --paired --output_dir $datadir $datadir/reads_end1.fq $datadir/reads_end2.fq
echo "Done with quality trimming: " `date`

## Run digital normalization with khmer
# interleave file
/opt/software/khmer/sandbox/interleave.py $datadir/reads_end1_val_1.fq $datadir/reads_end2_val_2.fq > ../data/sim-interleaved.fastq

# run diginorm
/opt/software/khmer/scripts/normalize-by-median.py -R diginorm-final.out -C 20 -k 21 -N 4 -x 4e9 $datadir/sim-interleaved.fastq
echo "Done with interleaving files:" `date`

# Merge reads with FLASH
flash --phred-offset 33 --interleaved-input --interleaved-output --output-directory $datadir $datadir/sim-normalized.fastq

# Assemble transcriptome with velvet-oases
#velveth 

# Map simulated reads to velvet-oases transcriptome with BWA


# Assemble transcriptome with Trinity using built-in normalization


# Map simulated reads to Trinity assembly with BWA