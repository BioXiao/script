#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : relASP2RCFT.py in out name source target scaling out2 out3

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 9:
    print "Erreur : pas le bon nombre d'argument\nUsage : relASP2RCFT.py in out name source target scaling out2 out3"
    sys.exit()

# Init val
fileIn  = sys.argv[1]
fileOut = sys.argv[2]
name    = sys.argv[3]
source  = sys.argv[4]
target  = sys.argv[5]
scaling = sys.argv[6]
fileOut2 = sys.argv[7]
fileOut3 = sys.argv[8]


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
file.write("|\t")
for iAtt in allAtt:
    file.write("|\t"+iAtt+"\t")

file.write("|\n")


# Écrit les relations
espace = "| "
taiAtt = (len(allAtt)-1)
for rel in allRel:
    obj  = rel[0]
    att  = rel[1]
    attI = attDic[att]
    outSeq = "|\t"+obj+"\t"+(espace*attI)+"|\tx\t"+(espace*(taiAtt-attI))+"|\n"
    file.write(outSeq)

file.close()



# Écrit les att
file = open(fileOut2, 'w')

file.write("\n"+"FormalContext "+target+"\n")
file.write("|\t")
for iAtt in allAtt:
    file.write("|\t"+iAtt+"\t")
file.write("|\n")

espace = "|\t"
taiAtt = (len(allAtt)-1)
for i in range(0,len(allAtt)):
    outSeq = "|\t"+allAtt[i]+"\t"+(espace*i)+"|\tx\t"+(espace*(taiAtt-i))+"|\n"
    file.write(outSeq)

file.close()



# Écrit les obj
file = open(fileOut3, 'w')

file.write("\n"+"FormalContext "+source+"\n")
file.write("|\t")
for iObj in allObj:
    file.write("|\t"+iObj+"\t")
file.write("|\n")

espace = "|\t"
taiObj = (len(allObj)-1)
for i in range(0,len(allObj)):
    outSeq = "|\t"+allObj[i]+"\t"+(espace*i)+"|\tx\t"+(espace*(taiObj-i))+"|\n"
    file.write(outSeq)

file.close()
