#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : getSepFileFromListe.py entre sortie

import sys

if len( sys.argv ) != 3:
    print "Usage : getSepFileFastaFromListe.py entre sortie"
    sys.exit()

fichier    = open(sys.argv[1], 'r')
lignes = fichier.readlines()
fichier.close()

nomOut = ""

for i in range(0, len(lignes)):
    tmp = lignes[i][0:7]
    if tmp=="concept":
        if nomOut!="":
            out.close
        nomOut = sys.argv[2]+tmp+"_"+lignes[i][7:-1]+".fasta"
        out = open(nomOut, 'w')
    else:
        tmp = lignes[i].split()
        out.write(">%s\n%s\n" %(tmp[0], tmp[1]))

out.close
