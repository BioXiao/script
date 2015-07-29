#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parse_mirSelf.py vs_self out_noGrp outGrpDirectory

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : parse_mirSelf.py vs_self out_noGrp outGrpDirectory"
    sys.exit()

# Init val
fileSelf = sys.argv[1]
outFile  = sys.argv[2]
outDir   = sys.argv[3]

# Lecture
file     = open(fileSelf, 'r')
allLines = file.readlines()
file.close()

nogroupe = []
groupe = []
for line in allLines:
    tmp = line.split("\n")[0].split("\t")
    ide = tmp[0]
    listePrec = tmp[1].split(" ")
    score = int(tmp[2])
    listeName = tmp[3:]

    allListe = listePrec+listeName
 
    if score == 0:
        nogroupe.append(ide)
    else:
        flag = -1
        for iGrp in range(0,len(groupe)):
            for i in range(0,len(allListe)):
                if allListe[i] in groupe[iGrp]:
                    flag = iGrp
        if flag != -1:
            groupe[flag] = groupe[flag] + allListe
        else:
            groupe.append(allListe)


# Sorties
fileOut = open(outFile, 'w')

for i in nogroupe:
    fileOut.write(i+"\n")

fileOut.close()


for num in range(0,len(groupe)):
    fileGrp = open(outDir+"_"+str(num)+".txt", 'w')
    res = list(set(groupe[num]))
    for j in res:
        fileGrp.write(j+"\n")
    fileGrp.close()
