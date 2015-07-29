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
nom4 = ""
aln4 = ""

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

    elif j==4:
        info = lignes[i].split(" ")
        if nom4=="":
            nom4 = info[0]
        aln4 = aln4 + info[-1].split("\n")[0]

    elif j==6:
        j=0

    j = j+1


sortie = open(sys.argv[2], 'w')
sortie.write(">%s\n%s\n>%s\n%s\n>%s\n%s\n>%s\n%s\n" %( nom1, aln1, nom2, aln2, nom3, aln3, nom4, aln4 ))
sortie.close



'''
for ligne in toutlignes[1:]:
    #tmp = re.search("([a-Z]) | ([0-9])", ligne)
    tmp = re.search("\w", ligne)
    # Si on trouve un hit
    if tmp:
        info = ligne.split(" ")
        #print info
        if i == 1:
            print "tutu"
            nom2 = info[0]
            #aln2.append(info[-1])
            aln2 = aln2 + info[-1].split("\n")[0]
            i = i+1
            print nom2, aln2
        elif i == 0:
            print "tata"
            nom1 = info[0]
            #aln1.append(info[-1])
            aln1 = aln1 + info[-1].split("\n")[0]
            i = i+1
            print nom1, aln1, info
        #if info[0] == nom1 and i!=0 and i!=1 and i!=2:
        elif info[0] == nom1 and i==2:
            #aln1.append(info[-1])
            aln1 = aln1 + info[-1].split("\n")[0]
            #i = i+1
        #elif info[0] == nom2 and i!=0 and i!=1 and i!=2:
        elif info[0] == nom2 and i==2:
            #aln2.append(info[-1])
            aln2 = aln2 + info[-1].split("\n")[0]
            #i = i+1
        print i

sortie = open(sys.argv[2], 'w')
sortie.write(">%s\n%s\n>%s\n%s\n" %( nom1, aln1, nom2, aln2 ))
sortie.close
'''
