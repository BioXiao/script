#!/bin/bash
### Usage : getConceptAndrelated2multiDot.sh listeNumConcept concept treillis outDir dotName

if [ $# -ne 5 ]
then
    echo "Usage : getConceptAndrelated2multiDot.sh listeNumConcept concept treillis outDir dotName"
    exit
fi

liste=$1
con=$2
tre=$3
dir=$4
name=$5

### Get tmp file fot concept of interests
sed 's/\(.*\)/concept(\1)./' $liste > tmpListe

### Add related concepts
sed 's/\(.*\)/(\1,/' $liste > tmpL1
#sed 's/\(.*\)/,\1)/' $liste > tmpL2
grep --file=tmpL1 $tre | sed 's/arete(.*,\(.*\))./concept(\1)./' >> tmpListe

### Get connexe composantes (CC)
gringo ~/travail/resultat/fusion_contexte/code/compConnexe.lp tmpListe $tre | clasp -n0 | sed 's/cConcept/concept/g' > tmpCC

### Get ASP type file for each CC
parseCompConnexeASP2multiFile.py tmpCC $dir $name"_listeCC"

### Get number of CC
num=$(ls $dir$name"_listeCC"* | wc -l)

### For each CC ASP type file get a dot file
#for fifi in $(ls $dir$name"_listeCC"*)
for((i=1; i<=$num; i=i+1))
do
    fifi=$dir$name"_listeCC_"$i".lp"
    sed 's/concept(\(.*\))./\1/' $fifi > tmpX

### Get tmp file for search in concept and treillis file
    sed 's/\(.*\)/(\1,/' tmpX > tmp1
    sed 's/\(.*\)/,\1)/' tmpX > tmp2

### Get concepts
    grep --file=tmp1 $con > tmpC

### Get relations
    echo -e "arete2(N1,N2) :- arete(N1,N2), concept(N1;N2)." >> $fifi
    gringo $tre $fifi | grep "arete2" | sed 's/arete2/arete/' > tmpT

    sort -u tmpC > tmpC2
    sort -u tmpT > tmpT2

    conceptTreillisAttribut2dot.py tmpC2 tmpT2 $dir$name"_"$i".dot"

### Replace ugly name
    sed -i 's/premiereCinDiff/PCD/g' $dir$name"_"$i".dot"

    sed -i 's/cycleCellulaire/cycle cellulaire/g' $dir$name"_"$i".dot"
    sed -i 's/ovogenese/ovogenèse/g' $dir$name"_"$i".dot"
    sed -i 's/regPostTranscriptionelle/régulation post-transcriptionnelle/g' $dir$name"_"$i".dot"
    sed -i 's/epigenetique/épigénétique/g' $dir$name"_"$i".dot"
    sed -i 's/systemeNeuroendocrine/système neuroendocrine/g' $dir$name"_"$i".dot"
    sed -i 's/dvpMuscles/développement musculaire/g' $dir$name"_"$i".dot"
    sed -i 's/regTranscriptionnelle/régulation transcriptionnelle/g' $dir$name"_"$i".dot"

    sed -i 's/apparitionPicNeg/apparition pic négatif/g' $dir$name"_"$i".dot"
    sed -i 's/apparitionPicPos/apparition pic positif/g' $dir$name"_"$i".dot"
    sed -i 's/disparitionPicPos/disparition pic positif/g' $dir$name"_"$i".dot"
    sed -i 's/disparitionPicNeg/disparition pic négatif/g' $dir$name"_"$i".dot"

done

### Delete tmp file
rm -f tmp1 tmp2 tmpC tmpT tmpC2 tmpT2 tmpListe tmpCC tmpX tmpL1
