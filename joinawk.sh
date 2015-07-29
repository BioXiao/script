#!/bin/bash
### Usage : joinawk.sh fichier1 champs1 fichier2 champs2 fichier_sortie

awk 'BEGIN{while(getline<"'$1'">0){ar[$'$2']=$0}}{if ($'$4' in ar){print $0, ar[$'$2']}}' $3 | tee $5 > /dev/null
