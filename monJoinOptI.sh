#!/bin/bash
### Usage : monJoinOptI.sh file1 file2


if [ $# -ne 2 ]
then
    echo "Usage : monJoinOptI.sh file1 file2"
    exit
fi

in1=$1
in2=$2

tmp1="/tmp/"$(echo $RANDOM)".tmp"
tmp2="/tmp/"$(echo $RANDOM)".tmp"

sort -k 1b,1 $in1 > $tmp1
sort -k 1b,1 $in2 > $tmp2
join -i $tmp1 $tmp2

rm -f $tmp1 $tmp2
