#!/bin/bash
### Usage : idgo2namego.sh.sh entree sortie

if [ $# -ne 2 ]
then
    echo "Usage : idgo2namego.sh.sh entree sortie"
    exit
fi

onto=~/travail/donnees/donnees_original/gene_ontology.1_2_id_name.txt

awk -F" " 'BEGIN{while(getline<"'$onto'">0){ar[$1]=$0}}{if ($2 in ar){print $1 "\t" ar[$2] "\t" $3 "\t" $4}}' $1 > $2
