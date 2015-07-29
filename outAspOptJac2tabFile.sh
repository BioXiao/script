#!/bin/bash
### Usage : outAspOptJac2tabFile.sh in out

if [ $# -ne 2 ]
then
    echo "Usage : outAspOptJac2tabFile.sh in out"
    exit
fi

in=$1
out=$2

echo -e "seuil1\tseuil2\tjaccard\tintersection\tunion" > $2

grep 'res' $1 | sed s/" "/"\n"/g | grep 'res(' | sed s/"res("//g | sed s/")"//g | sed s/","/"\t"/g | tee -a $2 > /dev/null
