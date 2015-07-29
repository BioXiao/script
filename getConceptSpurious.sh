#!/bin/bash
### Usage : getConceptSpurious.sh in out

if [ $# -ne 2 ]
then
    echo "Usage : getConceptSpurious.sh in out"
    exit
fi

in=$1
out=$2


~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo getConceptSpurious.lp $in | /home/vwucher/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $in".tmp"

outASP2inASPlisteConcepts.py $in".tmp" $out

rm -f $in".tmp"
