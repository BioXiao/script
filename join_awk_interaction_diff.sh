#!/bin/bash
### Usage : join_awk_interaction_diff.sh fichier1 champs1 fichier2_affiche champs2 fichier_sortie

if [ $# -ne 5 ]
then
    echo "Usage : join_awk_interaction_diff.sh fichier1 champs1 fichier2_affiche champs2 fichier_sortie"
    exit
fi

awk -F" " 'BEGIN{while(getline<"'$1'">0){ar[$'$2']=$0}}{if ($'$4' in ar){} else{print $0}}' $3 > $5
