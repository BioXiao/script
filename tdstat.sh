#!/bin/bash

# script that compute statistics cound mean ... on a column of a file file
# tderrien@univ-rennes1.fr
#############################################################################################################

# USAGE

usage() {
    echo "#" >&2
    echo -e "# USAGE: `basename $0` <file_col> [int_column ] or through pipe">&2
    exit 1;
}

# colum integer option

# 2nd argument; output directory
re='^[0-9]+$'

if [ -p /dev/stdin ];then
	if [ ! -z "$1" ];then
	        if [[ $1 =~ $re ]] ;then
                	colid=$1;
        	else
            		echo "# Ooopsbis...">&2
           		echo "# The 2nd argument '$1' is not a valid integer" >&2
			usage;
	        fi
	else
		colid=1
	fi

    #from STDIN
    cat /dev/stdin |  awk -v num=$colid '{print $(num)}' | sort -n | awk 'BEGIN {
    c = 0;
    sum = 0;
  }
  $1 ~ /^[0-9]*(\.[0-9]*)?$/ {
    a[c++] = $1;
    sum += $1;
  }
  END {
    ave = sum / c;
    if( (c % 2) == 1 ) {
      median = a[ int(c/2) ];
    } else {
      median = ( a[c/2] + a[c/2-1] ) / 2;
    }
    OFS="\t";
    printf("Sum: %.3f\nCount: %d\nMean: %.3f\nMedian: %.3f\nMin: %.3f\nMax: %.3f\n",sum, c, ave, median, a[0], a[c-1]);
  }
'| column -t


else
	# Check file
	if [ ! -r "$1" ];then

	    echo "# Ooops...">&2
	    echo "# Needs an input  file" >&2
	    usage;
	else
	    infile=$1;
	fi

	# check column int
        if [ ! -z "$2" ];then
                if [[ $2 =~ $re ]] ;then
                        colid=$2;
                else
                        echo "# Ooopsbis...">&2
                        echo "# The 2nd argument '$2' is not a valid integer" >&2
                        usage;
                fi
	else 
		colid=1
        fi


	cat $infile | awk -v num=$colid '{print $(num)}' | sort -n | awk 'BEGIN {
    c = 0;
    sum = 0;
  }
  $1 ~ /^[0-9]*(\.[0-9]*)?$/ {
    a[c++] = $1;
    sum += $1;
  }
  END {
    ave = sum / c;
    if( (c % 2) == 1 ) {
      median = a[ int(c/2) ];
    } else {
      median = ( a[c/2] + a[c/2-1] ) / 2;
    }
    OFS="\t";
    printf("Sum: %.3f\nCount: %d\nMean: %.3f\nMedian: %.3f\nMin: %.3f\nMax: %.3f\n",sum, c, ave, median, a[0], a[c-1]);
  }
'| column -t

fi
