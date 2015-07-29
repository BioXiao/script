#!/usr/bin/perl -w

use strict;
use warnings;

use Bio::Tools::GFF;
use Data::Dumper;


my ($infile, $outfile) = @ARGV;
die("must define a valid input file to read") unless ( defined $infile && -r $infile);


my $parser  = new Bio::Tools::GFF(-gff_version => 2, -file =>  $infile);
my $out;

# Output
if( defined $outfile ) {
  $out = new Bio::Tools::GFF(-gff_version => 3, -file => ">$outfile");
} else { 
  $out = new Bio::Tools::GFF(-gff_version => 3); # STDOUT
}

while( my $result = $parser->next_feature ) {
	$out->write_feature($result);
}
