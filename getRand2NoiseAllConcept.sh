#!/bin/bash
### Usage : getRandNoiseAll.sh nObj nAtt nCon mObj mAtt %noiseSpu %noiseMis name

if [ $# -ne 8 ]
then
    echo "Usage : getRandNoiseAll.sh nObj nAtt nCon mObj mAtt %noiseSpu %noiseMis name"
    exit
fi

nObj=$1
nAtt=$2
nCon=$3
mObj=$4
mAtt=$5
pnoiseS=$6
pnoiseM=$7
name=$8

#echo $name

echo "Random"
random_concept_2noise_geneConcept.r $nObj $nAtt $nCon $mObj $mAtt $pnoiseS $pnoiseM $name".txt"

echo "Inter"
randomConceptNoise_R2ASP.sh $name".txt" $name".lp"

echo "Concept"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo ~/travail/asp/mdl/getConceptSpurious.lp $name".lp" | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $name".c.out"
outASP2inASPlisteConcepts.py $name".c.out" $name".c.lp"

echo "Treillis"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $name".c.lp" ~/travail/asp/mdl/treillis.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp | sed s/" "/"\n"/g  | grep 'arete' | sed s/")"/")."/ > $name".t.lp"
