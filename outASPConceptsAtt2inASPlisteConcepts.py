#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : outASP2inASPlisteConcepts.py entree sortie

import sys
import re

# Arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : outASPConceptsAtt2inASPlisteConcepts.py entree sortie"
    sys.exit()

fileIn  = sys.argv[1]
fileOut = sys.argv[2]

file  = open(fileIn, 'r')
lines = file.readlines()
file.close()

tabOut = []

for indLine in range(0,len(lines)):
    line = lines[indLine]
    # Search microRNA or mRNA
    tmp = re.search("concept", line)
    # If there is a microRNA or mRNA
    if tmp:
        concept    = line.split(" ")
        nbrConcept = (indLine-2)/2
        nbrConcept = str(nbrConcept)
        for ind in concept:
            name = ind.split("\"")[1]
            name = str(name)
            elem = ind.split("\"")[3]
            elem = str(elem)
            res  = 'concept('+nbrConcept+',\"'+elem+'\",\"'+name+'\").'
            tabOut.append(res)

            #tmp = re.search("mi", ind)
            #if tmp:
                #name = ind.split("\"")[1]
                #name = str(name)
                #res = 'concept('+nbrConcept+',micro,\"'+name+'\").'
                #tabOut.append(res)
            #else:
                #name = ind.split("\"")[1]
                #name = str(name)
                #res = 'concept('+nbrConcept+',arnm,\"'+name+'\").'
                #tabOut.append(res)
                
            

file = open(fileOut, 'w')
for ind in tabOut:
    file.write(ind+"\n")
file.close()
