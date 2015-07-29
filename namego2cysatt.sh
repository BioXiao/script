#!/bin/bash
### Usage : namego2cysatt.sh entree sortie

if [ $# -ne 2 ]
then
    echo "Usage : namego2cysatt.sh entree sortie"
    exit
fi

awk -F'\t' 'BEGIN{print "ConceptNameGO"} $0~/GO\:/ {print $1 " = " $3}' $1 > $2
