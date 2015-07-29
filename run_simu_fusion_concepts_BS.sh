#!/bin/bash
### Usage : run_simu_fusion_concepts.sh nNode1 nNode2 nEdge proportion mu1 sd1 mu2 sd2 fileSimu threshold valFusion k

if [ $# -ne 12 ]
then
    echo "Usage : run_simu_fusion_concepts.sh nNode1 nNode2 nEdge proportion mu1 sd1 mu2 sd2 fileSimuGraph threshold valFusion k"
    exit
fi

. ~/.bashrc

# Read parameter
node1=$1
node2=$2
edge=$3
pro=$4
mu1=$5
sd1=$6
mu2=$7
sd2=$8
#fileSimu=$9
threshold=${10}
valFusion=${11}
k=${12}


# Create the name of the file
smallpro=$(echo $4 | sed 's/\(\.[0-9]\{2\}\).*/\1/g')
smallmu1=$(echo $5 | sed 's/\(\.[0-9]\{2\}\).*/\1/g')
smallsd1=$(echo $6 | sed 's/\(\.[0-9]\{2\}\).*/\1/g')
smallmu2=$(echo $7 | sed 's/\(\.[0-9]\{2\}\).*/\1/g')
smallsd2=$(echo $8 | sed 's/\(\.[0-9]\{2\}\).*/\1/g')

fileSimu=$9"_"$node1"n1_"$node2"n2_"$edge"e_"$smallpro"p_"$smallmu1"mu1_"$smallsd1"sd1_"$smallmu2"mu2_"$smallsd2"sd2_"$threshold"thr_"$valFusion"fus_"$k"k.txt"

# Generate random grah
echo "Simulation..."
simu_graphe_alea.r $node1 $node2 $edge $pro $mu1 $sd1 $mu2 $sd2 $fileSimu

# Create the network with a threshold
fileThreshold=$(echo $fileSimu | sed s/".txt"/"_inf"$threshold".txt"/)
awk 'NR>1 && $4<='$threshold' {print $1 "\t" $2}' $fileSimu | sort -u > $fileThreshold
echo -ne "Number of interaction with a threshold of "$threshold":\t"
wc -l $fileThreshold | cut -d" " -f1

# Generate formal concepts and lattice
netIn=$(echo $fileThreshold | sed s/".txt"/".lp"/)
conOut=$(echo $fileThreshold | sed s/".txt"/"_concept.out"/)
fileConcept=$(echo $fileThreshold | sed s/".txt"/"_concept.lp"/)
latticeOut=$(echo $fileThreshold | sed s/".txt"/"_lattice.out"/)
fileLattice=$(echo $fileThreshold | sed s/".txt"/"_lattice.lp"/)

awk '{print "inter(\""$1"\",\""$2"\")."}' $fileThreshold > $netIn

echo "Formal concepts generation..."
/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $netIn ~/travail/asp/graphe/max2_rectangle_clean_v3.lp -c supportm=0 -c supportg=0 | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $conOut
outASP2inASPlisteConcepts.py $conOut $fileConcept
echo -ne "Number of formal concepts:\t"
sed s/",".*/""/ $fileConcept | sort -u | wc -l | cut -d" " -f1

echo "Lattice generation..."
/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $fileConcept ~/travail/asp/graphe/treillis_v8.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $latticeOut
sed s/" "/"\n"/g $latticeOut | grep 'arete' | sed s/")"/")."/ > $fileLattice
echo -ne "Number of egde in the lattice:\t"
wc -l $fileLattice | cut -d" " -f1

# Make a graph file for ASP
inForMerge=$(echo $fileThreshold | sed s/".txt"/"_score*100000.lp"/)
awk 'NR>1 {print "inter(\""$1"\",\""$2"\","$4*100000")."}' $fileSimu | sed s/"\."[0-9]/""/ > $inForMerge

# Merge the concepts
outFusion=$(echo $inForMerge | sed s/".lp"/"_mergemax"$k"_fusion"$valFusion".outASP"/)
echo "Merging concepts..."
/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $inForMerge $fileConcept $fileLattice ~/travail/asp/reduction_treillis/fusion_treillis_v6.lp -c mergemax=$k -c fusion=$valFusion | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $outFusion
echo -ne "Number of concepts merged with k="$k" and fusion="$valFusion":\t"
tail -n6 $outFusion | head -n1 | sed s/" "/"\n"/g | grep -c 'mergeScore'

# Make the final graph
final=$(echo $outFusion | sed s/".outASP"/".lp"/)
tail -n6 $outFusion | head -n1 | sed s/" "/"\n"/g | grep 'finalinter' | sed s/"final"/""/ | sed s/")"/")."/ > $final
echo -ne "Number of interaction in the final graph:\t"
wc -l $final | cut -d" " -f1

# Compare the number of true and false interaction
sed s/"inter("/""/ $final | sed s/")."/""/ | sed s/"\""/""/g > tmp
awk 'NR>1 {print $1","$2 "\t" $3 "\t" $4}' $fileSimu > tmpori
# Simulate
echo "Number of true and false interaction in the simulated graph:"
cut -f2 tmpori | sort | uniq -c

# Simulate with a threshold
echo "Number of true and false interaction in the simulated graph with a threshold:"
awk '$3<='$threshold' {print $2}' tmpori | sort | uniq -c

# New graph
echo "Number of true and false interaction in the new graph:"
monJoin.sh tmpori tmp | cut -d" " -f2 | sort | uniq -c


# Ratio between true and false edges
echo "Ratio between true and false interaction:"
# Simulated with a threshold
trueS=$(awk '$3<='$threshold' {print $2}' tmpori | sort | grep -c "trueEdge")
falseS=$(awk '$3<='$threshold' {print $2}' tmpori | sort | grep -c "falseEdge")
echo -ne "\tIn the simulated graph with a threshold:"
calc $trueS/$falseS
# New graph
trueN=$(monJoin.sh tmpori tmp | cut -d" " -f2 | sort | grep -c "trueEdge")
falseN=$(monJoin.sh tmpori tmp | cut -d" " -f2 | sort | grep -c "falseEdge")
echo -ne "\tIn the new graph:\t\t\t"
calc $trueN/$falseN

# Reduction for true and false interaction between the simulated graph with a threshold and the new graph
echo "Ratio between the simulated graph with a threshold and the new graph:"
# True
echo -ne "\tFor true interaction:"
calc $trueS/$trueN
# False
echo -ne "\tFor false interaction:"
calc $falseS/$falseN

rm -f tmpori tmp


# Get the concepts for the new graph
finalConOut=$(echo $final | sed s/".lp"/"_concept.out"/)
finalConcept=$(echo $final | sed s/".lp"/"_concept.lp"/)

echo "Formal concepts generation new graph..."
/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $final ~/travail/asp/graphe/max2_rectangle_clean_v3.lp -c supportm=0 -c supportg=0 | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $finalConOut
outASP2inASPlisteConcepts.py $finalConOut $finalConcept
echo -ne "Number of formal concepts in the new graph:\t"
sed s/",".*/""/ $finalConcept | sort -u | wc -l | cut -d" " -f1


# Get the coscore for the two graphs
simuASP=$(echo $fileSimu | sed s/".txt"/".lp"/)
# Parsing of the simulated network to an ASP format
awk 'NR>1 { print "inter(\""$1"\",\""$2"\",\""$3"\")." }' $fileSimu | sort -u > $simuASP

interConceptOut=$(echo $fileThreshold | sed s/".txt"/"_interConcept.out"/)
finalInterConceptOut=$(echo $final | sed s/".lp"/"_interConcept.out"/)
interConcept=$(echo $fileThreshold | sed s/".txt"/"_interConcept.lp"/)
finalInterConcept=$(echo $final | sed s/".lp"/"_interConcept.lp"/)
coscoreOut=$(echo $fileThreshold | sed s/".txt"/"_coscore.out"/)
finalCoscoreOut=$(echo $final | sed s/".lp"/"_coscore.out"/)
coscore=$(echo $fileThreshold | sed s/".txt"/"_coscore.lp"/)
finalCoscore=$(echo $final | sed s/".lp"/"_coscore.lp"/)

# Get the liste of interaction take into account by each concepts
/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $netIn $fileConcept ~/travail/asp/reduction_treillis/liste_concept_to_liste_interConcept.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $interConceptOut
sed s/" "/"\n"/g $interConceptOut | grep "conceptInter" | sed s/")"/")."/ > $interConcept

/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $final $finalConcept ~/travail/asp/reduction_treillis/liste_concept_to_liste_interConcept.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $finalInterConceptOut
sed s/" "/"\n"/g $finalInterConceptOut | grep "conceptInter" | sed s/")"/")."/ > $finalInterConcept

# Get the coscore
echo "Get the Co-score..."
/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $simuASP $interConcept ~/travail/asp/reduction_treillis/liste_interConcept_to_coscore.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $coscoreOut
sed s/" "/"\n"/g $coscoreOut | grep "coscore" | sed s/"coscore("/""/ | sed s/")"/""/ | awk -F"," 'BEGIN{OFS="\t"; print "concept\tratio\tcoscore"} {print $1,$2,$3}' > $coscore

/local/vwucher/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $simuASP $finalInterConcept ~/travail/asp/reduction_treillis/liste_interConcept_to_coscore.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $finalCoscoreOut
sed s/" "/"\n"/g $finalCoscoreOut | grep "coscore" | sed s/"coscore("/""/ | sed s/")"/""/ | awk -F"," 'BEGIN{OFS="\t"; print "concept\tratio\tcoscore"} {print $1,$2,$3}' > $finalCoscore
