#!/usr/bin/env Rscript

### Usage : random_concept_noise_geneConcept.r nObj nAtt nCon mObj mAtt %noise out

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=7)
  {
    cat("Erreur :\nUsage : random_concept_noise.r nObj nAtt nCon mObj mAtt %noise out\n")
    quit()
  }

nObj <- as.numeric(arg[1])
nAtt <- as.numeric(arg[2])
nCon <- as.numeric(arg[3])
mObj <- as.numeric(arg[4])
mAtt <- as.numeric(arg[5])
pNoise <- as.numeric(arg[6])
out <- arg[7]


## if((mObj*nCon)>=nObj)
##   {
##     cat("Erreur :\nNombre d'objets trop petit pour les paramètres\n")
##     quit()
##   }
## if((mAtt*nCon)>=nAtt)
##   {
##     cat("Erreur :\nNombre d'attributs trop petit pour les paramètres\n")
##     quit()
##   }


oriM   <- matrix(nrow=nObj, ncol=nAtt, 0)
for(i in 1:nCon)
  {
    taille1 <- round( rnorm(n=1, mean=mObj, sd=2) )
    taille2 <- round( rnorm(n=1, mean=mAtt, sd=2) )
    
    coord1 <- sample(x=(1:(nObj-(taille1-1))), size=1)
    coord2 <- sample(x=(1:(nAtt-(taille2-1))), size=1)
    
    l1 <- coord1
    l2 <- coord1+taille1-1
    c1 <- coord2
    c2 <- coord2+taille2-1
    
    oriM[l1:l2,c1:c2] <- 1
  }

noise <- sample(x=c(0,2), size=(nObj*nAtt), replace=TRUE, prob=c((1-pNoise),pNoise))


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
