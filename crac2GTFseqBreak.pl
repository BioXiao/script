#!/usr/bin/perl -w

#
# Parse CRAC output to extract sequence around each breakpoint
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
my $crac      = undef;
my $seqLength = 1000;
my $expId     = undef;
my $outName   = undef;
my $help      = undef;

## Parse options and print usage if there is a syntax error,
## or if usage was explicitly requested.
GetOptions(
    'i|infile=s'  => \$crac,
    'l|length=i'  => \$seqLength,
    'e|expId=s'   => \$expId,    
    'o|outname=s' => \$outName,
    'help|?'      => \$help,
    ) or pod2usage(2);

pod2usage(1) if $help;

pod2usage("Error, input CRAC file is mendatory. Exit\n")                        unless(defined $crac);
pod2usage("Error, input CRAC file '$crac' don't exist. Exit\n")                 unless(-r $crac);
pod2usage("Error, length value need to be equal or greater than 10 nt. Exit\n") unless($seqLength >= 10);
pod2usage("Error, OUTPUT file name is mendatory. Exit\n")                       unless(defined $outName);


### Open the output file
open OUTFILE, "> $outName" or die "Error! Cannot access OUT file '". $outName . "': ".$!;

### Read crac file
open CRACFILE, "$crac" or die "Error! Cannot access CRAC file '". $crac . "': ".$!;


while(<CRACFILE>)
{
    next if $. < 2; # Skip header

    chop;
    my @line = split(/\t/);
    my @ids  = split(/---/,$line[0]);

    ### For each breaks points found between the two ids
    foreach my $break (split(/\),\(/,$line[4]))
    {
	my $tmp = (split(/#/,$break))[0];
	$tmp    =~ s/\(| //g;
	$break  =~ s/\(|\)| //g;

	my $geneNum = 0;
	### For the break point found in each genes
	foreach my $breakPos (split(/\//,$tmp))
	{
	    my ($chrPos, $str) = split(/,/,$breakPos);
	    my ($chr, $pos)    = split(/:/,$chrPos);

	    if($str == 1)
	    {
		$str = "+";
	    }
	    elsif($str == -1)
	    {
		$str = "-";
	    }
	    
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
		print OUTFILE "$chr\tcrac\tfusion\t$start\t$end\t.\t$str\t.\tgene_id \"$ids[$geneNum]\"; transcript_id \"$ids[0]/$ids[1]_$expId_$break\"; fusion_id \"$ids[0]/$ids[1]\"; experiment_id \"$expId\"; gene_pos \"$genePos\"; break_value \"$break\";\n";
	    }
	    else
	    {
		print OUTFILE "$chr\tcrac\tfusion\t$start\t$end\t.\t$str\t.\tgene_id \"$ids[$geneNum]\"; transcript_id \"$ids[0]/$ids[1]_$break\"; fusion_id \"$ids[0]/$ids[1]\"; gene_pos \"$genePos\"; break_value \"$break\";\n";
	    }
	    
	    $geneNum = $geneNum + 1;
	}
    }
}

close OUTFILE;
