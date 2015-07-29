#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : getOrderPowerGraph.py concept powergraph

import sys
import re
from operator import itemgetter, attrgetter

# Arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : getOrderPowerGraph.py concept powergraph"
    sys.exit()

fileC = sys.argv[1]
fileP = sys.argv[2]


def nbr(listeNoeud, dicoNoeud):
    if len(listeNoeud) == 1:
        return(1)
    somme = 0
    for i in listeNoeud:
        val = nbr(dicoNoeud[i], dicoNoeud)
        somme = somme + val
    return(somme)

def getListe(listeNoeud, dicoNoeud):
    if len(listeNoeud) == 1:
        return(listeNoeud)
    res = []
    for i in listeNoeud:
        res.append(getListe(dicoNoeud[i], dicoNoeud))
    res2 = [item for sublist in res for item in sublist]
    return(res2)


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


### Liste des power nodes, etc
file  = open(fileP, 'r')
lines = file.readlines()
file.close()
node = []
pn   = {}
pnS  = {}
pe   = {}

for line in lines:
    tmp  = line.split("\n")[0].split("\t")
    if str(tmp[0]) == "NODE":
        pn[str(tmp[1])] = [str(tmp[1])]
        node.append(str(tmp[1]))
    if str(tmp[0]) == "SET":
        pn[str(tmp[1])] = []
    if tmp[0] == "IN":
        pn[str(tmp[2])].append(str(tmp[1]))
    if tmp[0] == "EDGE":
        i = len(pe)+1
        pe[i] = [str(tmp[1]), str(tmp[2])]


somme = 0
for e in pe.keys():
    mi  = nbr(pn[pe[e][0]], pn)
    arn = nbr(pn[pe[e][1]], pn)
    surface = mi * arn
    pe[e].append(surface)
    somme = somme + surface

#print(somme)
#print(len(pe))
#print(pe)


#test = sorted(pe.iteritems(), key=lambda kvt: kvt[1][2]) # marche
#print(test)

nbrC = len(dicConcept)
print(nbrC)
for key, value in sorted(pe.iteritems(), key=lambda kvt: kvt[1][2], reverse=True):
    #print key, ':', value
    miPE  = sorted(getListe(pn[pe[key][0]], pn), key=str.lower)
    arnPE = sorted(getListe(pn[pe[key][1]], pn), key=str.lower)

    flag = 0
    while i<nbrC or flag==0:
        print i
        print "i" + str(i)
        print dicConcept[i]
        miC  = sorted(dicConcept[i]["micro"], key=str.lower)
        arnC = sorted(dicConcept[i]["arnm"], key=str.lower)
        if (miC == miPE) and (arnC == arnPE):
            flag = 1
            print "concept : " + i
        if (miC == arnPE) and (arnC == miPE):
            flag = 1
            print "concept : " + i
        i = i+1

exit()

