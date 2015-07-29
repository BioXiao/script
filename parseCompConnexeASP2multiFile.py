#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parseCompConnexeASP2multiFile.py in outDir outName

import sys
import re

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : parseCompConnexeASP2multiFile.py in outDir outName"
    sys.exit()

fileI  = sys.argv[1]
outDir = sys.argv[2]
name   = sys.argv[3]

### Liste des CC
file  = open(fileI, 'r')
lines = file.readlines()
file.close()

cpt = 1
for line in lines:
    # Search concept in line
    tmp = re.search("concept", line)
    # If concept, then model
    if tmp:
       mod = line.split("\n")[0].split(" ") 
       outFile = outDir+name+"_"+str(cpt)+".lp"
       file = open(outFile, 'w')
       for concept in mod:
           file.write(str(concept)+".\n")
       file.close()
       cpt = cpt+1
