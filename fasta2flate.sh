#!/bin/bash
### Usage : fasta2flate.sh in

if [ $# -ne 1 ]
then
    echo "Usage : fasta2flate.sh in"
    exit
fi

in=$1

awk -F"\t" 'BEGIN{ORS=""} {if($0~/>/&& NR==1) {print $1 "\t"}; if($0~/>/ && NR!=1) {print "\n" $1 "\t"} if($0!~/>/ && $0!="") {print $0} if($0==""){print "\n"} } END{print "\n"}' $in
