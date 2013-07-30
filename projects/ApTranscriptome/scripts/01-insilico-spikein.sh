#!/bin/bash

###################################################################################################
## Script to generate in silico Illumina reads to include in transcriptome assembly ('spike-in') to validate recapture and assembly rate
## Author: John Stanton-Geddes
## Created: 2013-07-30
## Modified: 2013-07-30 
###################################################################################################


# get 50 genes unique to plants

# use [wgsim](https://github.com/lh3/wgsim) to generate simulated Illumina reads

# set coverage of 5 genes to 1x,5x,10x,25x,50x,75x,100x,500x,1000x,5000x to evaluate how depth of sequencing influences recovery

# save file as 'A22-spikein.fastq'
