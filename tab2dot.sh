#!/bin/bash


# Usage : tab2dot.sh entree.tab sortie.dot

if [ $# -ne 2 ]
then
    echo "Usage : tab2dot.sh entree.tab sortie.dot"
    exit
fi

awk -F'\t' 'BEGIN{print "digraph G {"}; {print "\t" $1 " -> " $2 ";"}; END{print "}"}' $1 > $2