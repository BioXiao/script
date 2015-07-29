#!/usr/bin/env Rscript

### Usage : enri_fnt_concept.r liste_concepts fichier_fnt cpt_fnt sortie pvalue

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg <- commandArgs(TRUE)

if(length(arg)!=5)
  {
    cat("Erreur :\nUsage : enri_fnt_concept.r liste_concepts fichier_fnt cpt_fnt sortie pvalue\n")
    quit()
  }

### Définition de fichiers temporaires pour l'assigniation des fonction aux gènes des concepts
cat("Création des fichiers temporaires\n")
system(
       paste( "sed s/'-RA'.*// ", arg[1], " > tmpListe", sep="" )
       )
system(
       paste( "sed s/'-PA'// ", arg[2], " > tmpFnt", sep="" )
       )
system(
       "awk -F\" \" 'BEGIN{while(getline<\"tmpFnt\">0){ar[$1]=$0}}{if ($1 in ar){print ar[$1]} else{print $0}}' tmpListe > tmpAnnot"
       )

signifPval <- arg[5]

### Lecture des concepts (listeConcept) et de tout les ARNm (dans allArn)
cat("Lecture des concepts et des ARNm\n")
fichierConcept <- read.table(file="tmpAnnot", sep="$")

listeConcept <- NULL
nbr          <- 0
arnTmp       <- NULL
allArn       <- NULL
for( i in 1:nrow(fichierConcept) )
  {
    val <- as.character( fichierConcept[i,] )

    if( length(grep(x=val, pattern="concept")) == 1 )
      {
        nbr <- as.integer(strsplit(val, " ")[[1]][2])
        if(nbr != 1)
          {
            listeConcept <- c(listeConcept, list(arnTmp))
            arnTmp     <- NULL
          }
      }

    if( length(grep(x=val, pattern="ACYPI")) == 1 )
      {
        arnTmp <- c( arnTmp, val )
        allArn <- c( allArn, strsplit(val, "\t")[[1]][1] )
      }
  }
### Pour le dernier concepts
listeConcept <- c(listeConcept, list(arnTmp))
arnTmp       <- NULL
maxnbr       <- nbr
allArn       <- unique(allArn)


### Modification de listeConcept en matrixConcept
concept <- NULL
ARNm    <- NULL
GO      <- NULL
for( i in 1:length(listeConcept) )
  {
    for(j in listeConcept[[i]])
      {
        tmp     <- strsplit(j, "\t")[[1]]
        concept <- c(concept, i)
        ARNm    <- c(ARNm, tmp[1])
        GO      <- c(GO, tmp[2])
      }
  }
matrixConcept <- cbind(concept, ARNm, GO)


### Comptage du nombre de fonctions présent dans chacun des concepts
cat("Comptage du nombre de fonctions présent dans chacun des concepts\n")
comptage <- NULL
for( i in unique(concept) )
  {
    subMat <- subset(x=matrixConcept, subset=concept==i, select=GO)
    cpt    <- table(subMat)
    for( j in subMat )
      {
        val      <- as.integer( cpt[ which(names(cpt)==j) ] )
        comptage <- c(comptage, val)
      }
  }
matrixConcept         <- cbind(matrixConcept, comptage)
matrixConceptComptage <- unique( matrixConcept[, c(1,3,4) ] )

### Lecture des annotations
cat("Lecture du fichier des fonctions et comptage du nombre de fonctions présent dans l'ensemble des concepts\n")
fichierFnt <- read.table(file="tmpFnt", sep="\t")
### Comptage pour les fonctions
totalFnt <- NULL
for( i in allArn )
  {

    totalFnt <- rbind( totalFnt, fichierFnt[ which(fichierFnt[,1]==i) ,] )
  }
totalFnt <- cbind(as.character(totalFnt[,1]), as.character(totalFnt[,2]))
tableFnt <- table(totalFnt)
test     <- sapply(names(tableFnt), FUN=grep, pattern="ACYPI", invert=TRUE)
tableFnt <- tableFnt[which(test==1)]


### Calcul l'enrichissement fonctionnelle
cat("Calcul l'enrichissement fonctionelle pour chacun des concepts\n")
total      <- sum(tableFnt)
proportion <- NULL
vectPvalue <- NULL
for( i in unique(concept) )
  {
    subMat <- subset(x=matrixConceptComptage, subset=matrixConceptComptage[,1]==i, select=c(GO, comptage))
    n      <- sum(as.integer(subMat[,2]))
    for( j in 1:nrow(subMat) )
      {
        fnt        <- subMat[j,]
        nom        <- fnt[1]
        val        <- as.integer(fnt[2])
        valT       <- tableFnt[ which(names(tableFnt)==nom) ]
        donne      <- matrix( c(valT-val, val, total-n, n), nrow=2, byrow=TRUE )
        test       <- fisher.test(donne, alternative="l")
        vectPvalue <- c(vectPvalue, test$p.value)
        proportion <- c(proportion, paste(val, "/", valT, sep=""))
      }
  }
adjustPvalue <- p.adjust(p=vectPvalue, method="BH")
matrixPvalue <- cbind(matrixConceptComptage[,1:2], proportion, adjustPvalue)

### Prend les enrichissements significatifs
matrixOut <- subset(x=matrixPvalue, subset=as.numeric(adjustPvalue)<=signifPval)

### Écriture des sorties
sortie <- arg[4]
cat("Écriture de la sortie : ", sortie, "\n")
write.table(file=sortie, x=matrixOut, sep="\t", row.names=FALSE, col.names=FALSE, quote=FALSE)

### Suppression des fichiers temporaires
cat("Suppression des fichiers temporaires\n")
todel <- c("tmpListe", "tmpFnt", "tmpAnnot")
system2("rm", args=c("-f", todel))
