#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parsing_brute_score_lourd.py type fichier_entree fichier_sortie

import sys
import classe_miranda

# Vérification des arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : parsing_brute_score_lourd.py type fichier_entree fichier_sortie"
    sys.exit()

type      = sys.argv[ 1 ]
nomEntree = sys.argv[ 2 ]
nomSortie = sys.argv[ 3 ]

donnee = classe_miranda.fichierMiranda(nomEntree)

if type=="min":
    donnee.ecrireScoreLourdmin(nomSortie)
if type=="min2" or type=="min2p":
    donnee.ecrireScoreLourdmin2(nomSortie)
if type=="min2c":
	donnee.ecrireScoreLourdMin2C(nomSortie)
