#!/usr/bin/env Rscript

### Usage : simu_bio_these.r nMi nArn nInter pSpu mu1 sd1 min1 max1 mu2 sd2 min2 max2 out

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=13)
  {
    cat("Erreur :\nUsage : simu_bio_these.r nMi nArn nInter pSpu mu1 sd1 min1 max1 mu2 sd2 min2 max2 out\n")
    quit()
  }

nMi    <- as.numeric(arg[1])
nArn   <- as.numeric(arg[2])
nInter <- as.numeric(arg[3])
pSpu   <- as.numeric(arg[4])
mu1    <- as.numeric(arg[5])
sd1    <- as.numeric(arg[6])
min1   <- as.numeric(arg[7])
max1   <- as.numeric(arg[8])
mu2    <- as.numeric(arg[9])
sd2    <- as.numeric(arg[10])
min2   <- as.numeric(arg[11])
max2   <- as.numeric(arg[12])
out    <- arg[13]


### Calcule les nombres de vraies et fausses interactions théoriques
### en fonction de la probabilité de la gmm
interV <- round(nInter*(1-pSpu), 0)
interF <- round(nInter*pSpu, 0)

### Génère les degrés des microARN types vraies et fausses interactions
### Pourcentages
miDegPV <- runif(nMi, min1, max1)
miDegPF <- runif(nMi, min2, max2)

### Valeurs brutes
miDegV <- round( miDegPV*interV, 0)
miDegF <- round( miDegPF*interF, 0)

### Liste de noms
miVectV <- NULL
miVectF <- NULL
for(i in 1:nMi)
  {
    miVectV <- c(miVectV, rep(i, miDegV[i]))
    miVectF <- c(miVectF, rep(i, miDegF[i]))
  }
miVect <- paste("mi", c(miVectV,miVectF), sep="")

### Recalcule les nombres d'interactions en fonction des résultats
### obtenus sur les simulations des microARN
inter2V <- length(miVectV)
inter2F <- length(miVectF)

### Génère les vecteurs des noms des ARN en fonction des degrés des micro
### Fait une boucle pour n'avoir que 1 fois chaque couple au max
arnVectV  <- NULL
arnListeV <- NULL
for(i in 1:length(miDegV))
{
  tmp       <- sample(x=1:nArn, size=miDegV[i], replace=FALSE)
  arnListeV <- c(arnListeV, list(tmp))
  arnVectV  <- c(arnVectV, tmp)
}

### Pour les fausses inter, fait aussi une boucle
### et pour chaque micro enlève les ARN avec une vraie inter
arnVectF <- NULL
for(i in 1:length(miDegF))
{
  indiceA  <- arnListeV[[i]]
  tmp      <- sample(x=(1:nArn)[-indiceA], size=miDegF[i], replace=FALSE)
  arnVectF <- c(arnVectF, tmp)
}

arnVect  <- paste("arn", c(arnVectV,arnVectF), sep="")

### Génère les vecteurs de scores des vraies et des fausses interactions
scoreVectV <- round(rnorm(n=inter2V, mean=mu1, sd=sd1), 4)
scoreVectF <- round(rnorm(n=inter2F, mean=mu2, sd=sd2), 4)
scoreVect  <- c(scoreVectV,scoreVectF)

### Génère les vecteurs true/spurious
typeVect <- rep(c("true","spurious"), times=c(inter2V,inter2F))

### Génère la matrice type mi, arn, score, type
simuData     <- cbind(as.character(miVect),as.character(arnVect),as.numeric(scoreVect), as.character(typeVect))
simuData     <- as.data.frame(simuData)
simuData[,3] <- as.numeric(as.character(simuData[,3]))

write.table(file=out, x=t(arg), sep=" ; ", quote=FALSE, row.names=FALSE, col.names=FALSE)
write.table(file=out, append=TRUE, x=simuData, sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)
