#!/bin/bash
### Usage : getApisGO.sh id (more id)

if [ $# -lt 1 ]
then
    echo "Usage : getApisGO.sh id (more id)"
    exit
fi

id=$(echo $* | sed s/"-".." "/" "/g | sed s/"-"..$/""/)
annot=~/travail/donnees/donnees_original/aphidbase_2.1_goGenome.txt
goName=~/travail/donnees/donnees_original/gene_ontology.1_2_id_name.txt

tmp=$(date | awk '{print $4}')

for gene in $id; do awk '$1~/'$gene'/ {print $0}' $annot >> $tmp; done;

awk -F"\t" 'BEGIN{while(getline<"'$goName'">0){ar[$1]=$0}}{if ($2 in ar){split(ar[$2], tab, "\t"); print $1 "\t" tab[1], tab[2]}}' $tmp

rm -f $tmp
