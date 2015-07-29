#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : getProbaListe.py listeCluster listeMicro listeMicroInCluster dossierBaseProba probaSeuil out

import sys
import re
import glob
import os
import re
import operator
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 7:
    print "Erreur : pas le bon nombre d'argument\nUsage : getProbaListe.py listeCluster listeMicro listeMicroInCluster dossierBaseProba probaSeuil out"
    sys.exit()

# Init val
fileCluster        = sys.argv[1]
fileMicro          = sys.argv[2]
fileMicroInCluster = sys.argv[3]
dossierBaseProba   = sys.argv[4]
#fileFasta          = sys.argv[5]
#fileOut            = sys.argv[6]
probaSeuil         = float(sys.argv[5])
fileOut            = sys.argv[6]


# Lecture des clusters
fichier = open(fileCluster, 'r')
lignes  = fichier.readlines()
fichier.close()

dicCluster = {}
for ligne in lignes:
    tmp   = ligne.split("\t")
    tmp2  = tmp[3].split("_")
    nom   = tmp2[0]+"_"+tmp2[1]
    scaff = tmp[0]
    # début et fin -/+10nt
    debut = tmp[1]
    fin   = tmp[2]
    brin  = tmp[5].split("\n")[0]
    dicCluster[nom] = [scaff,debut,fin,brin]


# Lecture des microARN appartenant aux clusters
fichier = open(fileMicroInCluster, 'r')
lignes  = fichier.readlines()
fichier.close()

dicApp = {}
for ligne in lignes:
    tmp = ligne.split("\t")
    clu = tmp[6].split("\n")[0]
    mic = tmp[3]
    if clu in dicCluster:
        dicApp[mic] = clu

# Lecture des proba
listeBaseProba = []
for fichier in os.listdir(dossierBaseProba):
    if re.match(".*_dp.ps", fichier):
        listeBaseProba.append(fichier)

dicBP = {}
for ficNom in listeBaseProba:
    fichier = open(dossierBaseProba+ficNom, 'r')
    lignes  = fichier.readlines()
    tmp = (dossierBaseProba+ficNom).split("/")[-1].split("_")[0:2]
    nomBP = tmp[0]+"_"+tmp[1]
    fichier.close()
    #dicBP[nomBP] = {}

    for ligne in lignes:
        if re.match("[0-9]* [0-9]* [0-9.]* ubox$",ligne):
            tmp = ligne.split(" ")
            num1 = tmp[0]
            num2 = tmp[1]
            numId = num1+" "+num2
            proba = float(tmp[2])**2
            #dicBP[nomBP][numID] = proba
            # Dans le dico, met le nom des micro présent dans le cluster
            for mic in dicApp.keys():
                if nomBP==dicApp[mic]:
                    #print(mic, nomBP, numId, proba)
                    if mic not in dicBP.keys():
                        dicBP[mic] = {}
                    dicBP[mic][numId] = proba
                    #dicBP[mic][(int(num1),int(num2))] = proba

#print("BP", len(dicBP), dicBP)
#print("BP", len(dicBP["GL350737_40392"]), dicBP["GL350737_40392"])
#print("BP", len(dicBP[mic][numId]))

# Lecture des séquences des clusters format fasta 
#fichier = open(fileFasta, 'r')
#lignes  = fichier.readlines()
#fichier.close()

#dicFasta = {}
#tmpC = ""
#for ligne in lignes:
#    if re.match("^>",ligne):
#        tmp = ligne.split(">")[1].split("_")
#        tmpC = tmp[0]+"_"+tmp[1]
#        dicFasta[tmpC] = []
#    else:
#        tmp = ligne.split("\n")[0]
#        dicFasta[tmpC].append(tmp)


# Lecture des séquences des microARN matures dans le cluster pour un pre-micro
# et leurs positions dans la séquence fasta
fichier = open(fileMicro, 'r')
lignes  = fichier.readlines()
fichier.close()

dicMicro = {}
for ligne in lignes:
    tmp   = ligne.split("\t")
    nom   = tmp[1]
    scaff = tmp[5]
    mat   = tmp[2]
    p5    = tmp[3]
    p3    = tmp[4]
    debut = tmp[6]
    fin   = tmp[7]
    if nom in dicApp:
        clu = dicApp[nom]
        # récupère l'indice de début et fin dans le fichier fasta pour la correspondance avec RNAfold
        p5d = (int(debut)-int(dicCluster[clu][1]))-1
        p5f = (int(debut)-int(dicCluster[clu][1]))+len(p5)
        p3f = (int(debut)-int(dicCluster[clu][1]))+len(mat)
        p3d = (int(p3f)-len(p3))-1
        dicMicro[nom] = [scaff,mat,p5,p3,debut,fin,range(p5d,p5f),range(p3d,p3f)]


# Récupère les proba de fixation entre 5p et 3p
# dicBP[mic][num1][num2] = proba
# dicMicro[nom] = [scaff,mat,p5,p4,debut,fin,range(p5d,p5f),range(p3d,p3f)]

pair = {}
for mic in dicMicro.keys():
    rp5 = dicMicro[mic][6]
    rp3 = dicMicro[mic][7]
    #print(rp5)
    if mic in dicBP.keys():
        for allId in dicBP[mic].keys():
            #print(allId,rp5)
            ind1 = int(allId.split(" ")[0])
            ind2 = int(allId.split(" ")[1])
            if (ind1 in rp5) and (ind2 in rp3):
                if mic not in pair.keys():
                    pair[mic] = {}
                #print(ind1,rp5,ind2,rp3)
                pair[mic][allId] = [ind1,ind2,dicBP[mic][allId]]

            #if ind1 in rp5:
                #print("toto")
                #for ind2 in dicBP[mic][ind1].keys():
                    #if ind2 in rp3:
                        #pair[mic] = [ind1,ind2,dicBP[mic][ind1][ind2]]




# Écrit la sortie

file = open(fileOut, 'w')

file.write("clusterID" +"\t"+ "microID" +"\t"+ "nbrPair" +"\t"+ "(i,j,proba)" +"\n")
for mic in pair.keys():
    #print(mic)
    clu = dicApp[mic]
    #text = str(mic) +"\t"+ str(clu)
    #file.write(text)
    # Tri le dico du micro pour une sortie plus lisible
    tmpDic = pair[mic].keys()
    tmpDic.sort()
    nbrPair = 0
    text    = ""
    for allId in tmpDic:
        id1  = pair[mic][allId][0]
        id2  = pair[mic][allId][1]
        pro  = pair[mic][allId][2]
        if pro>=probaSeuil:
            nbrPair = nbrPair+1
            text = text +"\t"+ str(id1) +","+ str(id2) +","+ str(pro)
            #file.write(text)
    #file.write("\n")
    file.write(str(clu) +"\t"+ str(mic) +"\t"+ str(nbrPair) + text +"\n")

file.close()

