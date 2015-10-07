#!/usr/bin/perl -w

#
# Parse FUSIONCATCHER output to extract sequence around each breakpoint
#

# Perl libs
use warnings;
use strict;
use Getopt::Long;
use Pod::Usage;
use File::Basename;
use Bio::SeqIO;
use Bio::DB::Fasta;
use Data::Dumper;
use Math::Round;

## Inputs variables
my $fusionC   = undef;
my $seqLength = 1000;
my $expId     = undef;
my $outName   = undef;
my $help      = undef;

## Parse options and print usage if there is a syntax error,
## or if usage was explicitly requested.
GetOptions(
    'i|infile=s'  => \$fusionC,
    'l|length=i'  => \$seqLength,
    'e|expId=s'   => \$expId,    
    'o|outname=s' => \$outName,
    'help|?'      => \$help,
    ) or pod2usage(2);

pod2usage(1) if $help;

pod2usage("Error, input FUSIONCATCHER file is mendatory. Exit\n")               unless(defined $fusionC);
pod2usage("Error, input FUSIONCATCHER file '$fusionC' don't exist. Exit\n")     unless(-r $fusionC);
pod2usage("Error, length value need to be equal or greater than 10 nt. Exit\n") unless($seqLength >= 10);
pod2usage("Error, OUTPUT file name is mendatory. Exit\n")                       unless(defined $outName);


### Open the output file
open OUTFILE, "> $outName" or die "Error! Cannot access OUT file '". $outName . "': ".$!;

### Read crac file
open FCFILE, "$fusionC" or die "Error! Cannot access FUSIONCATCHER file '". $fusionC . "': ".$!;


while(<FCFILE>)
{
    next if $. < 2; # Skip header

    chop;
    my @line = split(/\t/);
    my @ids  = ($line[10],$line[11]);
    
    my $geneNum = 0;
    ### For the break point found in each genes
    foreach my $breakPos (($line[8],$line[9]))
    {
	my ($chr, $pos, $str) = split(/:/,$breakPos);
	
	my $start = $pos - $seqLength;
	my $end   = $pos + $seqLength;
	if($start<0)
	{
	    $start = 0;
	}

	my $genePos = "";
	if($geneNum==0)
	{
	    $genePos = "5'";
	}
	else
	{
	    $genePos = "3'";
	}

	### Print the GTF output
	if(defined $expId)
	{
	    print OUTFILE "$chr\tfusioncatcher\texon\t$start\t$end\t.\t$str\t.\tgene_id \"$ids[$geneNum]\"; transcript_id \"$ids[0]/$ids[1]_$expId_$line[8]/$line[9]\"; fusion_id \"$ids[0]/$ids[1]\"; experiment_id \"$expId\"; gene_pos \"$genePos\"; break_value \"$line[8]/$line[9]\";\n";
	}
	else
	{
	    print OUTFILE "$chr\tfusioncatcher\texon\t$start\t$end\t.\t$str\t.\tgene_id \"$ids[$geneNum]\"; transcript_id \"$ids[0]/$ids[1]_$expId_$line[8]/$line[9]\"; fusion_id \"$ids[0]/$ids[1]\"; gene_pos \"$genePos\"; break_value \"$line[8]/$line[9]\";\n";
	}

	$geneNum = $geneNum + 1;
    }
}


close OUTFILE;
