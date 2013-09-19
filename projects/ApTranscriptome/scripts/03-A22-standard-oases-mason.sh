#!/bin/bash

###################################################################################################
## Script for transcriptome assembly using oases
## "standard" assembly on quality trimmed Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-09-18
###################################################################################################

module load python
module load velvet
module load oases

indir="/N/dc/scratch/tg-johnsg/results"
outdir="/N/dc/scratch/tg-johnsg/results/standard-oases-assembly"

~/software/oases/scripts/oases_pipeline.py -c -m 19 -M 49 -o $outdir -d " -fastq -shortPaired ${indir}/A22-00-interleaved.fq ${indir}/A22-03-interleaved.fq ${indir}/A22-07-interleaved.fq ${indir}/A22-10-interleaved.fq ${indir}/A22-14-interleaved.fq ${indir}/A22-17-interleaved.fq ${indir}/A22-21-interleaved.fq ${indir}/A22-24-interleaved.fq ${indir}/A22-28-interleaved.fq ${indir}/A22-31-interleaved.fq ${indir}/A22-35-interleaved.fq ${indir}/A22-38-interleaved.fq " -p " -min_trans_lgth 100 -ins_length 180 "


