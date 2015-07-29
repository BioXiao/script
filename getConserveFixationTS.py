#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : getConserveFixationTS.py TsPrediciton GoodAlignDir out

import sys
import os
import re

if len( sys.argv ) != 4:
    print "Usage : getConserveFixationTS.py TsPrediciton GoodAlignFile out"
    sys.exit()

inFile   = open(sys.argv[1], 'r')
predLines = inFile.readlines()
inFile.close()
inFile   = open(sys.argv[2], 'r')
alnLines = inFile.readlines()
inFile.close()

conserve = []

for indLine in range(0,len(predLines)):
    if indLine%1000==0:
        print indLine

    allinfos = predLines[indLine].split("\t")
    # 0 : mRNA, 1 : begin, 2 : end
    infos    = [allinfos[0], int(allinfos[4]), int(allinfos[5])]
    flag     = 0
    i        = 0
    while i<len(alnLines) and flag==0:
        alnInfos = alnLines[i]
        # If the aln is with the gene id
        if re.search(infos[0], alnInfos)!=None:
            aln = alnInfos.split("\n")[0]
            aln = aln.split("\t")[1].split(",")
            # Try to find an aln corresponding to the fixation site
            for grp in aln:
                inter = grp.split("-")
                inter[0] = int(inter[0])
                inter[1] = int(inter[1])
                if (inter[0]<=infos[1]) and (infos[2]<=inter[1]):
                    flag = 1
                    conserve.append(indLine)
        i = i+1


outFile = open(sys.argv[3], 'w')
for cons in conserve:
    outFile.write("%s" %( predLines[cons] ))
outFile.close()
