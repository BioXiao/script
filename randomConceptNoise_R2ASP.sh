#!/bin/bash
### Usage : randomConceptNoise_R2ASP.sh in out

if [ $# -ne 2 ]
then
    echo "Usage : randomConceptNoise_R2ASP.sh in out"
    exit
fi

in=$1
out=$2

awk '{OFS="\""; print "inter(",$1,",",$2,",",$3,")."}' $in > $out
