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
readsdir="../data/trimclip"

mkdir -p $outdir 

### Run sailfish to map reads to alignment

## Make index on CAP3 reduced transcripts. Only needs to be run once
# check if index exists. if not, generate index]
if [ ! -f $outdir/transcripts-cap3-index/transcriptome.tgm ]
then
    echo "Index does not exist"
    echo "Creating index" `date`
    sailfish index -t $indir/cap3/transcripts-cap3.fa -o $outdir/transcripts-cap3-index -k 20 -p 4
else
    echo "Index exists"
fi


## Quantify
cd $readsdir

# loop across samples, mapping reads from paired samples at same time
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38 A22-si)

for samp in "${samples[@]]}"
do
    # directory for results
    mkdir -p ../A22-merge-diginorm-oases-assembly/sailfish-out/${samp}_quant
    # quanity read counts 
    sailfish quant -i ../A22-merge-diginorm-oases-assembly/sailfish-out/transcripts-cap3-index -o ../A22-merge-diginorm-oases-assembly/sailfish-out/${samp}_quant -r ${samp}-R1_val_1.fq ${samp}-R2_val_2.fq -p 4
    echo "Quantification done for $samp" `date`
done

