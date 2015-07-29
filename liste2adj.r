#!/usr/bin/env Rscript

### Usage : liste2adj.r entree sortie

library(FactoMineR, quietly=TRUE)

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg <- commandArgs(TRUE)

if(length(arg)!=2)
{
  print("Pas le bon nombre d'arguments :\nUsage : liste2adj.r entree sortie\n")
  quit()
}

donne  <- read.table(arg[1], header=TRUE, sep="\t")
nmicro <- length(unique(donne[,1]))
narnm  <- length(unique(donne[,2]))
adj    <- matrix(0, nrow=narnm, ncol=nmicro)

colnames(adj) <- unique(donne[,1])
rownames(adj) <- unique(donne[,2])

for(i in 1:nrow(donne))
{
  micro <- donne[i,1]
  arnm  <- donne[i,2]
  col   <- which(colnames(adj)==micro)
  row   <- which(rownames(adj)==arnm)
  
  adj[row,col] <- 1
}

write.table(x=adj, file=arg[2], sep=" ", row.names=TRUE, col.names=TRUE)
