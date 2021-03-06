#! /usr/bin/Rscript

### Usage : discretisation_microarn_DESeq_cine_stade.r countT0 countOther sortie pvalueCine pvalueStade

### Les arguments
cmd_args <- commandArgs(TRUE)

### Test le nombre d'arguments
if(length(cmd_args)!=5)
  {
    cat("Erreur :\nUsage : discretisation_microarn_DESeq_cine_stade.r countT0 countOther sortie pvalueCine pvalueStade\n")
    quit()
  }

library(DESeq, quietly = TRUE)

### Définition de la fonction de discrétisation
discretisation <- function(vect, pval)
  {
    t1 <- as.numeric(vect[3])
    t2 <- as.numeric(vect[4])
    pp <- as.numeric(vect[8])
    
    if(is.na(pp)) # count trop faible
      {
        return(NA)
      }
    else if(pp > pval)  # ne bouge pas
      {
	      return(0)
      }
    else if(t1<t2) # croissant
      {
	      return(1)
      }
    else if(t1>t2) # décroissant
      {
	      return(-1)
      }
  }

### Définition de la fonction qui permet d'obtenir la distance entre deux vecteurs discrétisés
distProf <- function(vect){ return( dist(matrix(vect, nrow=2, ncol=3, byrow=TRUE)) ) }

### Définition de la fonction qui permet de savoir si combien de valeurs sont différentes de 0 sur un vecteur
distProf2 <- function(vect){ return( sum(vect!=0) ) }


### Lecture des arguments
countT0    <- cmd_args[1]
countOther <- cmd_args[2]
OUT        <- cmd_args[3]
pvalue     <- as.numeric(cmd_args[4])
pvalueS    <- as.numeric(cmd_args[5])

### Lecture et mise en forme des fichiers d'entrées
count1 <- read.table(countOther, header=TRUE)[,c(1,6:23)]
count2 <- read.table(countT0,    header=TRUE)[,c(1,6:11)]
#T0     <- rowSums(count2[,2:7])
#count  <- cbind(T0, count1[,2:ncol(count1)])
count  <- cbind(count2[,2:ncol(count2)], count1[,2:ncol(count1)])
##name   <- c("T0", rep(c("T1A","T1K","T2A","T2K","T3A","T3K"),each=3))
name   <- c(rep("T0", time=6), rep(c("T1A","T1K","T2A","T2K","T3A","T3K"),each=3))
row.names(count) <- count1[,1]

### Lecture par DESeq
cds <- newCountDataSet(count, name)
cds <- estimateSizeFactors(cds)
cds <- estimateDispersions(cds)

### Test d'analyse différentielle entre Ti et Ti+1
d1a <- nbinomTest(cds, "T0", "T1A")
d1k <- nbinomTest(cds, "T0", "T1K")
d2a <- nbinomTest(cds, "T1A", "T2A")
d2k <- nbinomTest(cds, "T1K", "T2K")
d3a <- nbinomTest(cds, "T2A", "T3A")
d3k <- nbinomTest(cds, "T2K", "T3K")

### Test d'analyse différentielle entre TiS et TiAS
d1 <- nbinomTest(cds, "T1A", "T1K")
d2 <- nbinomTest(cds, "T2A", "T2K")
d3 <- nbinomTest(cds, "T3A", "T3K")

### Mise en forme de la matrice des pvalues associées au tests différentiels
##allPval            <- cbind(d1a$padj, d1k$padj, d2a$padj, d2k$padj, d3a$padj, d3k$padj)
##row.names(allPval) <- d1a[,1]
##colnames(allPval)  <- c("T1A","T1K","T2A","T2K","T3A","T3K")

### Applique la discrétisaton sur l'ensemble des pvalues pour les tests Ti vs Ti+1
dd1a  <- apply(X=d1a, MARGIN=1, FUN=discretisation, pval=pvalue)
dd1k  <- apply(X=d1k, MARGIN=1, FUN=discretisation, pval=pvalue)
dd2a  <- apply(X=d2a, MARGIN=1, FUN=discretisation, pval=pvalue)
dd2k  <- apply(X=d2k, MARGIN=1, FUN=discretisation, pval=pvalue)
dd3a  <- apply(X=d3a, MARGIN=1, FUN=discretisation, pval=pvalue)
dd3k  <- apply(X=d3k, MARGIN=1, FUN=discretisation, pval=pvalue)

### Applique la discrétisaton sur l'ensemble des pvalues pour les tests TiS vs TiAS
### Avec 0 si aucun changement d'expression, -1 si TiS > TiAS et 1 si TiS < TiAS
dd1 <- apply(X=d1, MARGIN=1, FUN=discretisation, pval=pvalue)
dd2 <- apply(X=d2, MARGIN=1, FUN=discretisation, pval=pvalue)
dd3 <- apply(X=d3, MARGIN=1, FUN=discretisation, pval=pvalue)

### Calcule la distance entre les vecteurs discrétisés
tmp      <- cbind(dd1a, dd2a, dd3a, dd1k, dd2k, dd3k)
dist.rna <- apply(X=tmp, MARGIN=1, FUN=distProf)

tmp       <- cbind(dd1, dd2, dd3)
dist.rna2 <- apply(X=tmp, MARGIN=1, FUN=distProf2)

### Met en forme la matrice de sortie
#res.rna           <- cbind(row.names(allPval), dd1a, dd2a, dd3a, dd1k, dd2k, dd3k, dist.rna)
#res.rna           <- cbind(d1a[,1], dd1a, dd2a, dd3a, dd1k, dd2k, dd3k, dist.rna)
res.rna           <- cbind(d1a[,1], dd1a, dd2a, dd3a, dd1k, dd2k, dd3k, dist.rna, dd1, dd2, dd3, dist.rna2)
colnames(res.rna) <- c("name", "D1A", "D2A", "D3A", "D1K", "D2K", "D3K", "distance", "T1", "T2", "T3", "distance2")

### Écrit la matrice discrétisée dans le fichier de sortie donné en argument
write.table(x=res.rna, file=OUT, quote=FALSE, row.names=FALSE, sep="\t")
