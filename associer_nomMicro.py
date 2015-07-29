#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage : associer_nomMicro.py bilan_file vs_miRBase vs_self

import sys
import re
from collections import OrderedDict

# Arguments
if len( sys.argv ) != 4:
    print "Erreur : pas le bon nombre d'argument\nUsage : associer_nomMicro.py bilan_file vs_miRBase vs_self"
    sys.exit()

# Init val
fileBilan   = sys.argv[1]
fileMirbase = sys.argv[2]
fileSelf    = sys.argv[3]

# Fonction pour écrire les noms des micro
def ecrireNom(nom, liste, score):
    if len(liste) > 1:
        cpt = 1
        for i in listeIdt:
            print "score", score, ":", i, nom+"-"+str(cpt)
            cpt = cpt+1
    else:        
        print "score", score, ":", listeIdt[0], nom




# Lecture des séquences et des identifiants miRDeep2
file     = open(fileBilan, 'r')
allLines = file.readlines()
file.close()

# Initialise un dico avec comme clé le tuple des 5p,3p
# microB[identifiant] :
# 0 : séquence précurseur
# 1 : séquence 5p
# 2 : séquence 3p
# 3 : scaf
# 4 : début
# 5 : fin
# 6 : nom en début de fichier
microB = {}
microSeq = {}

for line in allLines:
    tmp = line.split("\t")
    ide = tmp[1]
    seq = tmp[2]
    p5  = tmp[3]
    p3  = tmp[4]
    sca = tmp[5]
    sta = int(tmp[6])
    end = int(tmp[7])
    name = tmp[0]
    microB[ide] = [seq,p5,p3,sca,sta,end,name]
    microSeq[(p5,p3)] = [name]


# Lecture des résultats de la comparaison avec miRBase
file     = open(fileMirbase, 'r')
allLines = file.readlines()
file.close()

# Rappelle
# 0 => no  hit
# 1 => precursor are identical
# 2 => mature and star are identical
# 2 => 5p and 3p are expressed and are identical 
# 3 => mature is identical and star is almost identical 
# 3 => mature is identical and star is not expressed or unknown
# 4 => 5p and 3p are both almost identical
# 4 => mature and star are both almost identical 
# 5 => mature is identical but star is different


# microSeq[(5p,3p)]
# 0 : nom 'anglais'
# 1 : score
# 2 : liste prec attachées au tuple (5p,3p)
# 3 : liste des noms obtenus par la comparaison avec mirBase

for line in allLines:
    tmp = line.split("\n")[0].split("\t")
    ide = tmp[0]
    listePrec = tmp[1].split(" ")
    score = int(tmp[2])
    tupleSeq = (microB[ide][1],microB[ide][2])

    if len(microSeq[tupleSeq]) == 1:
        microSeq[tupleSeq].append(score)
        microSeq[tupleSeq].append(listePrec)
        if score!=0:
            listeName = tmp[3:]
            microSeq[tupleSeq].append(listeName)
        else:
            microSeq[tupleSeq].append([])
    else:
        if score == 0:
            microSeq[tupleSeq][2].append(listePrec)            
        elif score < microSeq[tupleSeq][1]:
            microSeq[tupleSeq][1] = score
            listeName = tmp[3:]
            microSeq[tupleSeq][3] = listeName
        elif score == microSeq[tupleSeq][1]:
            for name in listeName:
                if name not in microSeq[tupleSeq][3]:
                    microSeq[tupleSeq][3].append(name)


# microSeq[(5p,3p)]
# 0 : nom 'anglais'
# 1 : score
# 2 : liste prec attachées au tuple (5p,3p)
# 3 : liste des noms obtenus par la comparaison avec mirBase
# 4 : liste des numéros uniques sans [az] ou -[09] obtenus par la comparaison avec mirBase et nom "anglais"

for tup in microSeq.keys():
    # Si score de 0 et pas de nom "anglais"
    if score == 0 and ("api" not in microSeq[tup][0]):
        microSeq[tup].append("pas de nom")

    # Si score de 0 et nom






for i in microSeq.keys():
    print i, ":", microSeq[i]

sys.exit()


# micro[identifiant] :
# 0 : séquence précurseur
# 1 : séquence 5p
# 2 : séquence 3p
# 3 : scaf
# 4 : début
# 5 : fin
# 6 : nom en début de fichier
# 7 : tableau résultats miRBase. 0 : listes des précurseurs identiques ; 1 : score ; 2 : liste des noms si ils existent
micro = {}

for line in allLines:
    tmp = line.split("\t")
    ide = tmp[0]
    listePrec = tmp[1]
    score = int(tmp[2])
    tupleSeq = (microB[ide][1],microB[ide][2])

    if ide not in micro.keys():
        micro[ide] = microB[ide]

    if score == 0:
        micro[ide].append([listePrec, score])
        microSeq[tupleSeq].append([listePrec, score])
    else:
        listeName = tmp[3:]
        if len(micro[ide]) != 8:
            micro[ide].append([listePrec, score, listeName])
            microSeq[tupleSeq].append([listePrec, score, listeName])
        elif score < micro[ide][7][1]:
            micro[ide][7] = [listePrec, score, listeName]
            microSeq[tupleSeq][7] = [listePrec, score, listeName]

print microSeq




### Récupère les noms des micro dans un dico avec les ids et dans un dico avec le tuple (5p,3p)
### nomMir :
### 0 : score
### 1 : liste de noms
### 2 : nom anglais
nomMir = {}
nomMirSeq = {}
for ide in micro.keys():
    score    = micro[ide][7][1]
    listeIdt = micro[ide][7][0].split(" ")

    if "api" in micro[ide][6]:
        nomAng = "api"+micro[ide][6].split("api")[1]
    else:
        nomAng = ""

    if score == 0:
        if nomAng != "":
            for i in listeIdt:
                nomMir[i] = [score, ["pas de nom"], [nomAng]]
        else:
            for i in listeIdt:
                nomMir[i] = [score, ["pas de nom"], []]

    if score != 0:
        listeNom = micro[ide][7][2]
        listeNum = []
        flag = 0
        for iNom in listeNom:
            if "api" in iNom:
                flag = 1
                tmp = "-".join(iNom.split("-")[1:])
                tmp = tmp.split("\n")[0]
                tmp = "api-"+tmp
                if tmp not in listeNum:
                    listeNum.append(tmp)
        if flag==0:
            for iNom in listeNom:
                tmp = "-".join(iNom.split("-")[1:])
                tmp = tmp.split("\n")[0]
                tmp = "api-"+tmp
                if tmp not in listeNum:
                    listeNum.append(tmp)
        
        if nomAng != "":
            tmp = "-".join(nomAng.split("-")[1:])
            tmp = tmp.split("\n")[0]
            tmp = "api-"+tmp
            for i in listeIdt:
                nomMir[i] = [score, listeNum, [tmp]]
        else:
            for i in listeIdt:
                nomMir[i] = [score, listeNum, []]



### Gestion des familles '-[09]' et '[az]'
file     = open(fileSelf, 'r')
allLines = file.readlines()
file.close()

# 0 => pas de famille
# 1 => -[09]
# 2 => -[09]
# 2 => -[09]
# 3 => [az]
# 3 => [az]
# 4 => [az]
# 4 => [az]
# 5 => [az]












#for i in nomMir.keys():
#    if len(nomMir[i][1])>1:
#        print i, ":", nomMir[i]


sys.exit()

# 1ère gestion d'une sortie

for ide in micro.keys():
    # Si un score de 0, alors regarde les noms des anglais
    if micro[ide][7][1] == 0:
        listeIdt = micro[ide][7][0].split(" ")
        if "api" in micro[ide][6]:
            nom = "api"+micro[ide][6].split("api")[1]
            ecrireNom(nom, listeIdt, 0)
        else:
            ecrireNom("pas de nom", listeIdt, 0)

    # Si un score de 1 alors nom miRBase + nom anglais si il existe
    if micro[ide][7][1] == 1:
        listeIdt = micro[ide][7][0].split(" ")
        listeName = micro[ide][7][2]
        flag = 0
        for nom in listeName:
            if "api" in nom:
                flag = 1
                cpt = 1
                if "api" in micro[ide][6] and micro[ide][6]!=(nom.split("\n")[0]):
                    for i in listeIdt:
                        nom2 = "api"+micro[ide][6].split("api")[1]
                        cpt = 1
                        print "score 1 :", i, nom.split("\n")[0]+"-"+str(cpt), "| nom \"anglais\" :", nom2+"-"+str(cpt)
                        cpt = cpt+1
                else:
                    for i in listeIdt:
                        cpt = 1
                        print "score 1 :", i, nom.split("\n")[0]+"-"+str(cpt)
                        cpt = cpt+1

        if flag==0:
            print "yeah"
            nom = "api-mir-"+listeName[0].split("-")[2]
            cpt = 1
            for i in listeIdt:
                print "score 1 :", i, nom.split("\n")[0]
                cpt = cpt+1




#for ide in micro.keys():
#    print micro[ide]



sys.exit()
