#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : getGoodAlignFromAln.py in.aln out.txt

import sys
import re

if len( sys.argv ) != 3:
    print "Usage : getGoodAlignFromAln.py in.aln out.txt"
    sys.exit()

inFile  = open(sys.argv[1], 'r')
lines   = inFile.readlines()
inFile.close()
seqName1 = sys.argv[1].split("/")[-1].split(".")[0]
seqName2 = sys.argv[1].split("/")[-1].split(".")[1]



# Get the indice where the alignment begin
begin = len(lines[2]) - len(lines[2].split(" ")[-1])
resA  = []
res1  = []
res2  = []

# value : the quality of the alignment
align = ""
seq1  = ""
seq2  = ""

# Get the alignment
for indLine in range(4, len(lines), 4):
    # Get only the string of the alignment and not the blank before
    # and the "\n" in the end of the line
    align = align + lines[indLine][begin:-1]

# Check if there is a good alignement
if re.search("\*", align)==None:
    sys.exit()

# Get the first sequence
for indLine in range(2, len(lines), 4):
    # Get only the string of the alignment and not the blank before
    # and the "\n" in the end of the line
    seq1 = seq1 + lines[indLine][begin:-1]

# Get the second sequence
for indLine in range(3, len(lines), 4):
    # Get only the string of the alignment and not the blank before
    # and the "\n" in the end of the line
    seq2 = seq2 + lines[indLine][begin:-1]

# Initialize the flag value to know if the previous char was a "*"
flag = 0
tmpB = 0
tmpE = 0
for indice,value in enumerate(align):
    if flag==0 and value=="*":
        tmpB = indice
        flag = 1
    # If there is a "*" in the last char (len(align)-1) and there was not a "*" before
        if indice==(len(align)-1):
            resA.append([tmpB+1,tmpB+1])
    elif flag==1 and value==" ":
        tmpE = indice-1
        flag = 0
        resA.append([tmpB+1,tmpE+1])
    # If there is a "*" in the last char (len(align)-1) and there was a "*" before
    elif flag==1 and value=="*" and indice==(len(align)-1):
        tmpE = indice
        flag = 0
        resA.append([tmpB+1,tmpE+1])

# Get the real position of the "*" for each sequence
for value in resA:
    beginStar = value[0]
    endStar   = value[1]
    nbrGap1   = len(re.findall("-", seq1[:beginStar]))
    nbrGap2   = len(re.findall("-", seq2[:beginStar]))
    res1.append([beginStar-nbrGap1,endStar-nbrGap1])
    res2.append([beginStar-nbrGap2,endStar-nbrGap2])

# Write output

outFile = open(sys.argv[2], 'w')
# 1
outFile.write("%s\t" %( seqName1 ))
for indice in range(0,len(res1)-1):
    outFile.write("%d-%d," %( res1[indice][0], res1[indice][1] ))
if len(res1)!=0:
    outFile.write("%d-%d\n" %( res1[len(res1)-1][0], res1[len(res1)-1][1] ))
# 2
outFile.write("%s\t" %( seqName2 ))
for indice in range(0,len(res2)-1):
    outFile.write("%d-%d," %( res2[indice][0], res2[indice][1] ))
if len(res2)!=0:
    outFile.write("%d-%d\n" %( res2[len(res2)-1][0], res2[len(res2)-1][1] ))
outFile.close
