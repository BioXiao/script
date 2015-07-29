#!/bin/bash
### Usage : getUnionFromCoeffInter.sh coeff inter union valeurs*

if [ $# -ne 4 ]
then
    echo "Usage : getUnionFromCoeffInter.sh coeff inter union valeurs*"
    exit
fi

echo -e "union\tseuil1\tseuil2" > $3

nbligne=$(wc -l $1 | awk '{print $1}')

for(( i=2; i<= $nbligne; i=i+1))
do
    tout=$(awk 'NR=='$i'' $1)
    coefftmp=$(echo $tout | awk '{print $1}')
    coeff=$(calc $coefftmp/$4)
    couple1=$(echo $tout | awk '{print $2}')
    couple2=$(echo $tout | awk '{print $3}')
    inter=$(awk -F"\t" '$2=='$couple1' && $3=='$couple2' {print $1}' $2)    
    union=$(calc 'int('$inter'/'$coeff')')
    echo -e $union"\t"$couple1"\t"$couple2 | tee -a $3 > /dev/null
done
