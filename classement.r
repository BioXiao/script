#!/usr/bin/env Rscript

### Usage : classement.r donne sortie

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=2)
  {
    cat("Erreur :\nUsage : classement.r donne valeur sortie\n")
    quit()
  }

donne <- read.table(arg[1], header=FALSE)
if(dim(donne)[2]!=3)
  {
    cat("Erreur :\nPas le bon format en entrée")
  }

score        <- donne[,3]
## Multiplication par 10 pour l'asp
score.rang   <- rank(score)*10
donne.sortie <- data.frame(cbind(donne, score.rang))

write.table(x=donne.sortie[,c(1,2,4)], file=arg[2], quote=FALSE, row.names=FALSE, col.names=FALSE, sep="\t")
