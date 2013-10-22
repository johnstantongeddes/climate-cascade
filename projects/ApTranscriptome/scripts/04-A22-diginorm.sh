#!/bin/bash

###################################################################################################
## Script to run [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) for mRNAseq data
## Author: John Stanton-Geddes
## Created: 2013-07-26
###################################################################################################

# Set PYTHONPATH to khmer module
export PYTHONPATH=/opt/software/khmer/python

indir="../data/merged1"
outdir="../data/diginorm"

# Make `outdir` if not already present
mkdir -p $outdir

# Set variables
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38 A22-si)

cd $indir

## Digital normalization
echo "Start digital normalization" `date`
# run `normalize-by-median` for extendedFragments with coverage threshold and kmer of 20. -N 4 -x 3e9 allocates up to 12GB RAM. 

/opt/software/khmer/scripts/normalize-by-median.py -R diginorm.out -C 20 -k 20 -N 4 -x 3e9 --savehash A22-extendedFragsC20k20.kh *.extendedFrags.fastq

# first need to add Illumina 1.3 style read tags /1 and /2 to 
for samp in "${samples[@]]}"
do
    /home/projects/climate-cascade/scripts/interleave-illumina-backward.py ${samp}.notCombined.fastq > ${samp}.notCombined.fastq.out
done

# run 'normalize-by-median' for paired-end reads. load hash of previously saved read filtering
/opt/software/khmer/scripts/normalize-by-median.py -R diginorm-paired.out -p -C 20 -k 20 -N 4 -x 4e9 --loadhash A22-extendedFragsC20k20.kh --savehash A22-extendedFragsC20k20.kh *.notCombined.fastq.out

# Trim likely erroneous k-mers. Note that this will orphan some reads with poor quality partners
echo "Trim errorneous k-mers" `date`
/opt/software/khmer/scripts/filter-abund.py -V A22-extendedFragsC20k20.kh *.keep

# Separate orphaned from still-paired reads in .notCombined.fastq.out.keep.abundfilt
echo "Separate orphaned from still-paired reads" `date`
for i in *.notCombined.fastq.out.keep.abundfilt
do 
    /opt/software/khmer/scripts/extract-paired-reads.py $i
done

# Move files to diginorm directory and remove intermediate files
echo "Move final files and clean-up" `date`
mv *.abundfilt ../diginorm/
mv *.abundfilt.pe ../diginorm/
mv *.abundfilt.se ../diginorm/

rm *.abundfilt
rm *.keep