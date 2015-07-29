#!/usr/bin/env Rscript

### Usage : conceptASP2EnriFntHyper.r liste_concepts fichier_fnt sortie

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg <- commandArgs(TRUE)

if(length(arg)!=3)
  {
    cat("Usage : conceptASP2EnriFntHyper.r liste_concepts fichier_fnt sortie\n")
    quit()
  }

### Définition de fichiers temporaires pour l'assigniation des fonction aux gènes des concepts
cat("Création des fichiers temporaires\n")
system(
       paste( " grep 'arnm' ", arg[1], " | sed s/'-RA'.*/''/ | sed s/'concept('/''/g | sed s/',.*,\"'/' '/g > tmpListe", sep="" )
       )
system(
       paste( "sed s/'-PA'/''/ ", arg[2], " > tmpFnt", sep="" )
       )
system(
       "awk -F\" \" 'BEGIN{while(getline<\"tmpFnt\">0){ar[$1]=$0}}{if ($2 in ar){print $1 \"\t\" ar[$2]} else{print $0}}' tmpListe > tmpAnnot"
       )

### Création de matrixConcept
matrixConcept        <- read.table(file="tmpAnnot", sep="\t")
names(matrixConcept) <- c("concept","ARNm","GO")
allArn               <- as.vector(unique(matrixConcept[,2]))

### Comptage du nombre de fonctions présent dans chacun des concepts
cat("Comptage du nombre de fonctions présent dans chacun des concepts\n")
comptage <- NULL
for( i in unique(matrixConcept$concept) )
  {
    subMat <- subset(x=matrixConcept, subset=concept==i, select=GO)
    cpt    <- table(subMat)
    for( j in subMat[,1] )
      {
        val      <- as.integer( cpt[ which(names(cpt)==j) ] )
        comptage <- c(comptage, val)
      }
  }
matrixConcept         <- cbind(matrixConcept, comptage)
matrixConceptComptage <- unique( matrixConcept[, c(1,3,4) ] )

### Lecture des annotations
cat("Lecture du fichier des fonctions et comptage du nombre de fonctions présentes dans l'annotation total\n")# dans l'ensemble des concepts\n")
fichierFnt <- read.table(file="tmpFnt", sep="\t")
### Comptage pour les fonctions
###totalFnt <- NULL
###totalFnt <- merge(fichierFnt, as.data.frame(allArn), by.x="V1", by.y="allArn", all=FALSE)
###tableFnt <- table(totalFnt[,2])[which(table(totalFnt[,2])!=0)]

allAnnot <- unique(matrixConcept[,2:3])
tableFnt <- NULL
for( go in unique(allAnnot[,2]) )
  {
    tmp = sum( allAnnot[,2]==go )
    tableFnt = rbind(tableFnt, c(go, tmp))
  }

### Calcul l'enrichissement fonctionnelle avec une loi hypergéométrique
cat("Calcul l'enrichissement fonctionelle pour chacun des concepts\n")
total      <- sum(as.integer(tableFnt[,2]))
proportion <- NULL
vectPvalue <- NULL
for( i in unique(matrixConcept$concept) )
  {
    subMat <- subset(x=matrixConceptComptage, subset=matrixConceptComptage[,1]==i, select=c(GO, comptage))
    n      <- sum(as.integer(subMat[,2]))
    for( j in 1:nrow(subMat) )
      {
        fnt        <- subMat[j,]
        nom        <- fnt[1][1,1]
        val        <- as.integer(fnt[2])
        ###valT       <- tableFnt[ which(names(tableFnt)==nom) ]
        valT       <- as.integer(tableFnt[ which(tableFnt==nom),2 ])
        ## valT = GOi dans la totalité des données, val = GOi dans le concept, n = nombre total de GO dans le concept, total = nombre total d'annotation
        pvalue     <- phyper(q=val, m=valT, n=(total-valT), k=n, lower.tail = FALSE)
        vectPvalue <- c(vectPvalue, pvalue)
        proportion <- c(proportion, paste(val, "/", valT, sep=""))
      }
  }
adjustPvalue <- p.adjust(p=vectPvalue, method="BH")
matrixPvalue <- cbind(matrixConceptComptage[,1:2], proportion, adjustPvalue)

### Prend tout les enrichissements
matrixOut <- matrixPvalue

### Écriture des sorties
sortie <- arg[3]
cat("Écriture de la sortie : ", sortie, "\n")
write.table(file=sortie, x=matrixOut, sep="\t", row.names=FALSE, col.names=FALSE, quote=FALSE)

### Suppression des fichiers temporaires
cat("Suppression des fichiers temporaires\n")
todel <- c("tmpListe", "tmpFnt", "tmpAnnot")
system2("rm", args=c("-f", todel))
