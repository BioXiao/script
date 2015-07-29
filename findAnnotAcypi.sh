#!/bin/bash
### Usage : findAnnotAcypi.sh ACYPI_1 ACYPI_2 ACYPI_3 ... ACYPI_N

if [ $# -lt 1 ]
then
    echo "Usage : findAnnotAcypi.sh ACYPI_1 ACYPI_2 ACYPI_3 ... ACYPI_N"
    exit
fi

go=~/travail/resultat/arn_05112012/annotation_go/aphidbase_2.1_pep_max_b2g_v03022014_GO_name_v18072014_arnDiff_reseau_reduit_inf-0.3.txt
fnt=~/travail/resultat/fusion_contexte/arn/fonction_semiAuto_touteFnt.att.lp
cin=~/travail/resultat/arn_05112012/cinetique/mRNA_disc_Ti_vs_Tj_edgeR_distance_profilsDiff.csv
denis=~/aide_denis/gene_id_name_fntGO_denis.csv
qtl=~/aide_denis/43_genes_GLT.csv



for id in $@
do
    echo "%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%% "$id" %%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%% GO %%%%%"
    grep $id $go
    echo ""
    echo "%%%%% Fonction %%%%%"
    grep $id $fnt
    echo ""
    echo "%%%%% Cinétique %%%%%"
    grep $id $cin
    echo ""
    echo "%%%%% Denis %%%%%"
    grep $id $denis
    echo ""
    echo "%%%%% QTL %%%%%"
    grep $id $qtl
    echo ""
    echo ""
done
