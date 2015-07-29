#!/bin/bash

# format a ucsc like gtf file to ensembl like (without chr, ...)
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
    cat /dev/stdin | awk '$1!~/^#/ && $1!~/^track/{		# rm comment on other lines
	chr=$1; 						# put $1 (chr) in chr variable
	gsub (/chr/,"",chr); 					# sub chr prefix from UCSC
	gsub (/M/, "MT", chr); 					# modify mitochondrial format
	if ($0 ~/^chrUn/){gsub (/Un_/, "", chr); chr=chr".1"};  # sub Un_ for chr unknown and add .1 in suffix like in Ensembl format
	$1=chr; print $0}' | gtf2gtf_cleanall.sh


else
	# Check file
	if [ ! -r "$1" ];then

	    echo "# Ooops...">&2
	    echo "# Needs an input gtf file" >&2
	    usage;
	else
	    infile=$1;
	fi

	awk '$1!~/^#/ && $1!~/^track/{				# rm comment on other lines
        chr=$1; 						# put $1 (chr) in chr variable
        gsub (/chr/,"",chr);                                    # sub chr prefix from UCSC
        gsub (/M/, "MT", chr);                                  # modify mitochondrial format
        if ($0 ~/^chrUn/){gsub (/Un_/, "", chr); chr=chr".1"};  # sub Un_ for chr unknown and add .1 in suffix like in Ensembl format
        $1=chr; print $0}'  $infile | gtf2gtf_cleanall.sh

fi
