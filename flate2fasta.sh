#!/bin/bash
### Usage : fasta2flate.sh in

if [ $# -ne 1 ]
then
    echo "Usage : fasta2flate.sh in"
    exit
fi

in=$1

awk -F"\t" 'BEGIN{OFS="\n"} {print $1, $2}' $in

