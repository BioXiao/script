#!/bin/bash
### Usage : outASP2bblFile.sh outASP network concepts outBBL

if [ $# -ne 4 ]
then
    echo "Usage : outASP2bblFile.sh outASP network concepts outBBL"
    exit
fi

asp=$1
net=$2
con=$3
out=$4

sed s/" "/"\n"/g $asp > tmp

### NODE
awk '{print "NODE\t" $1 "\n" "NODE\t" $2}' $net | sort -u > $out


### PowerNode
for concept in $(grep 'chosenconcept' tmp | sed s/"chosenconcept("/""/ | sed s/")"/""/)
do
    echo -e "SET\tPowerNode"$concept"miRNA\t0.0" >> $out
    echo -e "SET\tPowerNode"$concept"mRNA\t0.0" >> $out
    grep 'concept('$concept',micro' $con | sed s/"concept(".*",\""/"IN\t"/ | sed s/"\")."/"\tPowerNode"$concept"miRNA"/g | sort -u >> $out
    grep 'concept('$concept',arnm' $con | sed s/"concept(".*",\""/"IN\t"/ | sed s/"\")."/"\tPowerNode"$concept"mRNA"/g | sort -u >> $out
    echo -e "EDGE\tPowerNode"$concept"miRNA\tPowerNode"$concept"mRNA\t1.0" >> $out
done

grep 'linkedchosen' tmp | sed s/"linkedchosen("/""/ | sed s/")"/""/ | awk -F "," '{print "IN\tPowerNode" $2 "miRNA\tPowerNode" $1 "miRNA" "\n" "IN\tPowerNode" $1 "mRNA\tPowerNode" $2 "mRNA"}' >> $out

#for linked in $(grep 'linkedchosen' tmp | sed s/"linkedchosen("/""/ | sed s/")"/""/)
#do
    #echo $linked
    #echo $linked | awk -F "," '{print "IN\tPowerNode" $2 "miRNA\tPowerNode" $1 "miRNA" "\n" "IN\tPowerNode" $1 "mRNA\tPowerNode" $2 "mRNA"}' >> $out
#done


### EDGE "exclude"
grep 'edgeexcluded' tmp | sed s/"edgeexcluded("/"EDGE\t"/ | sed s/")"/"\t1.0"/ | sed s/","/"\t"/ | sed s/"\""/""/g >> $out

# | awk '{print "EDGE\t" $0 "\t1.0"}'

#sort $out > tmp
#mv tmp > $out


#rm -f tmp
