#!/bin/bash
### Usage : getRatioClassesRules.sh allAspSolution nbrOfTheSolution tarTarget tarCount out

if [ $# -ne 5 ]
then
    echo "Usage : getRatioClassesRules.sh allAspSolution nbrOfTheSolution tarTarget tarCount out"
    exit
fi

allAspSolution=$1
nbrOfTheSolution=$2
tarTarget=$3
tarCount=$4
out=$5

head -n$nbrOfTheSolution $allAspSolution | tail -n1 | sed s/" "/"\n"/g | grep 'microMatch2' | sed s/"microMatch2("/""/g | sed s/"))\."/""/g | sed s/"\""/""/g | sed s/",.*("/"\t"/g > tmp1
monJoin.sh tmp1 $tarTarget | awk '{print $1"\t"$3"\t"$2}' > tmp2
awk '{print $2"\t"$3}' tmp2 | sort | uniq -c | sed s/"^ *"/""/g | sort -n > tmp3
awk 'BEGIN{while(getline<"'$tarCount'">0){ar[$2]=$1}}{split($2,arn,"_"); if (arn[1] in ar){print $1"\t"ar[arn[1]]"\t"arn[1]"\t"$3}}' tmp3 > $out

rm -f tmp1 tmp2 tmp3
