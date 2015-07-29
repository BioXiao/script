#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parsing_brute_score_lourd.py fichier_entree fichier_sortie

import sys
import classe_miranda

# Vérification des arguments
if len( sys.argv ) != 3:
    print "Erreur : pas le bon nombre d'argument\nUsage : parsing_brute_score_lourd.py fichier_entree fichier_sortie"
    sys.exit()

nomEntree   = sys.argv[ 1 ]
nomSortie   = sys.argv[ 2 ]

donnee = classe_miranda.fichierMiranda(nomEntree)

donnee.ecrireScoreLourdMin2C(nomSortie)
