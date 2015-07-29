#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parse_mirbase.py entree sortie espece
# ex : parse_mirbase.py mirbase.fa out.ex '>dme'

import sys

if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : parse_mirbase.py entree sortie espece"
    sys.exit()

entree = sys.argv[1]
sortie = sys.argv[2]
comp   = sys.argv[3]

fichierE = open(entree, 'r')
lignes   = fichierE.readlines()
fichierE.close()

fichierS = open(sortie, 'w')

for i in range(0, len(lignes), 2):
    if lignes[i][0:4]==comp:
        fichierS.write( "%s%s" %( lignes[i], lignes[i+1] ) )

fichierS.close()
