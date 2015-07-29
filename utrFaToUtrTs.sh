#!/bin/bash
### Usage : utrFaToUtrTs.sh utrFasta taxonID utrTargetScan


if [ $# -ne 3 ]
then
    echo "Usage : utrFaToUtrTs.sh utrFasta taxonID utrTargetScan"
    exit
fi

in=$1
taxonID=$2
out=$3

awk 'BEGIN{ORS=""}{if($0~/>/){print "\n" substr($0,2) "\t""'$taxonID'" "\t"}; if ($0!~/>/){print $0}} END{print "\n"}' $in > tmp

# Pour enlever la ligne blanche au debut du fichier
ligne=$(wc -l tmp | awk '{print $1}')
toget=$(($ligne-1))

tail -n$toget tmp > $out

rm -f tmp