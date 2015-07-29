#! /usr/bin/perl
use strict;
use warnings;
use Bio::SearchIO;
use Getopt::Long;
use Bio::DB::Sam;
use Bio::Perl;

my $dbname='aphidbase_v2.1b';
my $port=5432;
my $host='spodo',
my $user= 'aphidbase';
my $pwd='';
my $analysis = 'EG2AP';
my $bam;
my $utr;
my $decalage=1;
my $debugPos=5;
my $pred;

GetOptions(
	"bam=s"  => \$bam,
	"pred=s" => \$pred,
);

my $bamio = Bio::DB::Sam->new(-bam  =>$bam);

open PRED, $pred or die "failed to open $pred\n";

my %strand = ();
my %scaff  = ();

while (<PRED>) {
	my $l     = $_;
	my @ligne = split(/\t/,$l);

	my ($tmp_gene, @tmp_gene2, @all_fix_pos, $gene, $utr_start, $utr_end, $mir, $fixation_start, $fixation_end, $site_type, $utr_comp, $fix_comp);
	($tmp_gene, $mir, $site_type, $fixation_start, $fixation_end, $utr_comp, $fix_comp) = @ligne[0,2,3,4,5,11,12];
	
	@tmp_gene2 = split(/_/, $tmp_gene);
	$gene      = $tmp_gene2[0];

	@all_fix_pos = split(/-/,$tmp_gene2[1]);
	$utr_start   = $all_fix_pos[0];
	$utr_end     = $all_fix_pos[1];

	#if (!exists $scaff{$gene})  {
		#my ($genefeature) = GMOD::Chado::Feature->search(uniquename => $gene);
		#my ($loc)         = $genefeature->locations();
		#$scaff{$gene}     = $loc->srcfeature_id()->uniquename();
		#$strand{$gene}    = $loc->strand();
	#}

	### Pas beau	
	next if( ($fix_comp =~ m/E+/) );
	next if( ($utr_comp =~ m/-+/) );
	
	### Extrait le séquence en inversant l'UTR de TS pour palier à l'appariment en 3' du microARN
	my $temp = reverse $fix_comp;
	my ($space) = ($temp =~ m/^(\s+)\|+\s+/);
	my $space_length = length($space); 

	$temp = reverse $utr_comp;

	my $utr_fix_seq;

	$utr_fix_seq = substr($temp, $space_length, 6);
	$utr_fix_seq = reverse $utr_fix_seq;

	### Obtention des reads qui s'aligne sur le site de fixation
	### Pour la cible utilisation de $gene car alignement fait avec cette valeurs
	my @alignments = $bamio->get_features_by_location(-seq_id => $tmp_gene,
													  -start  => $fixation_start,
													  -end    => $fixation_end);

	my $cpt_read   = 0;
	my $cpt_snp    = 0;
	my @all_snp    = ();
	my $all_snp_id = $l;
	### Crée une table de hachage pour avoir l'ensemble des SNP pour 1 site de fixation
	my %type_snp = ();
    foreach my $alig (@alignments) {
    	if (($alig->end() -$alig->start) <= $alig->	query->length) {
    		my $graine_read_start = $alig->query->start() + ($fixation_start - $alig->start);
    		my $graine_read_end   = $alig->query->start() + ($fixation_end   - $alig->start);

			### Pas beau
    		next if ($graine_read_start <=0 );
    		next if ($graine_read_end > $alig->query->length);
	
			### ATTENTION BRUT
			### Obtention de la séquence du site de fixation sur le read
			### Avant doit calculer le nombre de gaps au sein de l'alignement sur la ref (ref_gaps) où le read (read_gaps)
			my $fix;
			my ($ref,$matches,$read) = $alig->padded_alignment;

			$utr_fix_seq =~ tr/AUCGaucgNn/ATCGatcgNn/;
			my @tmp = split($utr_fix_seq, $ref);
			my $length_tab_tmp = @tmp;
			my $length_tmp = length($tmp[0]);
			
			### Arrete si gap dans le site de fixation
			next if($length_tab_tmp != 2);
			
			#print join "\t", $length_tmp."\n";
			$fix = substr($read, $length_tmp, 6);
			$utr_fix_seq =~ tr/ATCGatcgNn/AUCGaucgNn/;
			$fix =~ tr/ATCGatcgNn/AUCGaucgNn/;

			### Pas beau
			next if( ($fix =~ m/N+/) );

			### Incrémente le comptage du nombre de read ayant matché sur la graine
			$cpt_read++; 

			### Crée une table de hachage avec les séquences qui ont un SNP
			my %all_snp    = ();
			my $all_snp_id = $l;

			### Test si la séquence extraite du read correspond avec la séquence du site original
			if($fix eq $utr_fix_seq)
			{
				#print join "\t", "site de fixation trouvé : ", $gene, $mir, $fixation_start, $fixation_end."\n";
				#print join "\t", $gene, $mir, "read", $fix."\n".$gene, $mir, "utr", $utr_fix_seq."\n";
			}
			else
			{
				for(my $i=0; $i<6; $i++)
				{
					my $nuc_read = substr($fix, $i, 1);
					my $nuc_ref  = substr($utr_fix_seq, $i, 1);
					
					if($nuc_read ne $nuc_ref)
					{
						my $id = $nuc_ref."2".$nuc_read."P".$i	;
						#print $tmp_gene."\t".$mir."\t".$id."\n";
						if(exists $type_snp{$id})
						{
							$type_snp{$id} = $type_snp{$id} + 1;
							#print "exists ".$tmp_gene."\t".$mir."\t".$id."\t".$type_snp{$id}."\n";
						}
						else
						{
							$type_snp{$id} = 1;
							#print "don't exists ".$tmp_gene."\t".$mir."\t".$id."\t".$type_snp{$id}."\n";
						}
						
					}
				}
			}
			
    	}
	}
	### Après foreach my align :
	my $res;
	foreach $res (keys(%type_snp))
	{
		print "$type_snp{$res} SNP de type $res trouvés sur $cpt_read read aligné pour : $tmp_gene\t$mir\t$fixation_start\t$fixation_end\n";
	}
}
