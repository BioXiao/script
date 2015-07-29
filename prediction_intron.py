#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : prediction_intron.py liste_exon sortie

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : prediction_intron.py liste_exon sortie"
    sys.exit()

# Init val
fileIn  = sys.argv[1]
fileOut = sys.argv[2]


# Stockage des exons
file     = open(fileIn, 'r')
allLines = file.readlines()
file.close()


allTrans  = {}
for line in allLines:
    tmp   = line.split("\t")
    tmp2  = tmp[-1].split(";")
    scaf  = tmp[0]
    meth  = tmp[1]
    typ   = tmp[2]
    start = int(tmp[3])
    end   = int(tmp[4])
    brin  = tmp[6]
    gene  = tmp2[0]
    trans = tmp2[1]
    exon  = tmp2[2]
    other1 = tmp2[3]
    other2 = tmp2[4]

    exonNum = int(exon.split('"')[1])

    if trans not in allTrans:
        allTrans[trans] = {}

    allTrans[trans][exonNum] = [scaf, meth, typ, start, end, ".", brin, ".", gene, trans, exon, other1, other2]



# Calcul les introns
allIntron = {}
for transcrit in allTrans.keys():
    nExons = len(allTrans[transcrit])

    allIntron[transcrit] = {}

    for ex in range(nExons-1):
        exon = ex+1

        start = int(allTrans[transcrit][exon][4])+1
        end   = int(allTrans[transcrit][exon+1][3])-1

        scaf  = allTrans[transcrit][exon][0]
        meth  = allTrans[transcrit][exon][1]
        typ   = allTrans[transcrit][exon][2]
        brin  = allTrans[transcrit][exon][6]
        gene  = allTrans[transcrit][exon][8]
        trans = allTrans[transcrit][exon][9]
        other1 = allTrans[transcrit][exon][11]
        other2 = allTrans[transcrit][exon][12]
        intron = ' intron_number "'+str(exon)+'"'

        allIntron[transcrit][exon] = [scaf, meth, "intron", start, end, ".", brin, ".", gene, trans, intron, other1, other2]




# Écriture de la sortie
file = open(fileOut, 'w')


for transcrit in allTrans.keys():
    nExons = len(allTrans[transcrit])
    toWrite = ""

    for ex in range(nExons-1):
        exon = ex+1
        # exons
        for i in range(8):
            toWrite = toWrite+str(allTrans[transcrit][exon][i])+"\t"
        for i in range(8,13):
            toWrite = toWrite+str(allTrans[transcrit][exon][i])+";"
        toWrite = toWrite+"\n"
        # introns
        for i in range(8):
            toWrite = toWrite+str(allIntron[transcrit][exon][i])+"\t"
        for i in range(8,13):
            toWrite = toWrite+str(allIntron[transcrit][exon][i])+";"
        toWrite = toWrite+"\n"

    # dernier exon
    for i in range(8):
        toWrite = toWrite+str(allTrans[transcrit][nExons][i])+"\t"
    for i in range(8,13):
        toWrite = toWrite+str(allTrans[transcrit][nExons][i])+";"
    toWrite = toWrite+"\n"

    file.write(toWrite)

file.close()

