#!/usr/bin/env perl
use warnings;

# Script from https://github.com/jfroula/Tools/blob/master/pipeline/bwa_contig_counts.pl
# bwa_contig_counts.pl runs the bwa aligner and aligns the reads
# to a reference, in this case the contigs.
# The expression calculation (RPKM) and depth of read coverage
# is calculated and written to a file.
# This script is to be run by denovoRNAseq_wrapper.pl
#
#
#
use strict;
use Getopt::Long;

my $contig_list = "contig.list";

my ($reference,$fastq, $read_length);
GetOptions(
        "r=s"=>\$reference,
        "l=s"=>\$read_length,
        "q=s"=>\$fastq
    );

unless ($reference && $fastq && $read_length){
    print "Usage: $0 -r <reference> -q <fastq> -l <trimmed read length>\n\n"; 
    exit;
}

#
# Run BWA aligner (reads ag. contigs)
#
my $cmd = "bwa index -a is $reference 
bwa aln $reference $fastq > aln_sa.$reference.sai
bwa samse -n 1 $reference aln_sa.$reference.sai $fastq > $reference.sam";
print "running $cmd\n";
&runCmd($cmd);


#
# Parse the SAM output
# The results should look like this where 1) number of reads hitting gene, 
# 2) gene id and range & strand
#
#  126 NODE_10000_length_334_cov_9.236526
#   41 NODE_10001_length_177_cov_5.418079
#   74 NODE_10007_length_334_cov_5.164670
#
$cmd = "grep -v \"^>\" $reference.sam | cut -f1 | sort | uniq -c > $reference.counts";
print "running $cmd\n";
&runCmd($cmd);

#
# calculate RPKM foreach contig
#
&calculateRPKM($reference);


###-----------------------------###
###Subroutines ###
###-----------------------------###

sub runCmd
{
    my ($cmd) = @_;
    if (system($cmd)){
        print "Error: couldn't run $cmd\n";
        exit;
    }
}


sub calculateRPKM
{
    #
    # RPKM is reads per contig length (Kb) per total reads (Mill) 
    #
    my ($reference) = @_;

    # 
    #  build hash of contig lengths
    # 
    print "finding contig sizes\n";
    my @sizes = `~/Tools/General/fastaLengths.pl $reference`;
    unless (@sizes){ 
        print "failed to run ~/Tools/General/fastaLengths.pl $reference\n";
        exit;
    }
    my %sizes = ();
    foreach (@sizes){
        chomp;
        my ($contig,$size) = split(/\t/,$_);
	$sizes{$contig}=$size;
#print "adding $contig: $size\n";
    }

    #
    # Find total number of reads (as Millions)
    #
    my $totalReads = `grep -c "^@" $fastq`;
    $totalReads = $totalReads / 1000000;
    print "getting total number of reads: $totalReads (M)\n";

    #
    # Open contig read counts file and calculate RPKM
    #
    print "writting ....\n";
    open FILE,"<$reference.counts" || die "can't open $reference.counts: $!\n";
    open RPKM,">$reference.RPKM" || die "can't open $reference.RPKM: $!\n";
    while (<FILE>){
        chomp;
        my $counts;
	my $contig;
	if ($_=~ /(\d+)\s+(.*)/){
	    $counts = $1;
	    $contig = $2;
	}else{
	    print "failed to parse $reference.counts\n";
	    exit;
	}
        #   
        # calculate RPKM
        #   
#print "$contig|$counts|$totalReads|$sizes{$contig}|\n";
        my $RPKM = ($counts/$totalReads) * ($sizes{$contig}/1000);

        #   
        # calculate read coverage
        #   
        my $coverage = ($counts * $read_length / $sizes{$contig});
	
	print  RPKM "$contig\t";
	printf RPKM "%3.3f\t", $RPKM;
	printf RPKM "%3.3f\n", $coverage;
    }
    close FILE;
    close RPKM;
}



