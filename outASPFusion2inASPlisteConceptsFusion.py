#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : outASPFusion2inASPlisteConceptsFusion.py entree sortie

import sys
import re

# Arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : outASPFusion2inASPlisteConceptsFusion.py entree sortie"
    sys.exit()

fileIn  = sys.argv[1]
fileOut = sys.argv[2]

file  = open(fileIn, 'r')
lines = file.readlines()
file.close()

tabOut = []
nbrConcept = 0

for indLine in range(0,len(lines)):
    line = lines[indLine]
    # Search microRNA, mRNA, attMi or attArn
    tmp = re.search("app", line)
    # If there is one
    if tmp:
        concept    = line.split(" ")
        #nbrConcept = (indLine-2)/2
        #nbrConcept = str(nbrConcept)
        nbrConcept = int(nbrConcept)+1
        nbrConcept = str(nbrConcept)
        for ind in concept:
            tmp = re.search("appMi", ind)
            if tmp:
                name = ind.split("\"")[1]
                name = str(name)
                res = 'concept('+nbrConcept+',micro,\"'+name+'\").'
                tabOut.append(res)
            else:
                tmp = re.search("appArn", ind)
                if tmp:
                    name = ind.split("\"")[1]
                    name = str(name)
                    res = 'concept('+nbrConcept+',arnm,\"'+name+'\").'
                    tabOut.append(res)
                else:
                    tmp = re.search("appAttMi", ind)
                    if tmp:
                        name = ind.split("\"")[1]
                        name = str(name)
                        res = 'concept('+nbrConcept+',attMicro,\"'+name+'\").'
                        tabOut.append(res)
                    else:
                        name = ind.split("\"")[1]
                        name = str(name)
                        res = 'concept('+nbrConcept+',attArnm,\"'+name+'\").'
                        tabOut.append(res)
            

file = open(fileOut, 'w')
for ind in tabOut:
    file.write(ind+"\n")
file.close()
