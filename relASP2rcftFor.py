#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : relASP2rcftFor.py in out name

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : relASP2rcftFor.py in out name"
    sys.exit()

# Init val
fileIn  = sys.argv[1]
fileOut = sys.argv[2]
name    = sys.argv[3]


# Stockage des lignes
file  = open(fileIn, 'r')
lines = file.readlines()
file.close()


dicAll = {}

# Lecture des lignes
for line in lines:
    obj = line.split("\n")[0]
    dicAll[obj] = obj


file = open(fileOut, 'w')

file.write("\n"+"FormalContext "+name+"\n")

# Écrit l'ensemble des attributs
file.write("|\t")
for objI in dicAll.keys():
    file.write("|\t"+objI+"\t")

file.write("|\n")


for objI in dicAll.keys():
    file.write("|\t"+objI+"\t")
    for objI2 in dicAll.keys():
        if objI2 in dicAll[objI]:
            file.write("|\tx\t")
        else:
            file.write("|\t\t")
    file.write("|\n")

file.close()

