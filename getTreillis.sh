#!/bin/bash
### Usage : getTreillis.sh in out

if [ $# -ne 2 ]
then
    echo "Usage : getTreillis.sh in out"
    exit
fi

in=$1
out=$2

~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $in ~/travail/asp/mdl/treillis.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp | sed s/" "/"\n"/g  | grep 'arete' | sed s/")"/")."/ > $out
