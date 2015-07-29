#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : analyse_duplication_mirna.py micro cluster sortie

### Permet, à partir du ~/travail/resultat/mirna_21102013/bilan1_nom15012014.csv, de
### resortir l'ensemble des gènes de microARN dupliqués et leurs gènes classe localisation
### avec gènes hôtes si intragéniques

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : analyse_duplication_mirna.py micro cluster sortie"
    sys.exit()

# Init val
#fileIn  = '~/travail/resultat/mirna_21102013/bilan1_nom15012014.csv'
fileIn1 = sys.argv[1]
fileIn2 = sys.argv[2]
fileOut = sys.argv[3]


# Stockage des lignes cluster
file  = open(fileIn2, 'r')
lines = file.readlines()
file.close()


# Initialise l'ensemble des microARN
cluster = {}
for ligne in lines:
    tmp  = ligne.split("\t")
    miSc = tmp[0]
    miBe = tmp[1]
    miEn = tmp[2]
    miId = tmp[3]
    miSt = tmp[5]
    clId = tmp[6].split("\n")[0]
    cluster[miId] = clId


# Stockage des lignes micro
file  = open(fileIn1, 'r')
lines = file.readlines()
file.close()


# Initialise l'ensemble des microARN
dup = {}
for ligne in lines:
    tmp  = ligne.split("\t")
    miId = tmp[1]
    miPr = tmp[2]
    mi5p = tmp[3]
    mi3p = tmp[4]
    miSc = tmp[5]
    miBe = tmp[6]
    miEn = tmp[7]
    miSt = tmp[8]
    miCl = tmp[9]
    miGh = tmp[10]
    tmpL = [miId,
            miPr,
            mi5p,
            mi3p,
            miSc,
            miBe,
            miEn,
            miSt,
            miCl,
            miGh,
            cluster[miId]]
    if miPr not in dup.keys():
        dup[miPr] = [tmpL]
    else:
        dup[miPr].append(tmpL)



# Écrit la sortie
file = open(fileOut, 'w')
for prec in dup.keys():
    if len(dup[prec]) >= 2:
        file.write(prec)
        for w in dup[prec][0]:
            file.write("\t" + w)
        file.write("\n")
        for i in range(1,len(dup[prec])):
            for w in dup[prec][i]:
                file.write("\t" + w)
            file.write("\n")
file.close()

