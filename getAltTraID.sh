#!/bin/bash
### Usage : getAltTraID.sh allcluster taxonID out

if [ $# -ne 3 ]
then
    echo "getAltTraID.sh allcluster taxonID out"
    exit
fi

cluster=$1
taxonid=$2
out=$3
rm -f $out
baseurl="eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=gene&id="

# Generate the tmp file with only the gene from te taxonID
awk -F"\t" '$2=='$taxonid'' $cluster > tmp_$taxonid

# Get the id of the alternative mRNA
lines=$(wc -l tmp_$taxonid | awk '{print $1}')
for((i=1; i<=$lines; i=i+1))
do
    line=$(awk 'NR=='$i'' tmp_$taxonid)
    clusterid=$(echo $line | awk '{print $1}')
    geneid=$(echo $line | awk '{print $3}')
    url=$(echo $baseurl$geneid)
    wget $url -O tmpres_$taxonid -o trash
    egrep -o 'NM_[0-9]*' tmpres_$taxonid | sort -u | awk '{print '$clusterid' "\t" '$taxonid' "\t" '$geneid' "\t" $0}' | tee -a $out > /dev/null
    egrep -o 'XM_[0-9]*' tmpres_$taxonid | sort -u | awk '{print '$clusterid' "\t" '$taxonid' "\t" '$geneid' "\t" $0}' | tee -a $out > /dev/null
done

rm -f tmp_$taxonid tmpres_$taxonid trash
