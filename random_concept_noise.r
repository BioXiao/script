#!/usr/bin/env Rscript

### Usage : random_concept_noise.r nObj nAtt nRel %noise out

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=5)
  {
    cat("Erreur :\nUsage : random_concept_noise.r nObj nAtt nRel %noise out\n")
    quit()
  }

nObj <- as.numeric(arg[1])
nAtt <- as.numeric(arg[2])
nRel <- as.numeric(arg[3])
pNoise <- as.numeric(arg[4])
out <- arg[5]

tmp0 <- rep(0, times=((nObj*nAtt)-nRel))
tmp1 <- rep(1, times=nRel)

ori   <- sample(x=c(tmp0,tmp1), size=(nObj*nAtt))
noise <- sample(x=c(0,+2), size=(nObj*nAtt), replace=TRUE, prob=c((1-pNoise),pNoise))


oriM   <- matrix(nrow=nObj, ncol=nAtt, ori)
noiseM <- matrix(nrow=nObj, ncol=nAtt, noise)
finalM <- oriM+noiseM
### 3 = 1 to 0
### 2 = 0 to 1
### 1 = 1 to 1
### 0 = 0 to 0

finalR = NULL
for(i in 1:nObj)
  {
    for(j in 1:nAtt)
      {
        if(finalM[i,j]==1)
          {
            finalR = rbind(finalR, c(paste("o",i,sep=""),paste("a",j,sep=""),"true"))
          }
        if(finalM[i,j]==2)
          {
            finalR = rbind(finalR, c(paste("o",i,sep=""),paste("a",j,sep=""),"spurious"))
          }
        if(finalM[i,j]==3)
          {
            finalR = rbind(finalR, c(paste("o",i,sep=""),paste("a",j,sep=""),"missing"))
          }
      }    
  }

write.table(file=out, x=finalR, sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)
