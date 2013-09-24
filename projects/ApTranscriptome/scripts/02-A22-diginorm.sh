#!/bin/bash

###################################################################################################
## Script to run [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) for mRNAseq data
## Author: John Stanton-Geddes
## Created: 2013-07-26
## Modified: 2013-07-30 
###################################################################################################

# Set PYTHONPATH to khmer module
export PYTHONPATH=/opt/software/khmer/python

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/01-trimclip"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/02-diginorm"

cd indir/

# Make `outdir` if not already present
mkdir -p $outdir

# Set variables
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38 A22-spikein)

# Make output directory for files
mkdir -p $outdir

## Digital normalization. First interleave paired-end reads. Then run `normalize-by-median` specifying paired-end (-p) reads with coverage threshold and kmer of 20. -N 4 -x 3e9 allocates up to 12GB RAM. 
for samp in "${samples[@]]}"
do
    # Interleave and zip 
    python /home/projects/climate-cascade/scripts/interleave.py ${samp}-R1_val_1.fq ${samp}-R2_val_2.fq | gzip > ${samp}-pe.fq.gz

    # Make it hard to delete files
    chmod ug-w *.fq.gz

    # digital normalization
    /opt/software/khmer/scripts/normalize-by-median.py -R diginorm.out -p -C 20 -k 20 -N 4 -x 3e9 ${samp}-pe.fq.gz
    mv ${samp}-pe.fq.gz.keep  $outdir/.
    echo "Diginorm done for $samp" `date`
done

# One final normalization over all files. Increased memory allocation
/opt/software/khmer/scripts/normalize-by-median.py -R diginorm-final.out -p -C 20 -k 20 -N 4 -x 4e9 --save-hash A22normC20k20.kh $outdir/A22*
# Move final normalized files to data directory
mv A22* $outdir/.
echo "Final diginorm done" `date`

# Trim likely erroneous k-mers
/opt/software/khmer/scripts/filter-abund.py -V $outdir/A22normC20k20.kh *.keep