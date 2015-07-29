#!/bin/bash

# script that returns monoexonic tx from a gtf file
# April 2015
# tderrien@univ-rennes1.fr
#############################################################################################################

# USAGE

usage() {
    echo "#" >&2
    echo -e "# USAGE: `basename $0` <file> or through pipe">&2
    exit 1;
}

if [ -p /dev/stdin ];then

    #from STDIN
    cat /dev/stdin | awk '{nbex[$12]++;line[$12]=$0}END{for (i in nbex){if(nbex[i] == 1){print line[i]}}}' 

else
	# Check file
	if [ ! -r "$1" ];then

	    echo "# Ooops...">&2
	    echo "# Needs an input gtf file" >&2
	    usage;
	else
	    infile=$1;
	fi

	awk '{nbex[$12]++;line[$12]=$0}END{for (i in nbex){if(nbex[i] == 1){print line[i]}}}' $infile



fi
