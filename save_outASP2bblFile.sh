#!/bin/bash
### Usage : outASP2bblFile.sh entree sortie

in=$1
out=$2

sed s/" "/"\n"/g $in > tmp

### NODE
#egrep ^'powerNode' tmp | grep 'micro' | sed s/"powerNode("/"NODE "/ | sed s/"\"".*"\","/""/g| sed s/")"/""/ > $out
#egrep ^'powerNode' tmp | grep 'arn' | sed s/"powerNode("/"NODE "/ | sed s/"\"".*"\","/""/g| sed s/")"/""/ >> $out

egrep ^'powerNode' tmp | sed s/"powerNode("/"NODE "/ | sed s/",".*/""/g | sed s/"\""/""/g > $out


### powerNode
egrep ^'powerNode' tmp | sed s/"powerNode(".*\"","/"NODE "/ | sed s/")"/""/ | sed s/","/""/ | sort -u >> $out


### IN
#egrep ^'powerNode' tmp | sed s/"powerNode("/"IN "/ | sed s/",."*","/" "/ | sed s/"\""/""/g | sed s/")"/""/ >> $out

egrep ^'powerNode' tmp | grep 'micro' | sed s/"powerNode("/"IN "/ | sed s/","/" "/ | sed s/"\"".*"\","/""/g| sed s/")"/""/ | sed s/"\""/""/g | sed s/","/""/ >> $out
egrep ^'powerNode' tmp | grep 'arnm' | sed s/"powerNode("/"IN "/ | sed s/","/" "/ | sed s/"\"".*"\","/""/g| sed s/")"/""/ | sed s/"\""/""/g | sed s/","/""/ >> $out




### EDGE
#egrep ^'powerEdge' tmp | sed s/"powerEdge("/"EDGE "/g | sed s/"node("/""/g | sed s/","/" "/ | sed s/"\""/""/g | sed s/")"/""/g >> $out
#egrep ^'powerEdge' tmp | sed s/"powerEdge("/"EDGE "/g | sed s/"powerNode("/"micro"/ | sed s/"powerNode("/"arnm"/ | sed s/","/" "/ | sed s/"\""/""/g | sed s/")"/""/g >> $out

egrep ^'powerEdge' tmp | sed s/"powerEdge("/"EDGE "/g | sed s/"node("/""/g | sed s/","/" "/ | sed s/"\""/""/g | sed s/")"/""/g | sed s/"powerNode("/"micro"/ | sed s/"powerNode("/"arnm"/ | sed s/","/" "/ | sed s/"\""/""/g | sed s/")"/""/g >> $out

rm -f tmp
