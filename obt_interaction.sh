#! /bin/sh

# Usage : obt_interaction.sh entrée1 seuil1 sortie1 entrée2 seuil2 sortie2 entrée3 seuil3 sortie3 sortie_total

if [ $# -ne 10 ]
then
    echo "Usage : obt_interaction.sh entrée1 seuil1 sortie1 entrée2 seuil2 sortie2 entrée3 seuil3 sortie3 sortie_total"
    exit
fi


echo $1
awk '$3<='$2' {print $1 "T" $2 "\t" $3}' $1 > ./tmp1
echo $4
awk '$3<='$5' {print $1 "T" $2 "\t" $3}' $4 > ./tmp2
echo $7
awk '$3<='$8' {print $1 "T" $2 "\t" $3}' $7 > ./tmp3


echo $1" VS "$4
join_awk_interaction.sh ./tmp1 1 ./tmp2 1 ./join_awk.tmp
awk '{print $1}' ./join_awk.tmp > ./join_awk2.tmp

echo "join_awk.tmp VS "$7 " -> " ${10}
join_awk_interaction.sh ./join_awk2.tmp 1 ./tmp3 1 ./join_awk3.tmp
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./join_awk3.tmp | awk '{print $1 "\t" $2}' > ${10}
#cat ./join_awk3.tmp | tr "(TACYPI)" "\t ACYPI" > ${10}

echo $3
join_awk_interaction_diff.sh ${10} 1 ./tmp1 1 ./tmp11
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./tmp11 | awk '{print $1 "\t" $2 "\t" $3}' > $3
#cat ./tmp11 | tr "(TACYPI)" "\t ACYPI" > $3

echo $6
join_awk_interaction_diff.sh ${10} 1 ./tmp2 1 ./tmp22
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./tmp22 | awk '{print $1 "\t" $2 "\t" $3}' > $6
#cat ./tmp22 | tr "(TACYPI)" "\t ACYPI" > $6

echo $9
join_awk_interaction_diff.sh ${10} 1 ./tmp3 1 ./tmp33
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./tmp33 | awk '{print $1 "\t" $2 "\t" $3}' > $9
#cat ./tmp33 | tr "(TACYPI)" "\t ACYPI" > $9

rm -f ./tmp1 ./tmp2 ./tmp3 ./tmp11 ./tmp22 ./tmp33 ./join_awk.tmp ./join_awk2.tmp ./join_awk3.tmp
