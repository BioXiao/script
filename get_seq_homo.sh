#!/bin/bash
### Usage : get_seq_homo.sh


cd ~/travail/resultat/alignement/fichier/entree

fpis=~/travail/donnees/donnees_original/aphidbase_2.1_UTR3.flate
fgos=~/travail/donnees/donnees_original/agossypii_UTR3.flate
fkon=~/travail/donnees/donnees_original/Kondoi_UTR3.flate	 
fmyz=~/travail/donnees/donnees_original/Myzus_2.1_UTR3.flate


entree=~/travail/resultat/alignement/pisum_gossypii_kondoi_myzus.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  gos=$(echo $ligne | awk '{print $2}' )
  kon=$(echo $ligne | awk '{print $3}' )
  myz=$(echo $ligne | awk '{print $4}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqgos=$( awk '$1==">'$gos'" { split($3, tab, "seq="); print tab[2] }' $fgos )
  seqkon=$( awk '$1==">'$kon'" { split($3, tab, "seq="); print tab[2] }' $fkon )
  seqmyz=$( awk '$1==">'$myz'" { split($3, tab, "seq="); print tab[2] }' $fmyz )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$gos'_'$kon'_'$myz'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$gos"\n"$seqgos"\n"">"$kon"\n"$seqkon"\n"">"$myz"\n"$seqmyz > $sortie
done


entree=~/travail/resultat/alignement/pisum_gossypii_kondoi.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  gos=$(echo $ligne | awk '{print $2}' )
  kon=$(echo $ligne | awk '{print $3}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqgos=$( awk '$1==">'$gos'" { split($3, tab, "seq="); print tab[2] }' $fgos )
  seqkon=$( awk '$1==">'$kon'" { split($3, tab, "seq="); print tab[2] }' $fkon )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$gos'_'$kon'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$gos"\n"$seqgos"\n"">"$kon"\n"$seqkon > $sortie
done


entree=~/travail/resultat/alignement/pisum_gossypii_myzus.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  gos=$(echo $ligne | awk '{print $2}' )
  myz=$(echo $ligne | awk '{print $3}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqgos=$( awk '$1==">'$gos'" { split($3, tab, "seq="); print tab[2] }' $fgos )
  seqmyz=$( awk '$1==">'$myz'" { split($3, tab, "seq="); print tab[2] }' $fmyz )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$gos'_'$myz'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$gos"\n"$seqgos"\n"">"$myz"\n"$seqmyz > $sortie
done


entree=~/travail/resultat/alignement/pisum_kondoi_myzus.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  kon=$(echo $ligne | awk '{print $2}' )
  myz=$(echo $ligne | awk '{print $3}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqkon=$( awk '$1==">'$kon'" { split($3, tab, "seq="); print tab[2] }' $fkon )
  seqmyz=$( awk '$1==">'$myz'" { split($3, tab, "seq="); print tab[2] }' $fmyz )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$kon'_'$myz'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$kon"\n"$seqkon"\n"">"$myz"\n"$seqmyz > $sortie
done


entree=~/travail/resultat/alignement/spe_pisum_gossypii.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  gos=$(echo $ligne | awk '{print $2}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqgos=$( awk '$1==">'$gos'" { split($3, tab, "seq="); print tab[2] }' $fgos )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$gos'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$gos"\n"$seqgos > $sortie
done


entree=~/travail/resultat/alignement/spe_pisum_kondoi.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  kon=$(echo $ligne | awk '{print $2}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqkon=$( awk '$1==">'$kon'" { split($3, tab, "seq="); print tab[2] }' $fkon )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$kon'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$kon"\n"$seqkon > $sortie
done


entree=~/travail/resultat/alignement/spe_pisum_myzus.txt
for((i=1; i<=$(wc -l $entree | awk '{print $1}'); i++))
do
  ligne=$( awk 'NR=='$i' {print $0}' $entree )
  pis=$(echo $ligne | awk '{print $1}' | sed -r s/\-PA//)
  myz=$(echo $ligne | awk '{print $2}' )
  seqpis=$( awk '$1~/'$pis'/ { split($2, tab, "seq="); print tab[2] }' $fpis )
  seqmyz=$( awk '$1==">'$myz'" { split($3, tab, "seq="); print tab[2] }' $fmyz )
  echo -e $entree"\t"$i
  sortie=$( echo './'$pis'_'$myz'.fa' )
  echo -e ">"$pis"\n"$seqpis"\n"">"$myz"\n"$seqmyz > $sortie
done
