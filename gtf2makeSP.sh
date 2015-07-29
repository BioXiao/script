#!/bin/bash

#Format a gtf file to a gtf suiteable for makeSP from Sarah i.e inverse transcript_id to gene_id

# USAGE

usage() {
    echo "#" >&2
    echo -e "# USAGE: `basename $0` <file.gtf> \n OR\n    cat <my_file> | `basename $0`">&2
}



infile=$1

##################################

if [ -p /dev/stdin ];then

    #from STDIN
    cat /dev/stdin | awk '{for (i=1;i<=8;i++) printf ("%s\t",$i); print "transcript_id "$12" gene_id "$10}'


elif [ $# -eq  1 ];then

	awk '{for (i=1;i<=8;i++) printf ("%s\t",$i); print "transcript_id "$12" gene_id "$10}' $infile

else
    echo "#Error! no argument  file or file empty !"
    usage;

fi
