#!/bin/bash
### Usage : mirnaFaToMirnaTs.sh mirnaFasta taxonID name_mirnaTargetScan


if [ $# -ne 3 ]
then
    echo "Usage : mirnaFaToMirnaTs.sh mirnaFasta taxonID name_mirnaTargetScan"
    exit
fi

in=$1
taxonID=$2
outSeed=$(echo $3"_seed.ts")
outMature=$(echo $3"_mature.ts")

# Seed
awk 'BEGIN{ORS=""} { if($0~/>/){split($0,tab,">"); print tab[2] "\t"}; if($0!~/>/){print substr($0,2,7) "\t" "'$taxonID'" "\n"}}' $in > $outSeed
# Mature
awk 'BEGIN{ORS=""} { if($0~/>/){split($0,tab,">"); print tab[2] "\t" "'$taxonID'" "\t" tab[2] "\t"}; if($0!~/>/){print $0 "\n"}}' $in > $outMature
