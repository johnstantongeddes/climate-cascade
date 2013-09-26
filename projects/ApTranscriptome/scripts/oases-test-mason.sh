#!/bin/bash
#PBS -l nodes=1:ppn=1,vmem=120gb,walltime=48:00:00


###################################################################################################
## Script for transcriptome assembly using oases 
## running on [mason cluster](https://www.xsede.org/iu-mason)
## Author: John Stanton-Geddes
## Created: 2013-09-23
###################################################################################################

module load velvet
module load oases

indir="/N/dc/scratch/tg-johnsg/results"
outprefix="test-oases-assembly"

cd $indir

# Run velveth
velveth $outprefix 19 -shortPaired -fastq A22-00-interleaved.fq A22-03-interleaved.fq A22-07-interleaved.fq A22-10-interleaved.fq A22-14-interleaved.fq A22-17-interleaved.fq A22-21-interleaved.fq A22-24-interleaved.fq A22-28-interleaved.fq A22-31-interleaved.fq A22-35-interleaved.fq A22-38-interleaved.fq

# Run velvetg
velvetg ${outprefix}_19 -read_trkg yes -ins_length 180

# Run oases
oases ${outprefix}_19

