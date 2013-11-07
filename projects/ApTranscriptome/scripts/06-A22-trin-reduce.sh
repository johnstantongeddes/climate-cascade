#!/bin/bash

###################################################################################################
## Script for transcriptome assembly using [velvet-oases](http://www.ebi.ac.uk/~zerbino/oases/) after quality trimming and [digital normalization](http://ged.msu.edu/papers/2012-diginorm/) of Illumina reads
## Author: John Stanton-Geddes
## Created: 2013-07-30
###################################################################################################

indir="../data/A22-merge-diginorm-trinity"

# Use cap3 to collapse redundancy in transcripts
cap3 Trinity.fasta -f 50 -a 50 -k 0 -p 90 -o 100 > Trinity_cap3.fasta

