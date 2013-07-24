#!bin/bash

### Script to shuffle reads forvelvet-oases

# Set variables
samples=(A22-00 A22-03 A22-07 A22-10 A22-14 A22-17 A22-21 A22-24 A22-28 A22-31 A22-35 A22-38)

indir="/home/projects/climate-cascade/projects/AphTranscriptome/results/01-trimclip"
outdir="/home/projects/climate-cascade/projects/AphTranscriptome/results/02-shuffled"

# Create directory for shuffled files
mkdir -p $outdir

# Loop across samples, shuffling forward and reverse reads
for samp in "${samples[@]]}"
do
    shuffleSequences_fastq.pl $indir/${samp}-R1_val_1.fq $indir/${samp}-R2_val_2.fq $outdir/${samp}-shuffled.fastq 
    echo "Shuffled ${samp}"

    # Check that files are correctly shuffled
    echo ` wc -l $outdir/${samp}-shuffled.fastq ` | cut -f1 -d ' ' 
    echo `wc -l $indir/${samp}-R1_val_1.fq $indir/${samp}-R2_val_2.fq ` | cut -f 5 -d ' ' 

done			      

