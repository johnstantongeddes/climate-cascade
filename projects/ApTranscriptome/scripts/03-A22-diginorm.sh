#!/bin/bash

###################################################################################################
## Script to run [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) for mRNAseq data
## Author: John Stanton-Geddes
## Created: 2013-07-26
## Modified: 2013-07-30 
###################################################################################################

# Set PYTHONPATH to khmer module
export PYTHONPATH=/opt/software/khmer/python

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/trimclip"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"

# Make `outdir` if not already present
mkdir -p $outdir

# Set variables
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38 A22-spikein)

# Make output directory for files
mkdir -p $outdir

# Interleave paired-end reads for diginorm
for samp in "${samples[@]]}"
do
    # Interleave and zip 
    /opt/software/khmer/scripts/interleave-reads.py ${samp}-R1_val_1.fq ${samp}-R2_val_2.fq | gzip -9c > ${samp}-pe.fq.gz

    # Make it hard to delete files
    chmod ug-w *.fq.gz
    echo "Interleaved $samp" `date`
done

# Digital normalization. Run `normalize-by-median` specifying paired-end (-p) reads with coverage threshold and kmer of 20. -N 4 -x 3e9 allocates up to 12GB RAM. 

echo "Start digital normalization" `date`
/opt/software/khmer/scripts/normalize-by-median.py -R diginorm.out -p -C 20 -k 20 -N 4 -x 3e9 --savehash A22normC20k20.kh *pe.fq.gz

# Trim likely erroneous k-mers. Note that this will orphan some reads with poor quality partners
echo "Trim erroreous k-mers" `date`
/opt/software/khmer/scripts/filter-abund.py -V A22normC20k20.kh *fq.gz.keep

# Separate orphaned from still-paired reads
echo "Separate orphaned from still-paired reads" `date`
for i in *gz.keep.abundfilt
do 
    /opt/software/khmer/scripts/extract-paired-reads.py $i
done

# Move files to diginorm directory and remove intermediate files
echo "Move final files and clean-up" `date`
mv *.abundfilt.pe ../diginorm/
mv *.abundfilt.se ../diginorm/

rm *.abundfilt
rm *.keep