#!/obin/bash

####################################################################################################
## Script to run [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) for mRNAseq data
## John Stanton-Geddes
## 2013-07-26
####################################################################################################

# Set PYTHONPATH to khmer module
export PYTHONPATH=/opt/software/khmer/python

indir="/home/projects/climate-cascade/projects/ApTranscriptome/data/merged-interleaved"
outdir="/home/projects/climate-cascade/projects/ApTranscriptome/data/diginorm"

# Make `outdir` if not already present
mkdir -p $outdir

# Set variables
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38)

# Make output directory for files
mkdir -p $outdir

## Loop across merged, running `normalize-by-median` with coverage threshold of 20 and kmer of 21. -N 4 -x 2e9 allocates up to 8GB RAM. 
#for samp in "${samples[@]]}"
#do
#    /opt/software/khmer/scripts/normalize-by-median.py -R diginorm.out -C 20 -k 21 -N 4 -x 2e9 $indir/${samp}.extendedFrags.fastq
#    mv ${samp}.extendedFrags.fastq.keep $outdir/.
#    date
#done

# Loop across notCombined reads, same as before but inclue `p` flag. 
for samp in "${samples[@]]}"
do
    /opt/software/khmer/scripts/normalize-by-median.py -R diginorm.out -C 20 -k 21 -N 4 -x 2e9 -p $indir/${samp}.notCombined.fastq
    mv ${samp}.notCombined.fastq.keep $outdir/.
    date
done

# One final normalization over all files. Increased memory allocation
/opt/software/khmer/scripts/normalize-by-median.py -R diginorm-final.out -C 20 -k 21 -N 4 -x 4e9 $outdir/A22*
date
