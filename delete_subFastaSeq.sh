#!/bin/bash

### Usage: delete_subFastaSeq.sh <% FOR DELETION [0-100]> <1:START; 2:END> <INPUT / - FOR STDIN>
### INPUT: either in FASTA or ONE LINE FASTA.
### OUTPUT: in stdout in the input format but all the sequence in only one line.
### If the length of the remove sequence is <1, remove nothing.

if [ $# -ne 3 -a $# -ne 2 ]
then
    echo -e "Usage: delete_subFastaSeq.sh <% FOR DELETION [0-100]> <1:START; 2:END> <INPUT / - FOR STDIN>\nINPUT: either in FASTA or ONE LINE FASTA. Use '-' to input the STDIN.\nOUTPUT: in stdout in the input format but all the sequence in only one line.\nIf the length of the remove sequence is <1, remove nothing."
    exit
fi

perc=$1
ext=$2
cat $3 > /tmp/delete_$$.tmp ### The STDIN can be read only one time... Put it in a tmp file
input=/tmp/delete_$$.tmp

field=$(awk -F"\t" '{print NF}' $input | sort -u)


if [ $ext != "1" -a $ext != "2" ]
then
    echo -e "Error: the BOUND argument "$ext" is not valid.\nQuit."
    rm -f $input
    exit
fi

if [ $field == "2" ]
then
    ### Already one line FASTA
    if [ $ext == "1" ]
    then
	#### If from start
	awk '{len=length($2); size=(len*'$perc'/100); res=substr($2, size+1, len-size); if(size>=1){print $1 "\t" res}else{print $1 "\t" $2}}' $input
    else
	### If from end
	awk '{len=length($2); size=(len*'$perc'/100); res=substr($2, 1,      len-size); if(size>=1){print $1 "\t" res}else{print $1 "\t" $2}}' $input
    fi

elif [ $field == "1" ]
then
     ### First make a one line FASTA
    ### If from start
    if [ $ext == "1" ]
    then
	awk 'BEGIN{ORS=""} {if($0~/>/&& NR==1) {print $1 "\t"}; if($0~/>/ && NR!=1) {print "\n" $1 "\t"} if($0!~/>/) {print $0} } END{print "\n"}' $input | \
	    awk '{len=length($2); size=(len*'$perc'/100); res=substr($2, size+1, len-size); if(size>=1){print $1 "\n" res}else{print $1 "\n" $2}}'
    else
	### If from end
	awk 'BEGIN{ORS=""} {if($0~/>/&& NR==1) {print $1 "\t"}; if($0~/>/ && NR!=1) {print "\n" $1 "\t"} if($0!~/>/) {print $0} } END{print "\n"}' $input | \
	    awk '{len=length($2); size=(len*'$perc'/100); res=substr($2, 1,      len-size); if(size>=1){print $1 "\n" res}else{print $1 "\n" $2}}'
    fi

else
    echo -e "Error: the INPUT format is neither FASTA or ONE LINE FASTA.\nQuit."
    rm -f $input
    exit
fi

rm -f $input
