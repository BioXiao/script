#!/bin/bash
### Usage : join_all.sh fichier1 sortie_spe1 fichier2 sortie_spe2 sortie_intersection

if [ $# -ne 5 ]
then
    echo "Usage : join_all.sh fichier1 sortie_spe1 fichier2 sortie_spe2 sortie_intersection"
    echo "Marche sur la ligne, pas de champs spécifique"
    exit
fi

join_awk_interaction.sh $1 0 $3 0 $5
join_awk_interaction_diff.sh $5 0 $1 0 $2
join_awk_interaction_diff.sh $5 0 $3 0 $4
