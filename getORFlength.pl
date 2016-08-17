#!/usr/bin/perl -w


# Perl libs
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use File::Basename;
use Bio::SeqIO;
use Bio::DB::Fasta;
use Data::Dumper;

# lib directory: {FEELnc github directory}/lib/
use Parser;
use ExtractFromHash;
use ExtractFromFeature;
use Intersect;
use Utils;
use Orf;
use ExtractCdnaOrf;
use List::Util 'shuffle';


### Input variables
my $infile = "";
my $type   = 0;

## Parse options and print usage if there is a syntax error,
## or if usage was explicitly requested.
GetOptions(
    'i|infile=s' => \$infile,
    't|type=i'   => \$type,
    ) or pod2usage(2);

# Test parameters
pod2usage("- Error: Cannot read your input FASTA file '$infile'...\n") unless( -r $infile);
pod2usage("- Error: ORF type is not valid. Integer in {0,1,2,3,4}.\n")     if( $type!=0 && $type!=1 && $type!=2 && $type!=3 && $type!=4 );


my %orf;         # for storing ORF
my $orfFlag = 0; # get getTypeOrf result

# Constantes
my $strand  = ".";
my $kmerMax = 0;

# Create SeqIO objects
my $seqin = Bio::SeqIO->new(-file => $infile, -format => "fasta");

# Go through each sequences
while(my $seq = $seqin->next_seq())
{
    my $tr = $seq->id();
    
    $orfFlag = ExtractCdnaOrf::getTypeOrf($tr, $seq->seq(), $strand, \%orf, $type, $kmerMax);
    
    if($orfFlag != -1)
    {
	print $tr ."\t". length($orf{$tr}) ."\n";
    }
    else
    {
	print $tr ."\t". "-1" ."\n";
    }
}

