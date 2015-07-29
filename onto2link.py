#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : onto2link.py in.obo out.lp

import sys
import xml.etree.ElementTree as ET

if len( sys.argv ) != 3:
    print "Usage : onto2link.py in.obo out.lp"
    sys.exit()

### Parse le XML
tree = ET.parse(sys.argv[1])
root = tree.getroot()

### Recupere et ecrit les relations entre GO
OUT = open(sys.argv[2], 'w')
for termm in root.findall('term'):
    #flag = termm.find('is_obsolete').text
    flag = termm.find('is_obsolete')
    #if flag != 1:
    #print flag
    if flag is None:
        idd   = termm.find('id').text
        space = termm.find('namespace').text
        name  = termm.find('name').text
        OUT.write("name(\""+idd+"\",\""+name+"\").\n")
        OUT.write("namespace(\""+idd+"\",\""+space+"\").\n")
        for isa in termm.findall('is_a'):
            OUT.write("isA(\""+idd+"\",\""+isa.text+"\").\n")
OUT.close()
