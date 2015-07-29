#!/bin/bash
### Usage : outASP2inASPlisteConcepts.sh entree sortie

rm -f $2

for i in $(grep -n 'Answer:' $1 | sed s/":.*"/""/g);
do
    number=$(awk 'NR=='$i' {print $2}' $1)
    indice=$(($i+1))
    awk 'NR=='$indice'' $1 | sed s/"appmi("/"concept("$number",micro,"/g | sed s/"apparn("/"concept("$number",arnm,"/g | sed s/" "/"\n"/g | awk '{print $0"."}' | tee -a $2 > /dev/null
done;
