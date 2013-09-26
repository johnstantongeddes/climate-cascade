#!/bin/bash
#PBS -l walltime=48:00:00,nodes=1:ppn=4,vmem=500gb

###################################################################################################
## Script for transcriptome assembly using oases 
## running on [mason cluster](https://www.xsede.org/iu-mason)
## Author: John Stanton-Geddes
## Created: 2013-09-23
## Modified: 2013-09-25
###################################################################################################

module load velvet
module load oases

indir="/N/dc/scratch/tg-johnsg/results"
outdir="/N/dc/scratch/tg-johnsg/results/standard-oases-assembly"

# Run velveth
velveth $outdir 19,23,27,31,35,39 -fastq -shortPaired ${indir}/A22-00-interleaved.fq ${indir}/A22-03-interleaved.fq ${indir}/A22-07-interleaved.fq ${indir}/A22-10-interleaved.fq ${indir}/A22-14-interleaved.fq ${indir}/A22-17-interleaved.fq ${indir}/A22-21-interleaved.fq ${indir}/A22-24-interleaved.fq ${indir}/A22-28-interleaved.fq ${indir}/A22-31-interleaved.fq ${indir}/A22-35-interleaved.fq ${indir}/A22-38-interleaved.fq

# Run velvetg and oases
for i in 19 23 27 31 35 39 
do
    velvetg ${indir}/standard-oases-assembly_$i -read_trkg yes -ins_length 180
    oases ${indir}/standard-oases-assembly_$i 
done

# Merge assemblies
velveth ${indir}/standard-oases-assembly-merged 27 -long ${indir}/standard-oases-assembly*/transcripts.fa
velvetg ${indir}/standard-oases-assembly-merged -read_trkg yes -conserveLong yes
oases ${indir}/standard-oases-assembly-merged -merge


