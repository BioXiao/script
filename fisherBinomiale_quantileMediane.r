#! /usr/bin/Rscript

### Usage : fisherBinomiale_quantileMediane.r entree col1 col2 sortie

cmd_args = commandArgs(TRUE)

if(length(cmd_args)!=4)
  {
    cat("Erreur :\nUsage : fisherBinomiale_quantileMediane.r entree col1 col2 sortie\n")
    quit()
  }

col1 = as.numeric(cmd_args[2])
col2 = as.numeric(cmd_args[3])

CountTable <- read.table(cmd_args[1], header=TRUE)
CountMatrix <- as.matrix(CountTable[,3:9])

cat(colnames(CountMatrix)[col1], "VS", colnames(CountMatrix)[col2], "\n")

tmat <- matrix(0, ncol = 1, nrow = nrow(CountTable))
names(tmat) <- rownames(CountMatrix)

library("limma", quietly=TRUE)
CountMatrixNormalized <- normalizeBetweenArrays(CountMatrix,method="quantile")

colsum <- colSums(CountMatrixNormalized)

for (i in 1:nrow(CountMatrixNormalized))
  {
    compt_col1 = colsum[col1] - CountMatrixNormalized[i,col1]
    compt_col2 = colsum[col2] - CountMatrixNormalized[i,col2]
    mat = matrix(c(CountMatrixNormalized[i,col1], CountMatrixNormalized[i,col2],
      compt_col1, compt_col2), nrow =2, ncol =2, byrow=T)
    
    tes <- fisher.test(mat)
    tmat[i,1] <- tes$p.value
  }

p <- as.numeric(tmat[,1])
names(p) <-rownames(CountMatrix)
adjust = p.adjust(p,method='BH')

res <-data.frame(CountTable[,1], CountTable[,2], CountMatrix[,col1], CountMatrix[,col2],CountMatrixNormalized[,col1],CountMatrixNormalized[,col2],tmat,adjust);
colnames(res) <- c("name", "seq", "count1", "count2", "norm.count1", "norm.count2", "p_val", "ad. p_val"); 

write.table(x=res, file=cmd_args[4], quote=FALSE, row.names=FALSE)
