#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : micro_in_cluster_positions.py cluster micro out

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : micro_in_cluster_positions.py cluster micro out"
    sys.exit()

# Init val
fileIn1  = sys.argv[1]
fileIn2  = sys.argv[2]
fileOut  = sys.argv[3]


# Stockage des lignes
file     = open(fileIn1, 'r')
linesClu = file.readlines()
file.close()

file     = open(fileIn2, 'r')
linesMic = file.readlines()
file.close()



### Regarde les positions
mic2pos = {}
for ligne in linesMic:
    tmp = ligne.split("\t")
    mic = tmp[1]
    pos = tmp[9]
    mic2pos[mic] = pos


### Regarde les clusters
clu2mic={}
for ligne in linesClu:
    tmp = ligne.split("\t")
    mic = tmp[3]
    clu = tmp[6].split("\n")[0]
    if clu not in clu2mic:
        clu2mic[clu] = [0,0]
        clu2mic[clu][0] = []
        clu2mic[clu][0].append(mic)
        clu2mic[clu][1] = []
        clu2mic[clu][1].append(mic2pos[mic])
    else:
        clu2mic[clu][0].append(mic)
        clu2mic[clu][1].append(mic2pos[mic])
        

# Écrit la sortie

file = open(fileOut, 'w')

for clu in clu2mic.keys():
    file.write(clu + "\t")
    for mic in clu2mic[clu][0]:
        file.write(mic + ",")
    file.write("\t")
    for pos in clu2mic[clu][1]:
        file.write(pos + ",")
    file.write("\n")
        
file.close()

