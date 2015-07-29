#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : divFichier.py entre nombre dossier_sortie

import sys

if len( sys.argv ) != 5:
    print "Usage : divFichier.py entre nombre nom_sortie dossier_sortie"
    sys.exit()

fichier = open(sys.argv[1], 'r')
lignes  = fichier.readlines()
fichier.close()
nbrF    = int(sys.argv[2])
tailleF = len(lignes)/nbrF
ext = tailleF+(len(lignes)%nbrF)

tmp = sys.argv[4]
if tmp[-1] != "/":
    tmpOut = tmp+"/"+sys.argv[3]
else:
    tmpOut = tmp+sys.argv[3]

### Pour les 1er fichiers
for i in range(1, nbrF):
    debut = 1+((i-1)*tailleF)
    fin   = tailleF+((i-1)*tailleF)
    nomOut = tmpOut+"_"+str(i)+".fa"
    out = open(nomOut, 'w')
    for j in range((debut-1), fin):
        out.write(lignes[j])
    out.close

### Pour le dernier fichier
nomOut = tmpOut+"_"+str(nbrF)+".fa"
out = open(nomOut, 'w')
for k in range((j+1), len(lignes)):
    out.write(lignes[k])
out.close()
