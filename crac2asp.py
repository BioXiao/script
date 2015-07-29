#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Usage : crac2asp.py tumorSample healthySample sampleID paralogousFile outFile

import sys
import re

# Argument test
if len( sys.argv ) != 6:
    print "Error: wrong argument number. Usage: crac2asp.py tumorSample healthySample sampleID paralogousFile outFile"
    sys.exit()


tumorFile  = sys.argv[1]
healthFile = sys.argv[2] 
sampleID   = sys.argv[3]
paraFile   = sys.argv[4]
outFile    = sys.argv[5]


# Read paralogous file
file  = open(paraFile, 'r')
lines = file.readlines()
file.close()

para = []
for line in lines[1:]:
    tmp = line.split("\t")
    ids = (tmp[0], tmp[2])
    if ids[0]!='' and ids[1]!='':
        para.append(ids)
    

# Read healthyFile
file  = open(healthFile, 'r')
lines = file.readlines()
file.close()

health = []
for line in lines[1:]:
    tmp = line.split("\t")
    tmp = tmp[0].split("---")
    health.append((tmp[0], tmp[1]))
    

# Read tumorFile
file = open(tumorFile, 'r')
lines = file.readlines()
file.close()

# Write on the fly
out = open(outFile, 'w')
tumor = {}
for line in lines[1:]:
    tmp = line.split("\t")
    ids = (tmp[0].split("---")[0], tmp[0].split("---")[1])
    # Keep fusion only if it is not detect in normal sample
    if ids not in health:
        # Keep fusion only if genes are not paralogous
        if ids not in para:
            name1 = tmp[7]
            name2 = tmp[12]
            # Keep fusion only if it genes don't have the same name (e.g.: X and X(HUMAN))
            if (name1=='' or name2=='') or \
               (re.search("NA",name1) or re.search("NA",name2)) or \
               ((name1!='' and not re.search(name1,name2)) and (name2!='' and not re.search(name2,name1))):

                # Rename genes if they don't have a name
                if name1=='' or re.search("NA", name1):
                    name1 = ids[0]
                if name2=='' or re.search("NA", name2):
                    name2 = ids[1]

                # Print each break point
                for breakPoint in tmp[4].split("),("):
                    bb       = breakPoint.split(")")[0].split("(")[-1]
                    (bb,nbr) = bb.split(" # ")
                    bb1      = bb.split(" / ")[0]
                    bb2      = bb.split(" / ")[1]
                    chr1     = bb1.split(":")[0]
                    (break1,strand1) = bb1.split(":")[1].split(",")
                    chr2     = bb2.split(":")[0]
                    (break2,strand2) = bb2.split(":")[1].split(",")

                    if strand1=="1":
                        strand1 = "+"
                    else:
                        strand1 = "-"
                    if strand2=="1":
                        strand2 = "+"
                    else:
                        strand2 = "-"
                        
                    # template fusion('crac',
                    #                sampleID
                    #                (ids1, ids2),
                    #                (name1, name2),
                    #                (chr1, break1, strand1),
                    #                (chr2, break2, strand2),
                    #                (read pairs, unique reads),
                    #                ('', '', '', '', ''))
                    out.write( 'fusion("crac", "%s", ("%s","%s"), ("%s","%s"), ("%s",%s,"%s"), ("%s",%s,"%s"), (%s,%s), ("","","","","")).\n'
                               %(sampleID,
                                 ids[0], ids[1],
                                 name1.upper(), name2.upper(),
                                 chr1, break1, strand1,
                                 chr2, break2, strand2,
                                 nbr.split(",")[1], nbr.split(",")[0]) )

out.close()
