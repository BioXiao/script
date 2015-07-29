#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parsing_id_seq_homo.py entree fichier

import sys
import re

if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : parsing_id_seq_homo.py entree fichier"
    sys.exit()

entree = sys.argv[1]
sortie = sys.argv[2]

fichierE = open(entree, 'r')
Tlignes  = fichierE.readlines()
fichierE.close()

out = []

for ligne in Tlignes:
    tmp = re.search(">", ligne)
    if tmp:
        out.append(ligne.split("\n")[0]+" seq=")
    else:
        out[-1] = out[-1]+ligne.split("\n")[0]


fichierS = open(sortie, 'w')
for ligne in out:
    fichierS.write( "%s\n" %(ligne) )

fichierS.close()
