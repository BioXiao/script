#!/bin/bash

#Format a gtf file to an .bed6

# USAGE

usage() {
    echo "#" >&2
    echo -e "# USAGE: `basename $0` <file.gtf> \n OR\n    cat <my_file> | `basename $0`">&2
}



infile=$1

##################################

if [ -p /dev/stdin ];then

    #from STDIN
    cat /dev/stdin | awk '$1!~/^#/{OFS="\t"; print $1,$4-1,$5,$12,$6, $7}' | sed -e 's/[\"|;]//g'


elif [ $# -eq  1 ];then

     awk '$1!~/^#/{OFS="\t"; print $1,$4-1,$5,$12,$6, $7}' $infile | sed -e 's/[\"|;]//g'

else
    echo "#Error! no argument  file or file empty !"
    usage;

fi
