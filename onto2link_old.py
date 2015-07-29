#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : onto2link.py in.obo out.lp

import sys

if len( sys.argv ) != 3:
    print "Usage : onto2link.py in.obo out.lp"
    sys.exit()


fichier = open(sys.argv[1], 'r')
lignes  = fichier.readlines()
fichier.close()


links = []
tmp   = ["","",""]
for ligne in lignes:
    if "id:" in ligne:
        tmp[0] = ligne.split(" ")[1]
        tmp[2] = ""
    if "obsolete:" in ligne:
        tmp[2] = "obsolete"
    if "is_a:" in ligne:
        tmp2 = ligne.split(" ")[1]
        #if "regulates" not in tmp2:
        tmp[1] = tmp2
        links.append(tmp)
            #print("tmp : ", tmp)
            #print("links", links[-1])
    #if "obsolete" in tmp:
        #print("tmp obsolete:", tmp)
    if "regulates" in tmp:
        print("tmp regulates:", tmp)

outFile = open(sys.argv[2], 'w')
for towrite in links:
    print(towrite)
    if "obsolete" not in towrite:
        outFile.write("isA(%s,%s).\n" %(towrite[0], towrite[1]))

outFile.close
