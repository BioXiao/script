#! /bin/sh

# Usage : obt_interaction.sh entrée1 seuil1 sortie1 entrée2 seuil2 sortie2 sortie_total

if [ $# -ne 7 ]
then
    echo "Usage : obt_interaction.sh entrée1 seuil1 sortie1 entrée2 seuil2 sortie2 sortie_total"
    exit
fi


echo $1
awk '$3<='$2' {print $1 "T" $2 "\t" $3}' $1 > ./tmp1
echo $4
awk '$3<='$5' {print $1 "T" $2 "\t" $3}' $4 > ./tmp2


echo $1" VS "$4
join_awk_interaction.sh ./tmp1 1 ./tmp2 1 ./join_awk.tmp
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./join_awk.tmp | awk '{print $1 "\t" $2}' > $7

echo $3
join_awk_interaction_diff.sh $7 1 ./tmp1 1 ./tmp11
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./tmp11 | awk '{print $1 "\t" $2 "\t" $3}' > $3

echo $6
join_awk_interaction_diff.sh $7 1 ./tmp2 1 ./tmp22
awk -F"TACYPI" '{print $1 "\tACYPI" $2}' ./tmp22 | awk '{print $1 "\t" $2 "\t" $3}' > $6

rm -f ./tmp1 ./tmp2 ./tmp11 ./tmp22 ./join_awk.tmp ./join_awk2.tmp ./join_awk3.tmp
