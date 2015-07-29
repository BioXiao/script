#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : micro_colocalisation.py entree sortie distance

import sys
import re

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : micro_colocalisation.py entree sortie distance"
    sys.exit()

fileIn  = sys.argv[1]
fileOut = sys.argv[2]
dist    = int(sys.argv[3])

file  = open(fileIn, 'r')
lines = file.readlines()
file.close()

mi  = []
out = []

for line in lines:
    elem  = line.split("\t")
    scaf  = elem[5]
    start = int(elem[6])
    end   = int(elem[7])
    name  = elem[1]
    mi.append([name,scaf,start,end])

for mi1 in mi:
    for mi2 in mi:
        if mi1[1] == mi2[1] and ( (abs(mi1[2]-mi2[3])<=dist) or (abs(mi1[3]-mi2[2])<=dist) ):
            res1 = 'att(\"'+mi1[0]+'_5p\",\"coloc-'+mi2[0]+'_5p\").'
            res2 = 'att(\"'+mi1[0]+'_5p\",\"coloc-'+mi2[0]+'_3p\").'
            res3 = 'att(\"'+mi1[0]+'_3p\",\"coloc-'+mi2[0]+'_5p\").'
            res4 = 'att(\"'+mi1[0]+'_3p\",\"coloc-'+mi2[0]+'_3p\").'
            out.append(res1)
            out.append(res2)
            out.append(res3)
            out.append(res4)
            #print 'att(\"'+mi1[0]+'\",coloc-'+mi2[0]+'\").'

file = open(fileOut, 'w')
for ind in out:
    file.write(ind+"\n")
file.close()
