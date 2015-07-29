#!/bin/bash
### Usage : flate2fasta.sh in

if [ $# -ne 1 ]
then
    echo "Usage : flate2fasta.sh in"
    exit
fi

in=$1

awk -F"\t" 'BEGIN{OFS=""; ORS=""} { print $1"\n"; len=length($2); split($2,tab,""); flag=0; for(i=1; i<=len; i++){print tab[i]; flag=flag+1; if(flag==60){print "\n"; flag=0}}; if(flag!=0){print "\n"} }' $in
