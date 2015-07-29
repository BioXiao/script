#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : relASP2rcftRel_v2.py in out name source target scaling

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 7:
    print "Erreur : pas le bon nombre d'argument\nUsage : relASP2rcftRel_v2.py in out name source target scaling"
    sys.exit()

# Init val
fileIn  = sys.argv[1]
fileOut = sys.argv[2]
name    = sys.argv[3]
source  = sys.argv[4]
target  = sys.argv[5]
scaling = sys.argv[6]


# Stockage des lignes
file  = open(fileIn, 'r')
lines = file.readlines()
file.close()


tmpObj = []
tmpAtt = []
allRel = []

dicAll = {}


# Lecture des lignes
for line in lines:
    tmp = line.split(",")
    obj = tmp[0].split("(")[1]
    att = tmp[1].split(").")[0]

    if obj not in dicAll:
        dicAll[obj] = []

    dicAll[obj].append(att)

    tmpObj.append(obj)
    tmpAtt.append(att)
    allRel.append([obj,att])


allObj = OrderedDict.fromkeys(tmpObj).keys()
allAtt = OrderedDict.fromkeys(tmpAtt).keys()


file = open(fileOut, 'w')

file.write("\n"+"RelationalContext "+name+"\n")
file.write("source "+source+"\n")
file.write("target "+target+"\n")
file.write("scaling "+scaling+"\n")

# Écrit l'ensemble des attributs
file.write("|\t")
for iAtt in allAtt:
    file.write("|\t"+iAtt+"\t")

file.write("|\n")


for objI in dicAll.keys():
    file.write("|\t"+objI+"\t")
    for attI in allAtt:
        if attI in dicAll[objI]:
            file.write("|\tx\t")
        else:
            file.write("|\t\t")
    file.write("|\n")

file.close()

