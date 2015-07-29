#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Usage : fusioncatcher2aspHeatlh.py healthySample sampleID paralogousFile outFile

import sys
import re

# Argument test
if len( sys.argv ) != 5:
    print "Error: wrong argument number. Usage: fusioncatcher2aspHealth.py healthySample sampleID paralogousFile outFile"
    sys.exit()


healthFile = sys.argv[1]
sampleID   = sys.argv[2]
paraFile   = sys.argv[3]
outFile    = sys.argv[4]

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
    
# Read health file
file  = open(healthFile, 'r')
lines = file.readlines()
file.close()

# Write on the fly
out = open(outFile, 'w')
for line in lines[1:]:
    # Keep fusion only if it is not detect in normal sample
    tmp = line.split("\t")
    ids = (tmp[10], tmp[11])
    # Keep fusion only if genes are not paralogous
    if ids not in para:
        name1 = tmp[0]
        name2 = tmp[1]
        # Keep fusion only if it genes don't have the same name (e.g.: X and X(HUMAN))
        if (name1=='' or name2=='') or \
           (re.search("NA",name1) or re.search("NA",name2)) or \
           ((name1!='' and not re.search(name1,name2)) and (name2!='' and not re.search(name2,name1))):
            
            # Rename genes if they don't have a name
            if name1=='' or re.search("NA", name1):
                name1 = ids[0]
            if name2=='' or re.search("NA", name2):
                name2 = ids[1]

            # Check for short distance and readthrough flags
            short   = ""
            through = ""
            if re.search("short_distance",tmp[2]):
                short = "short_distance"
            if re.search("readthrough",tmp[2]):
                through = "readthrough"
                   
            # template fusionHealth('fusioncatcher',
            #                       sampleID,
            #                       (ids1, ids2),
            #                       (name1, name2),
            #                       (chr1, break1, strand1),
            #                       (chr2, break2, strand2),
            #                       (read pairs, unique reads),
            #                       (common reads, short, readthrough, where, method))
            out.write( 'fusionHealth("fusioncatcher", "%s", ("%s","%s"), ("%s","%s"), ("%s",%s,"%s"), ("%s",%s,"%s"), (%s,%s), ("%s","%s","%s","%s","%s")).\n'
                       %(sampleID,
                         ids[0], ids[1],
                         name1.upper(), name2.upper(),
                         tmp[8].split(':')[0], tmp[8].split(':')[1], tmp[8].split(':')[2],
                         tmp[9].split(':')[0], tmp[9].split(':')[1], tmp[9].split(':')[2],
                         tmp[4], tmp[5],
                         tmp[3], short, through, tmp[15], tmp[7]) )

out.close()
