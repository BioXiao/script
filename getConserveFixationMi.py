#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : getConserveFixationMi.py MiPrediciton GoodAlignDir out

import sys
import os
import re

if len( sys.argv ) != 4:
    print "Usage : getConserveFixationMi.py MiPrediciton GoodAlignFile out"
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
    infos    = [allinfos[2].split("=")[1], int(allinfos[7].split("=")[1]), int(allinfos[8].split("=")[1])]
    #seedBegin = int(allinfos[5].split("=")[1]) # the begin of the seed
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
                # Modification of the test for the infos[1] (begin) to juste have the seed in it
                # Simple idea : only 6 nt from 2->7
                if (inter[0]<=(infos[2]-6)) and (infos[2]<=inter[1]):
                    flag = 1
                    conserve.append(indLine)
        i = i+1


outFile = open(sys.argv[3], 'w')
for cons in conserve:
    outFile.write("%s" %( predLines[cons] ))
outFile.close()
