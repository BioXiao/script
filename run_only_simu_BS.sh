#!/bin/bash
### Usage : run_only_simu_BS.sh nNode1 nNode2 nEdge proportion mu1 sd1 mu2 sd2 fileSimu threshold

if [ $# -ne 10 ]
then
    echo "Usage : run_only_simu_BS.sh nNode1 nNode2 nEdge proportion mu1 sd1 mu2 sd2 fileSimuGraph threshold"
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
threshold=${10}


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
echo -ne "Number of miRNA/mRNA with a threshold of "$threshold":\t"
wc -l $fileThreshold | cut -d" " -f1

# Generate formal concepts and lattice
netIn=$(echo $fileThreshold | sed s/".txt"/".lp"/)
conOut=$(echo $fileThreshold | sed s/".txt"/"_concept.out"/)
fileConcept=$(echo $fileThreshold | sed s/".txt"/"_concept.lp"/)
latticeOut=$(echo $fileThreshold | sed s/".txt"/"_lattice.out"/)
fileLattice=$(echo $fileThreshold | sed s/".txt"/"_lattice.lp"/)

awk 'NR>1 && $4<='$threshold' {print "inter(\""$1"\",\""$2"\","$4*100000")."}' $fileSimu | sort -u | sed s/"\."[0-9]*")"/")"/ > $fileSimu"tmp"
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $fileSimu"tmp" ~/travail/asp/reduction_treillis/bs_to_all_couple.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp | sed s/" "/"\n"/g | grep "interNbr" | sed s/"Nbr"/""/ | sed s/")"/")."/ | sed s/"\""/""/4 | awk -F"," '{split($3, tab, ")"); print $1","$2tab[1]"\")."}' > $netIn

echo "Formal concepts generation..."
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $netIn ~/travail/asp/graphe/max2_rectangle_clean_v3.lp -c supportm=0 -c supportg=0 | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp -n0 > $conOut
outASP2inASPlisteConcepts.py $conOut $fileConcept
echo -ne "Number of formal concepts:\t"
sed s/",".*/""/ $fileConcept | sort -u | wc -l | cut -d" " -f1

echo "Lattice generation..."
~/travail/programmes/logique/old/gringo-3.0.3-x86-linux/gringo $fileConcept ~/travail/asp/graphe/treillis_v8.lp | ~/travail/programmes/logique/clasp-2.1.0/build/release_mt/bin/clasp > $latticeOut
sed s/" "/"\n"/g $latticeOut | grep 'arete' | sed s/")"/")."/ > $fileLattice
echo -ne "Number of edge in the lattice:\t"
wc -l $fileLattice | cut -d" " -f1


rm -f $fileSimu"tmp"
