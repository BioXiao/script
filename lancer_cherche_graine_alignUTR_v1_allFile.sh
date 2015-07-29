#!/bin/bash
### Usage : lancer_cherche_graine_alignUTR_v1_allFile.sh predName bam outDir

if [ $# -ne 3 ]
then
    echo "Usage : lancer_cherche_graine_alignUTR_v1_allFile.sh predName bam outDir"
    exit
fi

inName=$1
bam=$2
outDir=$3
nameBam=$(echo $bam | awk -F"/" '{print $NF}')

for((i=1; i<=2; i=i+1))
do
	in=$inName"_"$i".fa"
	out=$outDir""$i".txt"
	#echo $in
	#echo $out
	#echo $bam

	qsub -cwd -N "cherche_graine_alignUTR_v1_"$nameBam"_2File_"$i /omaha-beach/vwucher/bin/lancer_cherche_graine_alignUTR_v1.sh $in $bam $out
	sleep 30
done
