#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parse_poweredge13_2_bbl.py outPowerEdge13 outFile

import sys
import re
from operator import itemgetter, attrgetter

# Arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : parse_poweredge13_2_bbl.py outPowerEdge13 outFile"
    sys.exit()

fileIN = sys.argv[1]
fileOUT = sys.argv[2]

file  = open(fileIN, 'r')
lines = file.readlines()
file.close()

### setD pour les nodes qui existent et eq pour les équivalence et la création des edges et node pour les noeuds et eqRet comme eq mais dans l'autre sens
setD = {}
setD["micro"] = {}
setD["arnm"] = {}
eq = {}
eq["micro"] = {}
eq["arnm"] = {}
node = []
eqRet = {}
eqRet["micro"] = {}
eqRet["arnm"] = {}

### Lecture
for line in lines:
    # cherche les equivalence
    match = re.search('eqpn\(', line)
    # Si equivalence
    if match:
        tmp = line.split(",")
        to  = str(tmp[0].split("(")[1]) + "_" + str(tmp[1])
        ori = str(tmp[2]) + "_" + str(tmp[3])
        typ = tmp[4].split(")")[0]
        if ori not in eq[typ].keys():
            eq[typ][ori] = []
            eq[typ][ori].append(to)
        else:
            eq[typ][ori].append(to)

        if to not in eqRet[typ].keys():
            eqRet[typ][to] = []
            eqRet[typ][to].append(ori)
        else:
            eqRet[typ][to].append(ori)

    # cherche les power nodes
    match2 = re.search("^pn\(", line)
    # si trouvé
    if match2:
        tmp  = line.split(",")
        num  = str(tmp[0].split("(")[1]) + "_" + str(tmp[1])
        typ  = tmp[2]
        name = tmp[3].split(")")[0].split('"')[1]
        if num not in setD[typ].keys():
            setD[typ][num] = []
            setD[typ][num].append(name)
        else:
            setD[typ][num].append(name)

        if name not in node:
            node.append(name)


### Sortie
file  = open(fileOUT, 'w')

for i in node:
    file.write("NODE\t"+i+"\n")
file.write("SET\tGraph\t0.0"+"\n\n")

for typ in setD.keys():
    for pn in setD[typ].keys():
        for elem in setD[typ][pn]:
            file.write("IN\t"+elem+"\tNode_"+typ+"_"+pn+"\n")
        file.write("SET\tNode_"+typ+"_"+pn+"\t0.0"+"\n\n")

        # si la power node n'est pas dans eq{}
        if pn not in eq.keys():
            if typ == "micro":
                typ2 = "arnm"
            else:
                typ2 = "micro"
            # test la taille de la power node typ
            if len(setD[typ][pn])>1:
                toPrint1 = "Node_"+typ+"_"+pn
            else:
                toPrint1 = setD[typ][pn][0]

            # test si la power node typ2 n'est pas dans eqRet
            if pn not in eqRet[typ2].keys():
                if len(setD[typ2][pn])>1:
                    toPrint2 = "Node_"+typ2+"_"+pn
                else:
                    toPrint2 = setD[typ2][pn][0]

            # test si la power node typ2 n'est pas dans eqRet
            if pn in eqRet[typ2].keys():
                pn2 = eqRet[typ2][pn][0]
                if len(setD[typ2][pn2])>1:
                    toPrint2 = "Node_"+typ2+"_"+pn
                else:
                    toPrint2 = setD[typ2][pn2][0]

            # print l'arête
            file.write("EDGE\t"+toPrint1+"\t"+toPrint2+"\t1.0\n")




for typ in eq.keys():
    if typ == "micro":
        typ2 = "arnm"
    else:
        typ2 = "micro"
    for ori in eq[typ].keys():
        if len(setD[typ][ori])>1:
            toPrint1 = "Node_"+typ+"_"+ori
        else:
            toPrint1 = setD[typ][ori][0]

        ### si cette power node existe pour l'autre type
        if ori in setD[typ2]:
            if len(setD[typ2][ori])>1:
                toPrint2 = "Node_"+typ2+"_"+ori
            else:
                toPrint2 = setD[typ2][ori][0]
            # file.write("EDGE\tNode_"+typ+"_"+ori+"\tNode_"+typ2+"_"+ori+"\t1.0\n")
            file.write("EDGE\t"+toPrint1+"\t"+toPrint2+"\t1.0\n")


        ### boucle sur les equivalence
        for equi in eq[typ][ori]:
        ### si cette power node existe pour l'autre type
            if equi in setD[typ2]:
                if len(setD[typ2][equi])>1:
                    toPrint2 = "Node_"+typ2+"_"+equi
                else:
                    toPrint2 = setD[typ2][equi][0]
                # file.write("EDGE\tNode_"+typ+"_"+ori+"\tNode_"+typ2+"_"+equi+"\t1.0\n")
                file.write("EDGE\t"+toPrint1+"\t"+toPrint2+"\t1.0\n")



            


file.close()



# for i1 in eq.keys():
#     print i1+"\n"
#     for i2 in eq[i1].keys():
#         print i2+"\t"
#         for i3 in eq[i1][i2]:
#             print i3+", "
#         print "\n"

# for i1 in setD.keys():
#     print i1+"\n"
#     for i2 in setD[i1].keys():
#         print i2+"\t"
#         for i3 in setD[i1][i2]:
#             print i3+", "
#         print "\n"

# for i in node:
#     print i
