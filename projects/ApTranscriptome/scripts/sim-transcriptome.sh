#!/bin/bash

##################################################################################################
## Script to generate simulate Illumina RNAseq data and validate transcriptome assembly
## Author: John Stanton-Geddes
## Created: 2013-08-12
###################################################################################################

# Set PYTHONPATH to khmer module
export PYTHONPATH=/opt/software/khmer/python

# File with *Arabidopsis* mRNA transcripts haphazardly selected from [European Nucleotide Archive](http://www.ebi.ac.uk/ena/home)

simfasta="/home/projects/climate-cascade/projects/ApTranscriptome/data/ENA-arabidopsis-random-mRNA.fasta"
datadir="/home/projects/climate-cascade/projects/ApTranscriptome/data"

## Trim fasta titles to just ID
cut -f1 -d" " $simfasta > ena.fasta

## Assign expression-level to each sequence using the `sel` tool in [rlsim](https://github.com/sbotond/rlsim)

sel -d "1.0:g:(1500, 3)" ena.fasta > ../data/ena-simulated.fasta
rm ena.fasta # Clean-up temp file
echo -e "Done with expression levels: " `date` "\n"

## Simulate fragments created during library prep using `rlsim`. Based on length of fragments estimated when using FLASH to pair reads, use empirical length distribution of 180 bp (SD: 20bp).

rlsim -v -n 100000 -d "1:n:(180, 20, 100, 500)" ../data/ena-simulated.fasta > ../data/ena-simulated-frags.fasta
echo -e "Done with simulated fragmentation levels: " `date` "\n"

## Generate simulated Illumina paired-end reads using [simNGS](http://www.ebi.ac.uk/goldman-srv/simNGS/)
# output is 'reads_end1.fq' and 'reads_end2.fq'
cat ../data/ena-simulated-frags.fasta | simNGS -p paired -o fastq -O reads /opt/software/simNGS/data/s_3_4x.runfile
# Move files to data directory
mv reads_end[12].fq ../data/.
echo -e "Done with Illumina read simulation: " `date` "\n"

## Run through TrimGalore for adapter cutting and quality trimming
trim_galore --quality 20 --phred33 --fastqc_args "--o $datadir" --length 20 --paired --output_dir $datadir $datadir/reads_end1.fq $datadir/reads_end2.fq
echo -e "Done with quality trimming: " `date` "\n"

## Run digital normalization with khmer
# interleave file
python /opt/software/khmer/sandbox/interleave.py ../data/reads_end1_val_1.fq ../data/reads_end2_val_2.fq > ../data/sim-interleaved.fastq

# run diginorm
python /opt/software/khmer/scripts/normalize-by-median.py -R diginorm-final.out -C 20 -k 21 -N 4 -x 4e9 $datadir/sim-interleaved.fastq
mv sim-interleaved.fastq.keep ../data/.
echo -e "Done with interleaving files:" `date` "\n"

# Merge reads with FLASH
flash --phred-offset 33 --interleaved-input --interleaved-output --output-directory $datadir --output-prefix sim $datadir/sim-interleaved.fastq.keep
echo -e "Done with FLASH:" `date` "\n"

## Assemble transcriptome with velvet-oases
for i in {19..25..2}; do 
    # velveth
    velveth $datadir/sim-oases-$i $i -fastq -shortPaired ${datadir}/sim.extendedFrags.fastq -short ${datadir}/sim.notCombined.fastq
    # velvetg
    velvetg $datadir/sim-oases-$i -read_trkg yes
    # oases
    oases $datadir/sim-oases-$i -ins_length 180

   echo -e "Done with velvet-oases for kmer $i:" `date` "\n"
done 

# check basic stats
python /opt/software/khmer/sandbox/assemstats2.py 300 $datadir/sim-oases*/transcripts.fa 

# merge assemblies
velveth $datadir/sim-mergedAssembly/ 25 -long $datadir/sim-oases*/transcripts.fa 
velvetg $datadir/sim-mergedAssembly/ -read_trkg yes -conserveLong yes
oases $datadir/sim-mergedAssembly/ -merge yes

python /opt/software/khmer/sandbox/assemstats2.py 300 $datadir/sim-MergedAssembly/transcripts.fa 


## Map simulated reads to velvet-oases transcriptome with BWA

# Index transcriptome fasta file
bwa index $simfasta 

# Map paired reads; using trimmed and filtered reads
bwa aln $simfasta $datadir/reads_end1.fq > $datadir/sim-mapped-reads_end1.sai
bwa aln $simfasta $datadir/reads_end2.fq > $datadir/sim-mapped-reads_end2.sai
# convert sai to SAM and combine files
bwa sampe $simfasta $datadir/sim-mapped-reads_end1.sai $datadir/sim-mapped-reads_end1.sai $datadir/reads_end1.fq $datadir/reads_end2.fq > sim-mapped-reads.sam
# convert to BAM
samtools faidx $simfasta #index
samtools import ${simfasta}.fai $datadir/sim-mapped-reads.sam $datadir/sim-mapped-reads.bam # sam->bam
samtools sort $datadir/sim-mapped-reads.bam $datadir/sim-mapped-reads.sorted.bam # sort BAM
samtools index $datadir/sim-mapped-read.sorted.bam # index

# Can view alignment using
# samtools tview $datadir/sim-mapped-read.sorted.bam $simfasta

## Gene expression

# first, turn original Arabidopsis mRNA into a BED file using script from http://ged.msu.edu/angus/tutorials-2013/rnaseq_bwa_counting.html?highlight=bwa
python /home/projects/climate-cascade/scripts/make_bed_from_fasta.py $simfasta > $datadir/simfasta.bed
# count reads that have mapping quality of 30 or better (-q 30)
multiBamCov -q 30 -p -bams $datadir/sim-mapped-reads.sorted.bam -bed $datadir/simfasta.bed > $datadir/sim_transcriptome_counts.txt

## Assemble transcriptome with Trinity using built-in normalization


## Map simulated reads to Trinity assembly with BWA