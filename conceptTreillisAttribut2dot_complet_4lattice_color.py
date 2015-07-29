#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Usage : conceptTreillisAttribut2dot_complet_4lattice_color.py concept treillis out

import sys
import re

# Argument test
if len( sys.argv ) != 5:
    print "Erreur : pas le bon nombre d'argument\nUsage : conceptTreillisAttribut2dot_complet_4lattice_color.py concept treillis out colorFile"
    sys.exit()


# Recursive function to return specific objects/attributes of nCon
def getSpeEle(nCon, edgeList, dicCon, type):
	### If nCon is top or bot, return directly
	if nCon not in edgeList.keys():
		if type in dicCon[nCon].keys():
			return dicCon[nCon][type]
		else:
			return [[],[]]

	if type not in dicCon[nCon].keys():
		return [[],[]]

	### Get the not specifics elements
	notSpeEle = []
	for next in edgeList[nCon]:
		tmp = getSpeEle(next, edgeList, dicCon, type)
		notSpeEle = notSpeEle + tmp[0] + tmp[1]

	### Get the specifics elements
	speEle = []
	for conEle in dicCon[nCon][type]:
		if conEle not in notSpeEle:
			speEle = speEle + [conEle]

	return [speEle, notSpeEle]


def writeLegend(file,colDic):
	file.write('\tsubgraph cluster_1{\n')
	file.write('\t\t{\n\
\t\trank = same; Legend [shape=none, margin=0, label=<\n\
\t\t\t<TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="4">\n\
\t\t\t\t<TR>\n\
\t\t\t\t\t<TD COLSPAN="2"><FONT POINT-SIZE="28"><B>Legend</B></FONT></TD>\n\
\t\t\t\t</TR>\n')

	for val in sorted(colDic.iterkeys()):
		file.write('\
\t\t\t\t<TR>\n\
\t\t\t\t\t<TD><FONT POINT-SIZE="28"><B>%s</B></FONT></TD>\n\
\t\t\t\t\t<TD BGCOLOR="%s" width="200"></TD>\n\
\t\t\t\t</TR>\n'
%(val, colDic[val]))

	file.write('\
\t\t\t</TABLE>\n\
\t\t>];\n\
\t\t}\n\
\t}')


# Definition of the writing function
def writeDot(fileO, dicConcept, order, limit, conColor, colDic):
	file = open(fileO, 'w')

	file.write("digraph G {\n")
	file.write("\trankdir=TB; style=invis;\n\tsubgraph cluster_0{\n")

	for n in dicConcept.keys():
		file.write("\t\t")
#		file.write(str(n) + ' [shape=record,style=filled,fillcolor=lightblue,label="{Concept ' + str(n) + '|')
#		file.write(str(n) + ' [shape=record,style=filled,fillcolor='+conColor[n]+',label="{Concept ' + str(n) + '|')
		file.write(str(n) + ' [shape=record,style=filled,fillcolor='+conColor[n]+',group='+conColor[n]+',label="{Concept ' + str(n) + '|')

		if "attArnm" in dicConcept[n].keys():
			for attA in dicConcept[n]["attArnm"]:
				attASplit = str(attA).split("_")
				if len(attASplit)==2:
					file.write("« " + attASplit[-1] + " »" + "\\n")
				else:
					file.write("\{ " + attASplit[-1] + " \}" + "\\n")
		file.write("|")

		if "arnm" in dicConcept[n].keys():
			if len(dicConcept[n]["arnm"])<=limit:
				for arn in dicConcept[n]["arnm"]:
					file.write(str(arn) + "\\n")
			else:
				file.write("...\\n") # ...
				file.write(str(len(dicConcept[n]["arnm"])) + "\\n") # nombre d'ARNm
				file.write("...\\n") # ...
		file.write("|")

		if "micro" in dicConcept[n].keys():
			if len(dicConcept[n]["micro"])<=limit:
				for mic in dicConcept[n]["micro"]:
					file.write(str(mic) + "\\n")
			else:
				file.write("...\\n") # ...
				file.write(str(len(dicConcept[n]["micro"])) + "\\n") # nombre de micro
				file.write("...\\n") # ...
		file.write("|")

		if "attMicro" in dicConcept[n].keys():
			for attM in dicConcept[n]["attMicro"]:
				attMSplit = str(attM).split("_")
				if len(attMSplit)==2:
					file.write("« " + attMSplit[-1] + " »" + "\\n")
				else:
					file.write("\{ " + attMSplit[-1] + " \}" + "\\n")
		file.write('}"];\n')

	for e in order:
		file.write("\t\t" + e[0] + " -> " + e[1] + ";\n")

	file.write("\t}\n")
	
	writeLegend(file,colDic)

	file.write("}\n")
	file.close()


# Definition of the association function between concept number and the colorFile
def getColor(fileC, dicConcept):
	file  = open(fileC, 'r')
	lines = file.readlines()
	file.close()

	type = lines[0].strip('\n')

	colDic = {}
	for i in range(1, len(lines)):
		line  = lines[i].strip('\n')
		infos = map(str.strip, line.split('='))
		tmp   = infos[0].split(',')
		tmp.sort()
		value = ','.join(tmp)
		color = infos[1]

		if value in colDic.keys():
			print "Error: multiple colors given for the same value in colorFile.\nExit."
			exit
		if color in colDic.values():
			print "Error: same color given for differents values in colorFile.\nExit."
			exit

		colDic[value] = color

	conColor = {}
	for num in dicConcept.keys():
		# Make a string of all name in dicConcept[num][type] separate by a comma ',' (if several names)
		if type in dicConcept[num].keys():
			tmp = dicConcept[num][type]
			tmp.sort()
			dicRef = ','.join(tmp)
			if dicRef in colDic.keys():
				conColor[num] = colDic[dicRef]
			else:
				# default color
				conColor[num] = "white"
		else:
			# default color
			dicConcept[num]["color"] = "white"
			conColor[num] = "white"

	return (conColor, colDic)


############
### MAIN ###
############
fileC = sys.argv[1]
fileT = sys.argv[2]
fileO = sys.argv[3]
fileL = sys.argv[4]

### Liste des concepts
file  = open(fileC, 'r')
lines = file.readlines()
file.close()

dicConcept = {}
for line in lines:
    tmp  = line.split(",")
    num  = tmp[0].split("(")[1]
    typ  = tmp[1]
    name = tmp[2].split(")")[0].split('"')[1]
    
    if num not in dicConcept.keys():
        dicConcept[num] = {}
    if typ not in dicConcept[num].keys():
        dicConcept[num][typ] = []
    dicConcept[num][typ].append(name)


### Add color to the concepts
(conColor,colDic) = getColor(fileL, dicConcept)


### Liste du treillis
file  = open(fileT, 'r')
lines = file.readlines()
file.close()

### Use three dictionary, order to get the edge tuple, topTobot with the key is the edge's
### in and value the set of edge's out and botTotop the opposite of topTobot
order = []
topTobot = {}
botTotop = {}
for line in lines:
	tmp  = line.split(",")
	inC  = tmp[0].split("(")[1]
	outC = tmp[1].split(")")[0]
	order.append((inC,outC))

	if inC not in topTobot.keys():
		topTobot[inC] = []
	topTobot[inC].append(outC)

	if outC not in botTotop.keys():
		botTotop[outC] = []
	botTotop[outC].append(inC)


### Make a dictionary with only the newly objects or attributes
dicConceptSpeEle = {}

for con in dicConcept.keys():
	for type in dicConcept[con].keys():
		# if concept not in dicConceptSpeEle then create this key
		if con not in dicConceptSpeEle.keys():
			dicConceptSpeEle[con] = {}
			
		if type=="micro" or type=="attArnm":
			# Get specific objects
			dicConceptSpeEle[con][type] = getSpeEle(con, topTobot, dicConcept, type)[0]
		if type=="arnm" or type=="attMicro":
			# Get specific attributs
			dicConceptSpeEle[con][type] = getSpeEle(con, botTotop, dicConcept, type)[0]


### Sortie
### Define three dot outfile
### 1: with all the information
### 2: only with specific objects and attributes
### 3: only with specific objects and attributes and a limitation on the objects/attributes printed
### 4: a limitation on the objects/attributes printed

fileO1 = fileO + "_allInfo.dot"
fileO2 = fileO + "_onlySpeObjAtt.dot"
fileO3 = fileO + "_onlySpeObjAttLimitedPrint.dot"
fileO4 = fileO + "_limitedPrint.dot"

### Write file1
writeDot(fileO1, dicConcept, order, "inf", conColor, colDic)
### Write file2
writeDot(fileO2, dicConceptSpeEle, order, "inf", conColor, colDic)
### Write file3
writeDot(fileO3, dicConceptSpeEle, order, 25, conColor, colDic)
### Write file4
writeDot(fileO4, dicConcept, order, 25, conColor, colDic)
