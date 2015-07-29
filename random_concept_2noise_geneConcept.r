#!/usr/bin/env Rscript

### Usage : random_concept_2noise_geneConcept.r nObj nAtt nCon mObj mAtt %noiseSpu %noiseMis out

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=8)
  {
    cat("Erreur :\nUsage : random_concept_2noise_geneConcept.r nObj nAtt nCon mObj mAtt %noiseSpu %noiseMis out\n")
    quit()
  }

nObj <- as.numeric(arg[1])
nAtt <- as.numeric(arg[2])
nCon <- as.numeric(arg[3])
mObj <- as.numeric(arg[4])
mAtt <- as.numeric(arg[5])
pNoiseSpu <- as.numeric(arg[6])
pNoiseMis <- as.numeric(arg[7])
out <- arg[8]

### Génère les concepts
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

### Génère le bruit
### Fonction pour générer le bruit
applyNoise <- function(val, spu, mis)
  {
    ## Si il y a une relation (1), alors probabilité de supprimer cette relation
    ## 0 : la relation n'est pas supprimée, proba = 1-mis
    ## 2 : la relation est supprimée, proba = mis
    if(val==1)
      {
        return( sample( x=c(0,2), size=1, prob=c((1-mis),mis) ) )
      }

    ## Si il n'y a pas de relation (0), alors probabilité d'ajouter une relation
    ## 0 : pas de relation ajoutée, proba = 1-spu
    ## 2 : une relation est ajoutée, proba = spu
    if(val==0)
      {
        return( sample( x=c(0,2), size=1, prob=c((1-spu),spu) ) )
      }
  }

### Crée la matrix noiseM qui représente les relations modifiées :
### 0 : rien du tout
### 2 : une relation type missing ou spurious
noiseM <- apply(X=oriM, MARGIN=2, FUN="sapply", "applyNoise", pNoiseSpu, pNoiseMis)

finalM <- oriM+noiseM
### 3 = 1 to 0 -> missing
### 2 = 0 to 1 -> spurious
### 1 = 1 to 1 -> true
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
