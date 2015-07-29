#!/usr/bin/env Rscript

## Usage : simu_graphe_unif_gmm.r nNode1 nNode2 nEdge proportionUnif xg1 xg2 xg3 xg4 yg1 yg2 yg3 xd1 xd2 xd3 xd4 yd1 yd2 yd3 proportion mu1 sd1 mu2 sd2 outFile

## Valeur TRUE permet de n'avoir que les arguments d'interets
arg <- commandArgs(TRUE)

if(length(arg)!=24)
{
  print("Pas le bon nombre d'arguments :\nUsage : simu_graphe_unif_gmm.r nNode1 nNode2 nEdge proportionUnif xg1 xg2 xg3 xg4 yg1 yg2 yg3 xd1 xd2 xd3 xd4 yd1 yd2 yd3 proportion mu1 sd1 mu2 sd2 outFile\n")
  quit()
}

## Read arguments
node1   <- as.numeric(arg[1])
node2   <- as.numeric(arg[2])
edge    <- as.numeric(arg[3])
propoUnif <- as.numeric(arg[4])
xg1     <- as.numeric(arg[5])
xg2     <- as.numeric(arg[6])
xg3     <- as.numeric(arg[7])
xg4     <- as.numeric(arg[8])
yg1     <- as.numeric(arg[9])
yg2     <- as.numeric(arg[10])
yg3     <- as.numeric(arg[11])
xd1     <- as.numeric(arg[12])
xd2     <- as.numeric(arg[13])
xd3     <- as.numeric(arg[14])
xd4     <- as.numeric(arg[15])
yd1     <- as.numeric(arg[16])
yd2     <- as.numeric(arg[17])
yd3     <- as.numeric(arg[18])
propo   <- as.numeric(arg[19])
mu1     <- as.numeric(arg[20])
sd1     <- as.numeric(arg[21])
mu2     <- as.numeric(arg[22])
sd2     <- as.numeric(arg[23])
outFile <- arg[24]


## Number of good and false edges
trueEdge  <- round(propo*edge)
falseEdge <- edge-trueEdge

## Number of edges up or under a threshold
leftEdge  <- round(propoUnif*edge)
rightEdge <- edge-leftEdge


## Generate the degree for the node
xg1 <- xg1 * leftEdge
xg2 <- xg2 * leftEdge
xg3 <- xg3 * leftEdge
xg4 <- xg4 * leftEdge

xd1 <- xd1 * rightEdge
xd2 <- xd2 * rightEdge
xd3 <- xd3 * rightEdge
xd4 <- xd4 * rightEdge


ng1 <- round( (yg2-yg1) * node1, 0)
ng2 <- round( (yg3-yg2) * node1, 0)
ng3 <- round( (1-yg3)   * node1, 0)

nd1 <- round( (yd2-yd1) * node1, 0)
nd2 <- round( (yd3-yd2) * node1, 0)
nd3 <- round( (1-yd3)   * node1, 0)


ug1 <- round( runif(n=ng1, min=xg1, max=xg2), 0)
ug2 <- round( runif(n=ng2, min=xg2, max=xg3), 0)
ug3 <- round( runif(n=ng3, min=xg3, max=xg4), 0)

ud1 <- round( runif(n=nd1, min=xd1, max=xd2), 0)
ud2 <- round( runif(n=nd2, min=xd2, max=xd3), 0)
ud3 <- round( runif(n=nd3, min=xd3, max=xd4), 0)


uallg <- c(ug1, ug2, ug3)
ualld <- c(ud1, ud2, ud3)


## Generate the edge list with the degree calculate before
set1 <- paste("set1", 1:node1, sep="_")
set2 <- paste("set2", 1:node2, sep="_")

interLeft  <- NULL
interRight <- NULL
for( nbr in 1:length(uallg) )
  {
    interLeft  <- c(interLeft,  rep(x=set1[nbr], length.out=uallg[nbr]))
    interRight <- c(interRight, rep(x=set1[nbr], length.out=ualld[nbr]))
  }

inter1 <- c(interLeft, interRight)
## Generate with the length of inter1
##inter2 <- sample(x=set2, size=edge, replace=TRUE)
inter2 <- sample(x=set2, size=length(inter1), replace=TRUE)
inter  <- cbind(inter1, inter2)


## Generate the score
## Use the proportion of propUnif for the generation of the score, maybe a bad idea but try
## trueScore  <- rnorm(n=leftEdge,  mean=mu1, sd=sd1)
## falseScore <- rnorm(n=rightEdge, mean=mu2, sd=sd2)

trueScore  <- rnorm(n=sum(uallg),  mean=mu1, sd=sd1)
falseScore <- rnorm(n=sum(ualld), mean=mu2, sd=sd2)
## Use the length of uall[g/d]
type  <- c( rep(x="trueEdge", length.out=sum(uallg)), rep(x="falseEdge", length.out=sum(ualld)) )
inter <- cbind(inter, type, c(trueScore, falseScore) )


## Write the out file
tmp    <- c("node1", "node2", "edge", "proportionUnif", "xg1", "xg2", "xg3", "xg4", "yg1", "yg2", "yg3", "xd1", "xd2", "xd3", "xd4", "yd1", "yd2", "yd3", "proportion", "mu1", "sd1", "mu2", "sd2")
outArg <- paste(tmp, arg[1:23], sep=":")
write.table(x=t(outArg), file=outFile, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)
write.table(x=inter, file=outFile, append=TRUE, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)






## ## Generate the edge list
## set1 <- paste("set1", 1:node1, sep="_")
## set2 <- paste("set2", 1:node2, sep="_")

## inter1 <- sample(x=set1, size=edge, replace=TRUE)
## inter2 <- sample(x=set2, size=edge, replace=TRUE)
## inter  <- cbind(inter1, inter2)

## ## Generate the score
## trueScore  <- rnorm(n=trueEdge,  mean=mu1, sd=sd1)
## falseScore <- rnorm(n=falseEdge, mean=mu2, sd=sd2)

## type <- c( rep(x="trueEdge", length.out=trueEdge), rep(x="falseEdge", length.out=falseEdge) )
## inter <- cbind(inter, type, c(trueScore, falseScore) )
