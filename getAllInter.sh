#!/bin/bash
### Usage : getAllInter.sh f1 f2 f3 f4 sortie


if [ $# -ne 5 ]
then
    echo "Usage : getAllInter.sh f1 f2 f3 f4 sortie"
    exit
fi

cat $1 $2 $3 $4 | sort -u > $5