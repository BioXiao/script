#!/usr/bin/perl -w


#####################################################################
# TD, May 2014
# tderrien@univ-rennes1.fr
#
# Aims :
#	- 4Mathieu :)
#	- Format a gtf to a gff3 suitable for CRAC
#	- Add a <main_type>:<sub_type> as in CRAC : see ~mbahin/.cpanm/work/1397485383.24780/CracTools-core-1.03/scripts/buildGFF3FromEnsembl.pl
#####################################################################

# Uses
use strict;
use Pod::Usage;
use Getopt::Long;
use Parser;
use ExtractFromFeature;
use Data::Dumper;


# Global Variables
my $infile;
my $help 		= 0;
my $verbosity		= 0;
my $man;

# Parsing parameters
my $result = GetOptions(
	"infile|i=s"		=> \$infile,
	"verbosity|v=i"	=> \$verbosity,
	"man|m"			=> \$man,
	"help|h"		=> \$help);


# Print help if needed
pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;
pod2usage("I need a gtf file...\n") unless ($infile && -r $infile);

####	END TEST	############################################################



# Open files
open GTFFILE, "$infile" or die ("Could not open $infile...\n");

my @lines = <GTFFILE>;
my $i=0;
my %h_transcript;
my %h_gene;

################################################################################
# Parse GTF File
if ($verbosity > 0){

	print STDERR "Parse Gtf file\n";
}
my $refh              = Parser::parseGTFgene($infile, 'exon,CDS',  0, undef, $verbosity);

#   print Dumper $refh;
#
# die;

print "##gff-version 3\n";
# Parse gtfHash to be printed
for my $gn (keys %{$refh}){

	# compute the number of Tx per locus/gene
	my $nb_tx = scalar keys %{$refh->{$gn}->{'transcript_id'}};

	my $counttx=0;

	# Need to go through all tx (but not all exons fetures=> [0]) to have the matching genes
	my %gnmatch;
	foreach my $tr (keys %{$refh->{$gn}->{'transcript_id'}}) {

		my $reftx 		= $refh->{$gn}->{'transcript_id'}->{$tr};

		if (exists $reftx->{"feature"}->[0]->{'matchEns75Gn100'} && $reftx->{"feature"}->[0]->{'matchEns75Gn100'} ne "NA"){
			my $gn = $reftx->{"feature"}->[0]->{'matchEns75Gn100'};
			$gnmatch{$gn}++;
		}
	}
# 	print Dumper \%gnmatch;
# 	die;
	# join all keys
	my $gnmatch;
	if (keys %gnmatch){
		$gnmatch = join (",", keys %gnmatch);
	} else {
		$gnmatch = "NA";
	}

	# Go through each txs
	foreach my $tr (keys %{$refh->{$gn}->{'transcript_id'}}) {

		my $reftx 		= $refh->{$gn}->{'transcript_id'}->{$tr};

		$counttx++;


 		# Only print gene level for the first tx
		if ($counttx ==1){
			if (exists $reftx->{"feature"}->[0]->{'matchEns75Gn100'}){
				# print *gene* level
				print join("\t",$refh->{$gn}->{"chr"}, $refh->{$gn}->{"source"}, "gene", $refh->{$gn}->{"startg"}, $refh->{$gn}->{"endg"}, $refh->{$gn}->{"score"}, $refh->{$gn}->{"strand"}, ".");
				print "\tID=$gn;Name=$gn;transcripts_nb=$nb_tx;matchEns75Gn100=$gnmatch\n";
			} else{
				print join("\t",$refh->{$gn}->{"chr"}, $refh->{$gn}->{"source"}, "gene", $refh->{$gn}->{"startg"}, $refh->{$gn}->{"endg"}, $refh->{$gn}->{"score"}, $refh->{$gn}->{"strand"}, ".");
				print "\tID=$gn\n";
			}
		}

		my $txmatch	=	$reftx->{"feature"}->[0]->{'matchEns75Tx100'} if (exists $reftx->{"feature"}->[0]->{'matchEns75Tx100'});

		my $exons_nb_tx	= scalar @{$reftx->{"feature"}};
		my $type_tx = "NA";

		my $desc = getMainType($reftx->{"feature"}->[0]->{'transcript_biotype'});

		# print *mRNA* level -> add main_type:sub_type
		if (exists $reftx->{"feature"}->[0]->{'matchEns75Tx100'}){
			print join("\t",$reftx->{"chr"}, $reftx->{"source"}, "mRNA", $reftx->{"startt"}, $reftx->{"endt"}, $reftx->{"score"}, $reftx->{"strand"}, ".");
			print "\tID=$tr;Parent=$gn;exons_nb=$exons_nb_tx;type=$desc;matchEns75Tx100=$txmatch\n";
		}else{
			print join("\t",$reftx->{"chr"}, $reftx->{"source"}, "mRNA", $reftx->{"startt"}, $reftx->{"endt"}, $reftx->{"score"}, $reftx->{"strand"}, ".");
			print "\tID=$tr;Parent=$gn;exons_nb=$exons_nb_tx;\n";
# 			print "\tID=$tr;Parent=$gn\n";

		}

		my $exon_rank=0;
		my $cds_rank=0;

		foreach my $feat1 (@{$reftx->{"feature"}}) {

			# print *exon* level
			if ($feat1->{"feat_level"} eq "exon") {
				$exon_rank++;
				print join("\t",$reftx->{"chr"}, $reftx->{"source"}, "exon" , $feat1->{"start"}, $feat1->{"end"}, $reftx->{"score"}, $reftx->{"strand"}, $feat1->{"frame"});
				print "\tID=".$tr."#$exon_rank;Parent=$tr;exon_rank=$exon_rank\n";
	# 			print "\tID=".$tr."#$exon_rank;Parent=$tr\n";
			} elsif ($feat1->{"feat_level"} eq "CDS") {
				$cds_rank++;
				print join("\t",$reftx->{"chr"}, $reftx->{"source"}, "CDS", $feat1->{"start"}, $feat1->{"end"}, $reftx->{"score"}, $reftx->{"strand"}, $feat1->{"frame"});
				print "\tID=CDS_".$tr."#$cds_rank;Parent=$tr;cds_rank=$cds_rank\n";
	# 			print "\tID=CDS_".$tr."#$exon_rank;Parent=$tr\n";
			} else {
				die "Feat level not known in gtf2gff.pl...\n"
			}

		}
	}
}

sub getMainType {

	my ($tx_biotype)	=	@_;
	my $desc = "NONE" ;
	if (defined $tx_biotype){
		#protein coding part
		if ($tx_biotype eq "protein_coding" || $tx_biotype eq "pseudogene"
			|| $tx_biotype =~ /IG_C/i || $tx_biotype =~ /IG_V/i
			|| $tx_biotype =~ /TR_V/i || $tx_biotype =~ /TR_C/i
			|| $tx_biotype =~ /TR_J/i || $tx_biotype =~ /IG_D/i
			|| $tx_biotype =~ /IG_J/i || $tx_biotype =~ /TR_D/i
			|| $tx_biotype eq "polymorphic_pseudogene"){
			$desc = "protein_coding:".$tx_biotype;
		}elsif ($tx_biotype eq "miRNA" || $tx_biotype eq "miRNA_pseudogene"
			|| $tx_biotype eq "snRNA" || $tx_biotype eq "snRNA_pseudogene"
			|| $tx_biotype eq "snoRNA" || $tx_biotype eq "snoRNA_pseudogene"
			|| $tx_biotype eq "rRNA" || $tx_biotype eq "rRNA_pseudogene"
			|| $tx_biotype eq "Mt_rRNA" || $tx_biotype eq "Mt_rRNA_pseudogene"
			|| $tx_biotype eq "Mt_tRNA" || $tx_biotype eq "Mt_tRNA_pseudogene"
			|| $tx_biotype eq "tRNA" || $tx_biotype eq "tRNA_pseudogene"
			|| $tx_biotype eq "scRNA" || $tx_biotype eq "scRNA_pseudogene"
			|| $tx_biotype eq "ncRNA" || $tx_biotype eq "ncRNA_pseudogene"
			|| $tx_biotype eq "3prime_overlapping_ncrna") {
			$desc = "small_ncRNA:".$tx_biotype;
		}elsif ($tx_biotype =~ /lincRNA/i || $tx_biotype eq "lncRNA" ){
			$desc = "lincRNA:".$tx_biotype;
		}elsif ($tx_biotype eq "antisense" || $tx_biotype eq "sense_intronic"
			|| $tx_biotype eq "processed_transcript"){
			$desc = "other_lncRNA:".$tx_biotype;
		}elsif ($tx_biotype =~ /non_coding/
			|| $tx_biotype eq "misc_RNA" || $tx_biotype eq "misc_RNA_pseudogene"
			|| $tx_biotype eq "ncrna_host" || $tx_biotype eq "sense_overlapping"
			|| $tx_biotype eq "retained_intron"
			|| $tx_biotype eq "processed_pseudogene" || $tx_biotype eq "unprocessed_pseudogene"
			|| $tx_biotype eq "transcribed_processed_pseudogene"
			|| $tx_biotype eq "transcribed_unprocessed_pseudogene"
			|| $tx_biotype eq "retrotransposed" || $tx_biotype eq "unitary_pseudogene"
			){
			$desc = "other_noncodingRNA:".$tx_biotype;
		}
	}
	return $desc
}


__END__

=head1 NAME

gtf2gff3_v2.pl - Format a .gtf file with exon levels  in gff3 like :

##gff-version 3

# The organism is Homo Sapiens

# The API version used is 73

HSCHR6_MHC_MANN Ensembl_CORE    gene    30051790        30051922        .       -       .    ID=ENSG00000266142;Name=CT009552.1;transcripts_nb=1;exons_nb=1

HSCHR6_MHC_MANN Ensembl_CORE    mRNA    30051790        30051922        .       -       .       ID=ENST00000578939;Parent=ENSG00000266142;exons_nb=1;type=small_ncRNA:miRNA

HSCHR6_MHC_MANN Ensembl_CORE    exon    30051790        30051922        .       -       .       ID=ENSE00002706393;Parent=ENST00000578939;exon_rank=1

=head1 SYNOPSIS

perl gtf2gff3_v2.pl -infile <gtf file> [Options]


Options:

	-help		: Help message

	-man		: man help

	-verbosity	: level of verbosity


=head1 OPTIONS

=over 8

=item B<-verbosity>
: Level of verbosity to follow process

=item B<-man>
: Print man help and exit

=item B<-help>
: Print help message and exit

=back

=head1 DESCRIPTION

=over 8

=item * Parse a gtf file with *only* exon levels

=item * Format the file with exon, transcript and gene levels in gff3

=back

=cut
