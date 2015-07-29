#!/bin/bash
### Usage : getConceptLatticeFromBioNet.sh dir name

if [ $# -ne 2 ]
then
    echo "Usage : getConceptLatticeFromBioNet.sh dir name"
    exit
fi

dir=$1
out=$2

name=$dir$out

~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo ~/travail/asp/mdl/getConceptSpurious.lp $name".lp" | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $name".c.out"
outASP2inASPlisteConcepts.py $name".c.out" $name".c.lp"

~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $name".c.lp" ~/travail/asp/mdl/treillis.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp | sed s/" "/"\n"/g  | grep 'arete' | sed s/")"/")."/ > $name".t.lp"
