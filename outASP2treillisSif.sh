#!/bin/bash
### Usage : outASP2treillisSif.sh entree sortie

grep 'arete' $1 | sed s/"arete("/""/g | sed s/" arete("/\\n/g | sed s/","/" inclue "/g | sed s/") "/\\n/g | sed s/")"/""/g > $2
