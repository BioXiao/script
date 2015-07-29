#!/bin/bash

# USAGE

usage() {
    echo "#" >&2
    echo -e "# USAGE: `basename $0` <file.gtf> \n OR\n    cat <my_file> | `basename $0`">&2
}



infile=$1

##################################

if [ -p /dev/stdin ];then

    #from STDIN
    cat /dev/stdin | sort -k1,1 -k4,4n -k5,5n 

elif [ $# -eq  1 ];then

      sort -k1,1 -k4,4n -k5,5n $infile

else
    echo "#Error! no argument  file or file empty !"
    usage;

fi
