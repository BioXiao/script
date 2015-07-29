#!/bin/bash
### Usage : getConceptTreillis.sh in outI outC inC outT

if [ $# -ne 5 ]
then
    echo "Usage : getConceptTreillis.sh in outI outC inC outT"
    exit
fi

in=$1
outI=$2
outC=$3
inC=$4
outT=$5


echo "Inter"
randomConceptNoise_R2ASP.sh $in $outI

echo "Concept"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo ~/travail/asp/mdl/getConceptSpurious.lp $outI | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $outC
outASP2inASPlisteConcepts.py $outC $inC

echo "Treillis"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $inC ~/travail/asp/mdl/treillis.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp | sed s/" "/"\n"/g  | grep 'arete' | sed s/")"/")."/ > $outT
