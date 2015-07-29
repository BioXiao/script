#!/bin/bash
### Usage : outASP2listeConcepts.sh entree sortie

awk '$0~/Answer/ || $0~/micro/ || $0~/ACYPI/' $1 | sed s/"Answer:"/"concept"/g | sed s/" appmi("/\\n/g | sed s/" apparn("/\\n/g | sed s/")"/""/g | sed s/"appmi("/""/g | sed s/" "$/""/g > $2
