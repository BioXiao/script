#!/bin/bash
### Usage : getApisName.sh id (more id)

if [ $# -lt 1 ]
then
    echo "Usage : getApisName.sh id (more id)"
    exit
fi

tmp=$(date | awk '{print $4}')

id=$(echo $* | sed s/"-".." "/" "/g | sed s/"-"..$/""/)
name=~/travail/donnees/donnees_original/aphidbase_2.1_pep.B2G.annot

for gene in $id; do awk -F"\t" '$1~/'$gene'/ {print $1 "\t" $3}' $name >> $tmp; done;

sort -u $tmp
rm -f $tmp
