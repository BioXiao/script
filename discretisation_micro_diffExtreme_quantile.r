#! /usr/bin/Rscript

### Usage : discretisation_micro_diffExtreme_quantile.r entree sortie pop

##!!!!!!
options(error=recover)
##!!!!!!

cmd_args = commandArgs(TRUE)

if(length(cmd_args)!=3)
  {
    cat("Erreur :\nUsage : discretisation_micro_diffExtreme_quantile.r entree sortie pop\n")
    quit()
  }

IN   <- cmd_args[1]
OUT  <- cmd_args[2]

pop    <- as.numeric(cmd_args[3])

distProf <- function(vect){ return( dist(matrix(vect, nrow=2, ncol=3, byrow=TRUE)) ) }

CountTable  <- read.table(IN, header=TRUE)
CountMatrix <- as.matrix(CountTable[,3:9])

library("limma", quietly=TRUE)
CountMatrixNormalized <- normalizeBetweenArrays(CountMatrix,method="quantile")
colsum                <- colSums(CountMatrixNormalized)

res     <- data.frame(CountTable[,1], CountTable[,2])
allpval <- data.frame(CountTable[,1], CountTable[,2])
Dall    <- matrix(c(1,2,4,1,3,5,2,4,6,3,5,7), ncol=2)

d1a <- CountMatrixNormalized[,2] - CountMatrixNormalized[,1]
d2a <- CountMatrixNormalized[,4] - CountMatrixNormalized[,2]
d3a <- CountMatrixNormalized[,6] - CountMatrixNormalized[,4]
d1k <- CountMatrixNormalized[,3] - CountMatrixNormalized[,1]
d2k <- CountMatrixNormalized[,5] - CountMatrixNormalized[,3]
d3k <- CountMatrixNormalized[,7] - CountMatrixNormalized[,5]

diff      <- cbind(d1a, d2a, d3a, d1k, d2k, d3k)
seuil     <- quantile(x=abs(diff), probs=(1-(pop/100)))
diff.disc <- matrix(0, nrow=nrow(diff), ncol=ncol(diff))

diff.disc[which(diff <= -seuil)] <- -1
diff.disc[which(diff >=  seuil)] <-  1

diff.dist <- apply(X=diff.disc, MARGIN=1, FUN=distProf)
res       <- cbind(res, diff.disc, diff.dist)

colnames(res) <- c("name", "seq", "D1A", "D2A", "D3A", "D1K", "D2K", "D3K", "distance");
write.table(x=res, file=OUT, quote=FALSE, row.names=FALSE, sep="\t")
