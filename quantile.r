#!/usr/bin/env Rscript

### Usage : quantile.r donne valeur sortie

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=3)
  {
    cat("Erreur :\nUsage : quantile.r donne valeur sortie\n")
    quit()
  }

donne <- read.table(arg[1], header=FALSE)
if(dim(donne)[2]!=3)
  {
    cat("Erreur :\nPas le bon format en entrée")
  }

score <- donne[,3]

val <- as.integer(arg[2])

qq <- quantile(x=score, probs=seq(0,1,by=(1/val)))

score.classe <- c()

for( j in 1:length(score) )
  {
    for( i in 1:(length(qq)-1) )
      {
        if(score[j]>=qq[i] & score[j]<qq[i+1])
          {
            score.classe <- c(score.classe, i)
          }
      }
    if(score[j]==max(score))
      {
        score.classe <- c(score.classe, val)
      }
  }

donne.sortie <- data.frame(cbind(donne, score.classe))

##cat(donne.sortie[1,1], "\t", donne.sortie[1,2], "\t", donne.sortie[1,4], sep="", file=arg[3])
##for( i in 2:ncol(donne.sortie) )
  ##{
    ##cat(donne.sortie[i,1], "\t", donne.sortie[i,2], "\t", donne.sortie[i,4], sep="", file=arg[3], append=TRUE)
  ##}

write.table(x=donne.sortie[,c(1,2,4)], file=arg[3], quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
