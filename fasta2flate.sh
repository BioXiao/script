#!/bin/bash
### Usage : fasta2flate.sh in

if [ $# -ne 1 ]
then
    echo "Usage : fasta2flate.sh in"
    exit
fi

in=$1

awk 'BEGIN{ORS=""} {if($0~/>/&& NR==1) {print $1 "\t"}; if($0~/>/ && NR!=1) {print "\n" $1 "\t"} if($0!~/>/) {print $0} } END{print "\n"}' $in
