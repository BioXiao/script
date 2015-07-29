#!/bin/bash

tmp1='/tmp/'$(echo $1 | awk -F'/' '{print $NF}')'.tmp'
tmp2='/tmp/'$(echo $2 | awk -F'/' '{print $NF}')'.tmp'

sort -k 1,b1 $1 | tee tmp1 > /dev/null
sort -k 1,b1 $2 | tee tmp2 > /dev/null
join tmp1 tmp2 | tee $3 > /dev/null

rm -f tmp1 tmp2