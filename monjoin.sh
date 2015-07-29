#!/bin/bash
### Usage : monJoin.sh fichier1 fichier2

if [ $# -ne 2 ]
then
    echo "Usage : monJoin.sh fichier1 fichier2"
    exit
fi

in1=$1
in2=$2
sep=$3

tmp1='/tmp/'$(echo $in1 | awk -F'/' '{print $NF}')'.tmp'
tmp2='/tmp/'$(echo $in2 | awk -F'/' '{print $NF}')'.tmp'

sort -k 1b,1 $in1 | tee $tmp1 > /dev/null
sort -k 1b,1 $in2 | tee $tmp2 > /dev/null
join $tmp1 $tmp2

rm -f $tmp1 $tmp2
