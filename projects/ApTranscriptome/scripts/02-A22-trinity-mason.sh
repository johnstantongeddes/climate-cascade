#!/bin/bash
#PBS -l walltime=48:00:00,nodes=1:ppn=4,vmem=180gb

###################################################################################################
## Script for transcriptome assembly using trinity 
## running on [mason cluster](https://www.xsede.org/iu-mason)
## Author: John Stanton-Geddes
## Created: 2013-09-25
###################################################################################################

module load trinityrnaseq

indir="/N/dc/scratch/tg-johnsg/results"
outdir="trinity-assembly"

cd $indir

# Concatenate files for trinity
cat A22-00-R2_val_1.fq A22-03-R1_val_1.fq A22-07-R1_val_1.fq A22-10-R1_val_1.fq A22-14-R1_val_1.fq A22-17-R1_val_1.fq A22-21-R1_val_1.fq A22-24-R1_val_1.fq A22-28-R1_val_1.fq A22-31-R1_val_1.fq A22-35-R1_val_1.fq A22-38-R1_val_1.fq > A22-r1.fq
cat A22-00-R2_val_2.fq A22-03-R2_val_2.fq A22-07-R2_val_2.fq A22-10-R2_val_2.fq A22-14-R2_val_2.fq A22-17-R2_val_2.fq A22-21-R2_val_2.fq A22-24-R2_val_2.fq A22-28-R2_val_2.fq A22-31-R2_val_2.fq A22-35-R2_val_2.fq A22-38-R2_val_2.fq > A22-r2.fq

# Run trinity
Trinity.pl --seqType fq --JM 160G --left A22-r1.fq --right A22-r2.fq  --output $outdir --CPU 4
