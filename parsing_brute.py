#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parsing_brute.py nom_logiciel fichier_entree(1 ou plusieurs) fichier_sortie
# nom_logiciel : miranda, pita, targetscan3p, targetscanAU, targetscanUTR, targetscantotal, targetscanv63p, targetscanv6AU, targetscanv6UTR, targetscanv6total
# Possibilité de donner plusieurs fichier d'entrée du même logiciel qui seront fusionner sur la sortie

import sys
import classe_miranda
import classe_pita
import classe_targetscan
import classe_targetscanv6

# Vérification des arguments
if len( sys.argv ) < 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : parsing_brute.py nom_logiciel fichier_entree fichier_sortie\nnom_logiciel : miranda, pita, targetscan3p, targetscanAU, targetscanUTR, targetscantotal, targetscanv63p, targetscanv6AU, targetscanv6UTR, targetscanv6total"
    sys.exit()
if sys.argv[1]!="miranda" and sys.argv[1]!="pita" and sys.argv[1]!="targetscan3p" and sys.argv[1]!="targetscanAU" and sys.argv[1]!="targetscanUTR" and sys.argv[1]!="targetscantotal" and sys.argv[1]!="targetscanv63p" and sys.argv[1]!="targetscanv6AU" and sys.argv[1]!="targetscanv6UTR" and sys.argv[1]!="targetscanv6total":
    print "Erreur : pas le bon nom de logiciel\nnom_logiciel : miranda, pita, targetscan3p, targetscanAU, targetscanUTR, targetscantotal, targetscanv63p, targetscanv6AU, targetscanv6UTR, targetscanv6total"
    sys.exit()

nomEntree = sys.argv[2]
nomSup = sys.argv[ 3:(len( sys.argv )-1) ]
nomSortie = sys.argv[ len( sys.argv )-1 ]

if sys.argv[1] == "miranda":
    donnee = classe_miranda.fichierMiranda(nomEntree)
elif sys.argv[1] == "targetscan3p" or sys.argv[1] == "targetscanAU" or sys.argv[1] == "targetscanUTR" or sys.argv[1] == "targetscantotal":
    donnee = classe_targetscan.fichierTargetScan(nomEntree, sys.argv[1][10:])
elif sys.argv[1] == "targetscanv63p" or sys.argv[1] == "targetscanv6AU" or sys.argv[1] == "targetscanv6UTR" or sys.argv[1] == "targetscanv6total":
    donnee = classe_targetscanv6.fichierTargetScan(nomEntree, sys.argv[1][12:])
elif sys.argv[1] == "pita":
    donnee = classe_pita.fichierPita(nomEntree)

for nom in nomSup:
    donnee.addNomFichier(nom)

donnee.lireFichier()
donnee.ecrireSimple(nomSortie)
