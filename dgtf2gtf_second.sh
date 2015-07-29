#!/bin/bash

# format a double gtf (i.e 2 gtf on same line) to print only the second part
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
    cat /dev/stdin | awk 'NF> 0 && $1!~/^#/ && $1!~/^track/{		#  rm comment, empty or track lines

        for (j=12;j<=NF;j++){if ($j == "gene_id"){field_geneid=j}}
        firstfield =field_geneid-8;
	for (j=firstfield;j<=NF;j++){
		printf ("%s ",$j);
	}
	print "\n"; 
	}' | awk 'NF>0' | ~tderrien/bin/convert/gtf2gtf_cleanall.sh


else
	# Check file
	if [ ! -r "$1" ];then

	    echo "# Ooops...">&2
	    echo "# Needs an input gtf file" >&2
	    usage;
	else
	    infile=$1;
	fi

	 awk 'NF> 0 && $1!~/^#/ && $1!~/^track/{             # rm comment, empty or track lines

        for (j=12;j<=NF;j++){if ($j == "gene_id"){field_geneid=j}}
        firstfield =field_geneid-8;
        for (j=firstfield;j<=NF;j++){
                printf ("%s ",$j);
        }
	print "\n";
        }' $infile  | awk 'NF>0' | ~tderrien/bin/convert/gtf2gtf_cleanall.sh

fi
