#!/bin/bash
### Usage : getAltTraSeq.sh fileWithID outDirectory

if [ $# -ne 2 ]
then
    echo "Usage : getAltTraSeq.sh fileWithID outDirectory"
    exit
fi

file=$1
outDir=$2

rm -f $outDir'/*'
baseurl="eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&rettype=fasta&id="

lines=$(wc -l $file | awk '{print $1}')
for((i=1; i<=$lines; i=i+1))
do
    id=$(awk -F"\t" 'NR=='$i' {print $4}' $file)
    url=$(echo $baseurl$id)
    out=$(echo $outDir'/'$id'.fasta')
    wget $url -O $out -o trash
done

rm -f trash