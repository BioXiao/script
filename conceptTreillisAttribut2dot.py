#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : conceptTreillisAttribut2dot.py concept treillis out

import sys
import re

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : conceptTreillisAttribut2dot.py concept treillis out"
    sys.exit()

fileC = sys.argv[1]
fileT = sys.argv[2]
fileO = sys.argv[3]

### Liste des concepts
file  = open(fileC, 'r')
lines = file.readlines()
file.close()

dicConcept = {}
for line in lines:
    tmp  = line.split(",")
    num  = tmp[0].split("(")[1]
    typ  = tmp[1]
    name = tmp[2].split(")")[0].split('"')[1]
    
    if num not in dicConcept.keys():
        dicConcept[num] = {}
    if typ not in dicConcept[num].keys():
        dicConcept[num][typ] = []
    dicConcept[num][typ].append(name)


### Liste du treillis
file  = open(fileT, 'r')
lines = file.readlines()
file.close()

order = []
for line in lines:
    tmp  = line.split(",")
    inC  = tmp[0].split("(")[1]
    outC = tmp[1].split(")")[0]
    order.append((inC,outC))

### Sortie
file = open(fileO, 'w')

file.write("digraph G {\n")
file.write("\trankdir=TB;\n")

for n in dicConcept.keys():
    file.write("\t")
    file.write(str(n) + ' [shape=record,style=filled,fillcolor=lightblue,label="{Concept ' + str(n) + '|')

    if "attArnm" in dicConcept[n].keys():
        for attA in dicConcept[n]["attArnm"]:
            attASplit = str(attA).split("_")
            if len(attASplit)==2:
                file.write("« " + attASplit[-1] + " »" + "\\n")
            else:
                file.write("\{ " + attASplit[-1] + " \}" + "\\n")
    file.write("|")

    if "arnm" in dicConcept[n].keys():
        if len(dicConcept[n]["arnm"])<=25:
            for arn in dicConcept[n]["arnm"]:
                file.write(str(arn) + "\\n")
        else:
            #file.write(str(dicConcept[n]["arnm"][0]) + "\\n") # le 1er ARNm
            #file.write(str(dicConcept[n]["arnm"][-1]) + "\\n") # le dernier ARNm
            file.write("...\\n") # ...
            file.write(str(len(dicConcept[n]["arnm"])) + "\\n") # nombre d'ARNm
            file.write("...\\n") # ...
    file.write("|")

    if "micro" in dicConcept[n].keys():
        for mic in dicConcept[n]["micro"]:
            file.write(str(mic) + "\\n")
    file.write("|")

    if "attMicro" in dicConcept[n].keys():
        for attM in dicConcept[n]["attMicro"]:
            attMSplit = str(attM).split("_")
            if len(attMSplit)==2:
                file.write("« " + attMSplit[-1] + " »" + "\\n")
            else:
                file.write("\{ " + attMSplit[-1] + " \}" + "\\n")
    file.write('}"];\n')

for e in order:
    file.write("\t" + e[0] + " -> " + e[1] + ";\n")

file.write("}\n")
file.close()
