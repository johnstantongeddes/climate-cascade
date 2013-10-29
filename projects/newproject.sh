#!/bin/bash

# shell script to generate default folders for a new project

for i in ApAdaPt
do
		mkdir $i
		mkdir $i/data
		# Add file so that git starts tracking directory. Note that by default, the /data directory is ignored but am adding for my local version
		echo "Directory to store data files used for analysis." > $i/data/README.txt
		mkdir $i/scripts
		echo "Directory to store scripts used for data analysis. Results can be saved here, or alternately to avoid clutter in the 'results' directory." > $i/scripts/README.txt
		mkdir $i/results
		echo "Directory to store results if they are not stored in scripts directory. Best practice is to have results from your scripts write to this directory, with filedate as part of the result file name to avoid overwriting previous results." > $i/results/README.txt
		mkdir $i/doc
		echo "Directory to store methods information and manuscript drafts" > $i/doc/README.txt
done

