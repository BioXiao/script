#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : relASP2RCFT.py in out name source target scaling

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 7:
    print "Erreur : pas le bon nombre d'argument\nUsage : relASP2RCFT.py in out name source target scaling"
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


# Lecture des lignes
for line in lines:
    tmp = line.split("\",\"")
    obj = tmp[0].split("(")[1]+"\""
    att = "\""+tmp[1].split(").")[0]

    #print(tmpObj)
    #print(tmpAtt)

    tmpObj.append(obj)
    tmpAtt.append(att)
    allRel.append([obj,att])


allObj = OrderedDict.fromkeys(tmpObj).keys()
allAtt = OrderedDict.fromkeys(tmpAtt).keys()


attDic = {}
# Création d'un dico pour stocker les indices des attributs
for i in range(0,len(allAtt)):
    attDic[allAtt[i]] = i



# Écrit la sortie
# Écrit les header
file = open(fileOut, 'w')

file.write("\n"+"RelationalContext "+name+"\n")
file.write("source "+source+"\n")
file.write("target "+target+"\n")
file.write("scaling "+scaling+"\n")

# Écrit l'ensemble des attributs
file.write("| ")
for iAtt in allAtt:
    file.write("| "+iAtt+" ")

file.write("|\n")


# Écrit les relations
espace = "| "
taiAtt = (len(allAtt)-1)
for rel in allRel:
    obj  = rel[0]
    att  = rel[1]
    attI = attDic[att]
    outSeq = "| "+obj+" "+(espace*attI)+"| x "+(espace*(taiAtt-attI))+"|\n"
    file.write(outSeq)

file.close()

