#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Usage : liste2cysatt.sh entrée sortie nom_attribut"
    exit
fi

awk 'BEGIN{ORS=""; print "'$3'"} { if($0~/concept/){print "\n" $2" ="} else {print " "$0}} END{print "\n"}' $1 > $2