#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parsing_t_coffee.py entre sortie

import sys
import re

if len( sys.argv ) != 3:
    print "Usage : parsing_t_coffee.py entre sortie"
    sys.exit()

fichier    = open(sys.argv[1], 'r')
lignes = fichier.readlines()
fichier.close()

nom1 = ""
aln1 = ""
nom2 = ""
aln2 = ""
nom3 = ""
aln3 = ""

j = 1


for i in range(2, len(lignes)) :
    if j==1:
        info = lignes[i].split(" ")
        if nom1=="":
            nom1 = info[0]
        aln1 = aln1 + info[-1].split("\n")[0]

    elif j==2:
        info = lignes[i].split(" ")
        if nom2=="":
            nom2 = info[0]
        aln2 = aln2 + info[-1].split("\n")[0]

    elif j==3:
        info = lignes[i].split(" ")
        if nom3=="":
            nom3 = info[0]
        aln3 = aln3 + info[-1].split("\n")[0]

    elif j==5:
        j=0

    j = j+1


sortie = open(sys.argv[2], 'w')
sortie.write(">%s\n%s\n>%s\n%s\n>%s\n%s\n" %( nom1, aln1, nom2, aln2, nom3, aln3 ))
sortie.close
