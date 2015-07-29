#!/bin/bash
### Usage : join_awk_interaction.sh fichier1 champs1 fichier2 champs2

if [ $# -ne 4 ]
then
    echo "Usage : join_awk_interaction.sh fichier1 champs1 fichier2 champs2"
    exit
fi

awk -F"\t" 'BEGIN{while(getline<"'$1'">0){ar[$'$2']=$0}}{if ($'$4' in ar){print $0 "\t" ar[$'$4']}}' $3
