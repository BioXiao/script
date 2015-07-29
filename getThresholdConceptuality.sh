#!/bin/bash
### Usage : getThresholdConceptuality.sh graph threshold

if [ $# -ne 2 ]
then
    echo "Usage : getThresholdConceptuality.sh graph threshold"
    exit
fi

net=$1
thr=$2

awk '$3<='$thr' {print "inter(\""$1"\",\""$2"\","$3*100000")."}' $net | sort -u | sed s/"\."[0-9]*")"/")"/ > tmp
gringo tmp ~/travail/asp/graphe/mini_score.lp | clasp | sed s/" "/"\n"/g | grep "inter2" | sed s/"inter2"/"inter"/ | awk -F"," '{OFS=","; print $1,$2")."}' > tmpNet

gringo tmpNet ~/travail/asp/graphe/max2_rectangle_clean_v3.lp -c supportm=0 -c supportg=0 | clasp -n0 > tmp
outASP2inASPlisteConcepts.py tmp tmpCon
nbrCon=$(grep "Models" tmp | sed s/"[^0-9]"/""/g)
echo -e "Concepts\t:\t"$nbrCon

gringo tmpNet tmpCon ~/travail/asp/graphe/conceptual_value.lp | clasp > tmp
conceptual=$(grep 'conceptual' tmp | sed s/"[^0-9]"/""/g)
echo -e "Conceptual value\t:\t"$conceptual
