#!/bin/bash


# Format a feature file (.gtf, .bed...) in order to be loaded on UCSC track
# skip chromosome Un and format chrMT
# add track
# Jan 2013: Add FPKM in score field

# USAGE

usage() {
	echo "#" >&2
	echo "# USAGE: `basename $0` <infile.bed/gtf...>">&2
	echo "# optionals :">&2
        echo "# 	<track_name> (default infile)">&2
        echo "# 	<description> (default infile)">&2
        echo "# ">&2
        echo "# Example :">&2
        echo "# `basename $0` <infile.gtf> ensemblgene ensembl_gtf_v69 ">&2
	
}



infile=$1

if [ ! -s "$infile" ];then

	echo "# Error: needs an input file not EMPTY! ">&2
	usage;
	exit 65;
fi
##################################

# Arguments track_name
if [ -n "$2" ];then
	track_name=$2
else
	track_name=$1
fi

# Arguments desc
if [ -n "$3" ];then
        desc=$3
else
        desc=$1
fi
###################

# - 1 Test if cufflink file
cuff_file=`head -10 $infile | awk 'BEGIN{var=0}{if ($1 !~ /^#/){ for (i=9;i<=NF;i++){if ($i == "FPKM"){var="yes"}}}}END{print var}'`

cuff_file="";

if [ "$cuff_file" == "yes" ];then
	
	echo "Detected CUFLINK files, so will use FPKM as score...">&2

	# 1.1 get the max FPKM value in whole file
	max_fpkm=`gawk 'BEGIN{max=0}{
	for (i=9;i<=NF;i++){
			if ($i == "FPKM"){
 				fpkm=$(i+1);
 				gsub(/\"|;/,"", fpkm) 
	 		}
	}
	if (fpkm>max){max=fpkm}
	}END{print max}' $infile`

	# 2.2 Format the file accordingly i.e normalized FPKM replace score field
	# Note : in UCSC the max score is 1000
	gawk -v track_name=$track_name -v desc=$desc -v max_fpkm=$max_fpkm  'BEGIN{print "track name="track_name" description=\""desc"\" useScore=1"}{
 	# initialize var to check whether we have to display score (i.e is this cufflink data)
 	is_present=0;

	# UCSC tracks required chr in $1
	if ($1 !~/^chr/){
 		$1="chr"$1;
 	}
	# get fpkm
 	for (i=9;i<=NF;i++){
 		if ($i == "FPKM"){
 			fpkm=$(i+1);
			gsub(/\"|;/,"", fpkm) 
			# log 10 transformation and +1 for FPKM between [0-1]
			norm_fpkm = (log(1+fpkm)/log(10))*1000/(log(max_fpkm)/log(10));
# 			norm_fpkm = (log(1+fpkm)/log(10))
 			is_present=1;
 		}
 	}
	# normalize
	if (is_present){ $6=norm_fpkm;}
	
	# print output
	for (i=1;i<9;i++) {printf("%s\t",$i) }; for (i=9;i<=NF;i++) {printf("%s ",$i)}; print "";
 
 }'  $infile  |\
egrep -v "chrJH|chrAAEX"  | sed -e 's/chrMT/chrM/g'

# - 2 if no cufflink file
else 

	echo "Will not use FPKM as score...">&2

	gawk -v track_name=$track_name -v desc=$desc   'BEGIN{print "track name="track_name" description=\""desc"\" useScore=1"}{
	# UCSC tracks required chr in $1
 	if ($1 !~/^chr/){
 		$1="chr"$1;
 	}
 	# print output
	for (i=1;i<9;i++) {printf("%s\t",$i) }; for (i=9;i<=NF;i++) {printf("%s ",$i)}; print "" 

}'  $infile  |\
egrep -v "chrJH|chrAAEX"  | sed -e 's/chrMT/chrM/g'


fi
