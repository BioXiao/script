#!/bin/bash
### Usage : getConceptAndrelated2dot.sh listeNumConcept concept treillis dot

if [ $# -ne 4 ]
then
    echo "Usage : getConceptAndrelated2dot.sh listeNumConcept concept treillis dot"
    exit
fi

liste=$1
con=$2
tre=$3
dot=$4

### Get tmp file fot concept of interests
sed 's/\(.*\)/concept(\1)./' $liste > tmpListe

### Get tmp file for search in concept and treillis file
sed 's/\(.*\)/(\1,/' $liste > tmp1
sed 's/\(.*\)/,\1)/' $liste > tmp2

### Get concepts
grep --file=tmp1 $con > tmpC

### Get relations
echo -e "arete2(N1,N2) :- arete(N1,N2), concept(N1;N2)." >> tmpListe
gringo $tre tmpListe | grep "arete2" | sed 's/arete2/arete/' > tmpT

sort -u tmpC > tmpC2
sort -u tmpT > tmpT2

conceptTreillisAttribut2dot.py tmpC2 tmpT2 $dot

rm -f tmp1 tmp2 tmpC tmpT tmpC2 tmpT2 tmpListe
