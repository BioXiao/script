#!/bin/bash
### Usage : getConceptAndrelated2multiDotPdf_multiView.sh concept treillis outDir dotName pdfName

if [ $# -ne 5 ]
then
    echo "Usage : getConceptAndrelated2multiDotPdf_multiView.sh conceptASP treillisASP outDir dotName(only) pdfName(only)"
    exit
fi

. /local/env/envgringo-3.0.4.sh
. /local/env/envclasp-2.1.3.sh
. /local/env/envpython-3.3.2.sh
. /local/env/envgraphviz-2.28.sh 

con=$1
tre=$2
dir=$3
name=$4
name2=$5

### Get connected composantes (CC)
gringo ~vwucher/post-doc/programme/asp/compConnexe_noTopBot.lp $con $tre | clasp -n0 | sed 's/cConcept/concept/g' > tmpCC

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

    conceptTreillisAttribut2dot_complet_4lattice.py tmpC2 tmpT2 $dir$name"_"$i

### Get optimize pdf outputs
### 1: all information
	unflatten -f -l 2 $dir$name"_"$i"_allInfo.dot" | dot -Gsize=10,5 -Gratio=fill -Tpdf -o $dir$name2"_"$i"_allInfo.pdf"
### 2: print only specific elements of a concept
	unflatten -f -l 2 $dir$name"_"$i"_onlySpeObjAtt.dot" | dot -Gsize=10,5 -Gratio=fill -Tpdf -o $dir$name2"_"$i"_onlySpeObjAtt.pdf"
### 3: print only specific elements of a concept and set up a limit on the number of printed elements
	unflatten -f -l 2 $dir$name"_"$i"_onlySpeObjAttLimitedPrint.dot" | dot -Gsize=10,5 -Gratio=fill -Tpdf -o $dir$name2"_"$i"_onlySpeObjAttLimitedPrint.pdf"
### 4: set up a limit on the number of printed elements
	unflatten -f -l 2 $dir$name"_"$i"_limitedPrint.dot" | dot -Gsize=10,5 -Gratio=fill -Tpdf -o $dir$name2"_"$i"_limitedPrint.pdf"

done

### Delete tmp file
rm -f tmp1 tmp2 tmpC tmpT tmpC2 tmpT2 tmpListe tmpCC tmpX
