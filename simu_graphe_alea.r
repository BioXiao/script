#!/usr/bin/env Rscript

### Usage : simu_graphe_alea.r nNode1 nNode2 nEdge proportion mu1 sd1 mu2 sd2 outFile

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg <- commandArgs(TRUE)

if(length(arg)!=9)
{
  print("Pas le bon nombre d'arguments :\nUsage : simu_graphe_alea.r nNode1 nNode2 nEdge proportion mu1 sd1 mu2 sd2 outFile\n")
  quit()
}

### Read arguments
node1 <- as.numeric(arg[1])
node2 <- as.numeric(arg[2])
edge  <- as.numeric(arg[3])
propo <- as.numeric(arg[4])
mu1   <- as.numeric(arg[5])
sd1   <- as.numeric(arg[6])
mu2   <- as.numeric(arg[7])
sd2   <- as.numeric(arg[8])
outFile <- arg[9]

### Number of good and false edges
trueEdge  <- round(propo*edge)
falseEdge <- edge-trueEdge

### Generate the edge list
set1 <- paste("set1", 1:node1, sep="_")
set2 <- paste("set2", 1:node2, sep="_")

inter1 <- sample(x=set1, size=edge, replace=TRUE)
inter2 <- sample(x=set2, size=edge, replace=TRUE)
inter  <- cbind(inter1, inter2)

### Generate the score
trueScore  <- rnorm(n=trueEdge,  mean=mu1, sd=sd1)
falseScore <- rnorm(n=falseEdge, mean=mu2, sd=sd2)

type <- c( rep(x="trueEdge", length.out=trueEdge), rep(x="falseEdge", length.out=falseEdge) )
inter <- cbind(inter, type, c(trueScore, falseScore) )

### Write the out file
tmp    <- c( "node1","node2","edge","p","mu1","sd1","mu2","sd2" )
outArg <- paste(tmp, arg[1:8], sep=":")
write.table(x=t(outArg), file=outFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)
write.table(x=inter, file=outFile, append=TRUE, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)
