#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : arnm_colocalisation.py entree sortie

import sys
import re

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : arnm_colocalisation.py entree sortie distance"
    sys.exit()

fileIn  = sys.argv[1]
fileOut = sys.argv[2]
dist    = int(sys.argv[3])

file  = open(fileIn, 'r')
lines = file.readlines()
file.close()

gene = []
out  = []

for line in lines:
    elem  = line.split("\t")
    scaf  = elem[0]
    start = int(elem[3])
    end   = int(elem[4])
    name  = elem[8].split(";")[0].split("=")[1]
    gene.append([name,scaf,start,end])


for i in range(0,len(gene)):
    gene1 = gene[i]
    for j in range(i,len(gene)):
        gene2 = gene[j]
        if gene1[0]==gene2[0]:
            res = 'att(\"'+gene1[0]+'\",coloc-'+gene2[0]+'\").'
            out.append(res)
        elif gene1[1] == gene2[1] and ( (abs(gene1[2]-gene2[3])<=dist) or (abs(gene1[3]-gene2[2])<=dist) ):
            res = 'att(\"'+gene1[0]+'\",coloc-'+gene2[0]+'\").'
            out.append(res)
            res = 'att(\"'+gene2[0]+'\",coloc-'+gene1[0]+'\").'
            out.append(res)
            #print 'att(\"'+gene1[0]+'\",coloc-'+gene2[0]+'\").'

file = open(fileOut, 'w')
for ind in out:
    file.write(ind+"\n")
file.close()
