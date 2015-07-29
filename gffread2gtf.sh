#!/bin/bash

# script converting a .gtffread file into correct .gtf
# Example of gtf produced after gffread (note that intron chains matched so I used here this command line
# gffread --cluster-only -O -o- -T CDKN2B.gtf 
#	11	BROADv1	exon	41258865	41261478	.	-	.	transcript_id "CDKN2B"; gene_id "CDKN2B"; locus "RLOC_00000001";
#	11	BROADv1	exon	41264176	41264304	.	-	.	transcript_id "CDKN2B"; gene_id "CDKN2B"; locus "RLOC_00000001";
#	11	BROADv1	exon	41264353	41264379	.	-	.	transcript_id "CDKN2B"; gene_id "CDKN2B"; locus "RLOC_00000001";
#	11	BROADv1	exon	41261218	41261478	.	-	.	transcript_id "CDKN2B_2"; gene_id "CDKN2B_2"; locus "RLOC_00000001";
#	11	BROADv1	exon	41264176	41264304	.	-	.	transcript_id "CDKN2B_2"; gene_id "CDKN2B_2"; locus "RLOC_00000001";
#	11	BROADv1	exon	41264353	41264379	.	-	.	transcript_id "CDKN2B_2"; gene_id "CDKN2B_2"; locus "RLOC_00000001";
#############################################################################################################

# USAGE

usage() {
    echo "#" >&2
    echo -e "# USAGE: `basename $0` <file> or through pipe">&2
    exit 1;
}

if [ -p /dev/stdin ];then

    #from STDIN
    cat /dev/stdin | awk '{for (i=1;i<9;i++){printf ("%s\t",$i)}; print $11,$NF,$9,$10}'


else
	# Check file
	if [ ! -r "$1" ];then

	    echo "# Ooops...">&2
	    echo "# Needs an input gtf file" >&2
	    usage;
	else
	    infile=$1;
	fi
	awk '{for (i=1;i<9;i++){printf ("%s\t",$i)}; print $11,$NF,$9,$10}' $infile
fi
