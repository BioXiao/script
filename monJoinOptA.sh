#!/bin/bash
### Usage : monJoinOptA.sh file1 file2 fileNumber

if [ $# -ne 3 ]
then
    echo "Usage : monJoinOptA.sh file1 file2 fileNumber"
    exit
fi

in1=$1
in2=$2
num=$3

tmp1="/tmp/"$(echo $RANDOM)".tmp"
tmp2="/tmp/"$(echo $RANDOM)".tmp"

sort -k 1b,1 $in1 > $tmp1
sort -k 1b,1 $in2 > $tmp2
join -a$num $tmp1 $tmp2

rm -f $tmp1 $tmp2
