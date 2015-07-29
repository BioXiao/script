#!/usr/bin/env Rscript

### Usage : getStatsFromAllRes_alpha.r in out

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=2)
  {
    cat("Erreur :\nUsage : getStatsFromAllRes_alpha.r in out\n")
    quit()
  }

fileIn  <- arg[1]
fileOut <- arg[2]

data <- read.table(file=fileIn, header=TRUE)

res <- round(apply(X=data, MARGIN=2, FUN="mean"), digits=2)
res <- cbind(res, round(apply(X=data, MARGIN=2, FUN="sd"), digits=2))

res <- cbind(rownames(res), res)

colnames(res) <-  c("type","mean","sd")

write.table(x=res, file=fileOut, col.names=TRUE, row.names=FALSE, quote=FALSE, sep="\t", dec=",")
