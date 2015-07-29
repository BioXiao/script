#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parser_bedtools_cluster.py in out

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : parser_bedtools_cluster.py in out"
    sys.exit()

# Init val
fileIn  = sys.argv[1]
fileOut = sys.argv[2]


# Stockage des lignes
file  = open(fileIn, 'r')
lines = file.readlines()
file.close()


clusters={}

for ligne in lines:
    tmp   = ligne.split("\t")
    nom   = tmp[6].split("\n")[0]
    scaff = tmp[0]
    debut = tmp[1]
    fin   = tmp[2]
    brin  = tmp[5]
    if nom not in clusters:
        clusters[nom] = [scaff,debut,fin,brin]
    else:
        clusters[nom][2] = fin
    #elif clusters[nom][1]>debut:
        #clusters[nom][1] = debut
    #elif clusters[nom][2]<fin:
        #clusters[nom][2] = fin


# Écrit la sortie

file = open(fileOut, 'w')

for clu in clusters.keys():
    file.write(clusters[clu][0]+"\t"+clusters[clu][1]+"\t"+clusters[clu][2]+"\t"+clu+"\t0\t"+clusters[clu][3]+"\n")

file.close()

