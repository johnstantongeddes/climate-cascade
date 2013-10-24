#!/bin/bash

###################################################################################################
## Sailfish read mapping
## Author: John Stanton-Geddes
## Created: 2013-10-23
###################################################################################################

# set up paths
export LD_LIBRARY_PATH=/opt/software/Sailfish-0.5.0-Linux_x86-64/lib:$LD_LIBRARY_PATH
export PATH=/opt/software/Sailfish-0.5.0-Linux_x86-64/bin:$PATH

# parameters
indir="../data/A22-merge-diginorm-oases-assembly"
outdir="../data/A22-merge-diginorm-oases-assembly/sailfish-out"
datadir="../data/trimclip"

mkdir -p $outdir 

# Run sailfish

# index RUN ONCE 
#sailfish index -t $indir/transcripts.fa.cap.contigs -o $outdir/transcripts.fa.cap_index -k 20 -p 4

# quantify
cd $datadir
for i in A22-**-R*_val_*.fq
do
    mkdir -p ../A22-merge-diginorm-oases-assembly/sailfish-out/${i}_quant
    sailfish quant -i ../A22-merge-diginorm-oases-assembly/sailfish-out/transcripts.fa.cap_index -o ../A22-merge-diginorm-oases-assembly/sailfish-out/${i}_quant -r $i -p 4
done


