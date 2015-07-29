#!/bin/bash

cd ~/travail/resultat/alignement/fichier/aln/
rm -f tmp tmp.dnd
for fichier in $(ls ../entree/)
do
  echo $fichier
  modif=$(echo $fichier | sed -re s/','/'\\:'/g | sed s/'('/'\\('/g | sed s/')'/'\\)'/g)
  cp -f "../entree/"$fichier ./tmp
  t_coffee tmp -output aln >& avc.txt
  sortie=$(echo $fichier | sed -r s/.fa/.aln/)
  mv tmp.aln $sortie
  rm -f tmp tmp.dnd
done
