#!/bin/bash
### Usage : getRandNoiseAll.sh nObj nAtt nCon mObj mAtt %noise name

if [ $# -ne 7 ]
then
    echo "Usage : getRandNoiseAll.sh nObj nAtt nCon mObj mAtt %noise name"
    exit
fi

nObj=$1
nAtt=$2
nCon=$3
mObj=$4
mAtt=$5
pnoise=$6
name=$7

#echo $name

echo "Random"
random_concept_noise_geneConcept.r $nObj $nAtt $nCon $mObj $mAtt $pnoise $name".txt"

echo "Inter"
randomConceptNoise_R2ASP.sh $name".txt" $name".lp"

echo "Concept"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo ~/travail/asp/mdl/getConceptSpurious.lp $name".lp" | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $name".c.out"
outASP2inASPlisteConcepts.py $name".c.out" $name".c.lp"

echo "Treillis"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $name".c.lp" ~/travail/asp/mdl/treillis.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp | sed s/" "/"\n"/g  | grep 'arete' | sed s/")"/")."/ > $name".t.lp"
