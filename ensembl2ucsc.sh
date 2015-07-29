#!/bin/bash

# script that format a ensembl .gtf file to UCSC format
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
    cat /dev/stdin | awk '$1 !~/^#/{
	gsub (/MT/, "chrM", $1); 					# modify mitochondrial format
	gsub (/^X/, "chrX", $1); 					# modify X format
	if ($1 ~/^[1-9]/){$1="chr"$1}					# automsome
	else if ($1 ~ /^[A-Z]/ && $1 !~/^chr/) {$1="chrUn_"$1; gsub (/.1$/,"", $1)}	# Unknown chr
	 print $0}' | gtf2gtf_cleanall.sh 


else
	# Check file
	if [ ! -r "$1" ];then

	    echo "# Ooops...">&2
	    echo "# Needs an input gtf file" >&2
	    usage;
	else
	    infile=$1;
	fi

	awk '{
        gsub (/MT/, "chrM", $1);                                        # modify mitochondrial format
        gsub (/^X/, "chrX", $1);                                        # modify X format
        if ($1 ~/^[1-9]/){$1="chr"$1}                                   # automsome
        else if ($1 ~ /^[A-Z]/ && $1 !~/^chr/) {$1="chrUn_"$1; gsub (/.1$/,"", $1) }                    # Unknown chr
        print $0}' $infile | gtf2gtf_cleanall.sh 

fi
