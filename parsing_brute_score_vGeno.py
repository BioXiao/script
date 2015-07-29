#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : parsing_brute.py type_calcul nom_logiciel fichier_entree(1 ou plusieurs) fichier_sortie
# type_calcul : exp, somme, somme+, moyenne, moyenne+, min, min2, min2+
# nom_logiciel : miranda, pita, targetscan3p, targetscanAU, targetscanUTR, targetscantotal, targetscanv63p, targetscanv6AU, targetscanv6UTR, targetscanv6total
# Possibilité de donner plusieurs fichier d'entrée du même logiciel qui seront fusionner sur la sortie

import sys
import classe_miranda
import classe_pita
import classe_targetscan
import classe_targetscanv6

# Vérification des arguments
if len( sys.argv ) < 5:
    print "Erreur : pas le bon nombre d'argument\nUsage : parsing_brute.py type_calcul nom_logiciel fichier_entree fichier_sortie\ntpye_score : exp, somme, somme+, moyenne, moyenne+, min, min2, min2+\nnom_logiciel : miranda, pita, targetscan3p, targetscanAU, targetscanUTR, targetscantotal, targetscanv63p, targetscanv6AU, targetscanv6UTR, targetscanv6total"
    sys.exit()
if sys.argv[2]!="miranda" and sys.argv[2]!="pita" and sys.argv[2]!="targetscan3p" and sys.argv[2]!="targetscanAU" and sys.argv[2]!="targetscanUTR" and sys.argv[2]!="targetscantotal" and sys.argv[2]!="targetscanv63p" and sys.argv[2]!="targetscanv6AU" and sys.argv[2]!="targetscanv6UTR" and sys.argv[2]!="targetscanv6total":
    print "Erreur : pas le bon nom de logiciel\nnom_logiciel : miranda, pita, targetscan3p, targetscanAU, targetscanUTR, targetscantotal, targetscanv63p, targetscanv6AU, targetscanv6UTR, targetscanv6total"
    sys.exit()
if sys.argv[1]!="exp" and sys.argv[1]!="somme" and sys.argv[1]!="somme+" and sys.argv[1]!="moyenne" and sys.argv[1]!="moyenne+" and sys.argv[1]!="min" and sys.argv[1]!="min2" and sys.argv[1]!="min2+":
    print "Erreur : pas le bon type de score\ntype_calcul : exp, somme, somme+, moyenne, moyenne+, min, min2, min2+"

nomEntree   = sys.argv[ 3 ]
nomSup      = sys.argv[ 4:(len( sys.argv )-1) ]
nomSortie   = sys.argv[ len( sys.argv )-1 ]
type_calcul = sys.argv[ 1 ]

if sys.argv[2] == "miranda":
    donnee = classe_miranda.fichierMiranda(nomEntree)
elif sys.argv[2] == "targetscan3p" or sys.argv[2] == "targetscanAU" or sys.argv[2] == "targetscanUTR" or sys.argv[2] == "targetscantotal":
    donnee = classe_targetscan.fichierTargetScan(nomEntree, sys.argv[2][10:])
elif sys.argv[2] == "targetscanv63p" or sys.argv[2] == "targetscanv6AU" or sys.argv[2] == "targetscanv6UTR" or sys.argv[2] == "targetscanv6total":
    donnee = classe_targetscanv6.fichierTargetScan(nomEntree, sys.argv[2][12:])
elif sys.argv[2] == "pita":
    donnee = classe_pita.fichierPita(nomEntree)

for nom in nomSup:
    donnee.addNomFichier(nom)

donnee.lireFichier()
donnee.ecrireScore(nomSortie, type_calcul)
