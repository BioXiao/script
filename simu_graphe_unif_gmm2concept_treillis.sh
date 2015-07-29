#!/bin/bash
### Usage : simu_graphe_unif_gmm2concept_treillis.sh thres name dirout

if [ $# -ne 3 ]
then
    echo "Usage : simu_graphe_unif_gmm2concept_treillis.sh thres name dirout"
    exit
fi

t=$1
name=$2
dirout=$3

echo "Inter"
awk 'NR>1 {print "inter(\""$1"\",\""$2"\",\""$3"\","$4*100000")."}' $name".txt" | sed s/"\."[0-9]*")"/")"/ > $name".lp"
#tail -n+2 $name".txt" | cut -f1,2,4 | awk '{print "inter(\""$1"\",\""$2"\","$3*100000")." }' | sed s/"\."[0-9]*")"/")"/ > $name"_onlyScore.lp"


echo "Concept"
gringo $name".lp" ~/travail/asp/graphe/concept_supportInterval_threshold_v2.lp -c thres=$t | clasp -n0 > $dirout$name".c.out"
outASP2inASPlisteConcepts.py $dirout$name".c.out" $dirout$name".c.lp"


echo "Treillis"
gringo $dirout$name".c.lp" ~/travail/asp/graphe/treillis_v9.lp | clasp | sed s/" "/"\n"/g  | grep 'arete' | sed s/")"/")."/ > $dirout$name".t.lp"
