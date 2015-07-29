#!/bin/bash
### Usage : join_awk_interaction.sh fichier1 champs1 fichier2 champs2 fichier_sortie

if [ $# -ne 5 ]
then
    echo "Usage : join_awk_interaction.sh fichier1 champs1 fichier2 champs2 fichier_sortie"
    exit
fi

awk -F"\t" 'BEGIN{while(getline<"'$1'">0){ar[$'$2']=$0}}{if ($'$4' in ar){print $0}}' $3 > $5
