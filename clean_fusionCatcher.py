#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Usage : clean_fusionCatcher.py tumorSample paralogousFile outFile

import sys
import re

# Argument test
if len( sys.argv ) != 4:
    print "Error: wrong argument number. Usage: clean_fusionCatcher.py tumorSample paralogousFile outFile"
    sys.exit()


tumorFile = sys.argv[1]
paraFile  = sys.argv[2]
outFile   = sys.argv[3]

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
    
# Read tumor file
file  = open(tumorFile, 'r')
lines = file.readlines()
file.close()


# Write on the fly
out = open(outFile, 'w')
# Write the header
out.write( '%s' %(lines[0]) )
# Check and write the file
for line in lines[1:]:
    # Keep fusion only if it is not detect in normal sample
    if not re.search("matched-normal", line):
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

                out.write( '%s' %(line) )

out.close()
