#!/bin/bash
### Usage : run_only_thresholdConceptLattice_BS.sh fileSimu threshold dirOut

if [ $# -ne 3 ]
then
    echo "Usage : run_only_thresholdConceptLattice_BS.sh fileSimu threshold dirOut"
    exit
fi

. ~/.bashrc

# Read parameter
threshold=$2
dirOut=$3

# Create the name of the file
fileSimu=$1

# Create the tmp out
tmpOut=$3$(echo $1 | sed s/.*"\/"/""/)

# Create the network with a threshold
#fileThreshold=$(echo $tmpOut | sed s/".txt"/"_inf"$threshold".txt"/)
#awk 'NR>1 && $4<='$threshold' {print $1 "\t" $2}' $fileSimu | sort -u > $fileThreshold
#echo -ne "Number of miRNA/mRNA with a threshold of "$threshold":\t"
#wc -l $fileThreshold | cut -d" " -f1

# Create the network with a threshold for BS
fileThreshold=$(echo $tmpOut | sed s/".txt"/"_inf"$threshold".txt"/)
awk 'NR>1 && $4<='$threshold' {print $1 "\t" $2 "\t" $4}' $fileSimu | sort -u > $fileThreshold
echo -ne "Number of BS with a threshold of "$threshold":\t"
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
