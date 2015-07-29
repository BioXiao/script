#!/usr/bin/env Rscript

### Usage : getSeqLogoFromFasta.r entree sortie

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=2)
  {
    cat("Erreur :\nUsage : getSeqLogoFromFasta.r entree sortie\n")
    quit()
  }

library(seqLogo, quietly=TRUE)

entree <- arg[1]
sortie <- arg[2]

donne <- readLines(con=entree)


mat=matrix(0, nrow=4, ncol=7)

for( i in seq(2, length(donne), by=2) )
{
  seq <- strsplit(donne[i], "")[[1]]
  for( j in 1:7 )
  {
    nuc <- seq[j]
    if( nuc=="A" ){ mat[1,j] <- mat[1,j]+1 }
    if( nuc=="C" ){ mat[2,j] <- mat[2,j]+1 }
    if( nuc=="G" ){ mat[3,j] <- mat[3,j]+1 }
    if( nuc=="T" ){ mat[4,j] <- mat[4,j]+1 }
  }
}

mat2  <- mat/(length(donne)/2)
### Attention probs : A C G T
probs <- makePWM(mat2)

png(filename=sortie, width=800, height=800)
seqLogo(probs)
poubelle <- dev.off()
