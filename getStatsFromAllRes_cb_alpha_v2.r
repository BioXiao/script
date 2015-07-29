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

res <- round(apply(X=data, MARGIN=2, FUN="mean"), digits=1)
res <- cbind(res, round(apply(X=data, MARGIN=2, FUN="sd"), digits=1))

#res <- cbind(rownames(res), res)

#colnames(res) <-  c("type","mean","sd")

res <- t(res[c(2,5,8,11),])

res <- as.vector(res)

write.table(x=t(res), file=fileOut, col.names=FALSE, row.names=FALSE, quote=FALSE, sep=" & ", dec=",")
