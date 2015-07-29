#! /usr/bin/Rscript

### Usage : discretisation_micro_fisher_quantile.r entree sortie pvalue

##!!!!!!
options(error=recover)
##!!!!!!

cmd_args = commandArgs(TRUE)

if(length(cmd_args)!=3)
  {
    cat("Erreur :\nUsage : discretisation_micro_fisher_quantile.r entree sortie pvalue\n")
    quit()
  }

IN   <- cmd_args[1]
OUT  <- cmd_args[2]

if(cmd_args[3]<1) { pval   <- as.numeric(cmd_args[3]); select <- "pval"; }
if(cmd_args[3]>=1){ pop    <- as.numeric(cmd_args[3]); select <- "pop";  }

makeFisher <- function(read, count, col1F, col2F)
  {
    compt_col1 <- count[col1F] - read[col1F]
    compt_col2 <- count[col2F] - read[col2F]
    mat        <- matrix(c(read[col1F], read[col2F], compt_col1, compt_col2), nrow =2, ncol =2, byrow=T)
    tes        <- fisher.test(mat)
    return(tes$p.value)
  }
discretisation <- function(vect, pTest = pval)
  {
    t1 <- vect[1]
    t2 <- vect[2]
    pp <- vect[3]
    if(pp > pval) # ne bouge pas
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
distProf <- function(vect){ return( dist(matrix(vect, nrow=2, ncol=3, byrow=TRUE)) ) }
div      <- function(v1, v2){ return(v1/v2) }
normMed <- function(mat)
  {
### Obtiens la médiane par ligne
    medl <- apply(X=mat[,3:9], MARGIN=1, FUN=median)
### Supprime les élements dont la médiane est égale à 0
    mat <- mat[ -which(medl==0) ,]
### Normalise la matrice, d'abord par ARNm, puis par temps
    medl     <- apply(X=mat[,3:9], MARGIN=1, FUN=median)
    mat.medl <- apply(X=mat[,3:9], MARGIN=2, FUN=div, v2=medl)
    medc     <- apply(X=mat.medl,  MARGIN=2, FUN=median)
    mat.medc <- apply(X=mat.medl,  MARGIN=1, FUN=div, v2=medc)
    mat.norm <- t(mat.medc)
    mat.norm <- cbind(mat[,1:2], mat.norm)
    return(mat.norm)
  }

CountTable  <- read.table(IN, header=TRUE)

CountTable            <- normMed(CountTable)
CountMatrix           <- as.matrix(CountTable[,3:9])
CountMatrixNormalized <- as.matrix(CountTable[,3:9])
colsum                <- colSums(CountMatrixNormalized)

res     <- data.frame(CountTable[,1], CountTable[,2])
allpval <- data.frame(CountTable[,1], CountTable[,2])
Dall    <- matrix(c(1,2,4,1,3,5,2,4,6,3,5,7), ncol=2)
for( diff in 1:nrow(Dall) )
  {
    col1 <- Dall[diff,1]
    col2 <- Dall[diff,2]
    cat(colnames(CountMatrix)[col1], "VS", colnames(CountMatrix)[col2], "\n")

    tmat     <- apply(X=CountMatrixNormalized, MARGIN=1, FUN=makeFisher, count=colsum, col1F=col1, col2F=col2)
    p        <- as.numeric(tmat)
    names(p) <- CountMatrix[,1]
    adjust   <- p.adjust(p,method='BH')

    if(select=="pval")
      {
        tmp <- cbind(CountMatrixNormalized[,col1], CountMatrixNormalized[,col2], adjust)
        res <- cbind(res, apply(X=tmp, MARGIN=1, FUN=discretisation, pTest=pval) )
      }
    else if(select=="pop")
      {
        allpval <- cbind(allpval, as.numeric(adjust))
      }
  }

if(select=="pop")
  {
    seuil <- quantile(x=as.vector(as.matrix(allpval[,3:8])), probs=(pop/100))

    tmp   <- matrix(0, nrow=nrow(allpval), ncol=(ncol(allpval)-2))
    for( ligne in 1:nrow(allpval) )
      {
        for( colonne in 3:ncol(allpval) )
          {
            colonne2 = colonne - 2
            if( allpval[ligne,colonne] <= seuil)
              {
                t1 <- CountMatrixNormalized[ligne, Dall[colonne2,1]]
                t2 <- CountMatrixNormalized[ligne, Dall[colonne2,2]]
                if(t1<t2) # croissant
                  {
                    tmp[ligne, colonne2] <- 1
                  }
                else if(t1>t2) # décroissant
                  {
                    tmp[ligne, colonne2] <- -1
                  }
              }
          }
      }

    res <- cbind(res, tmp)
  }

tmp <- apply(X=res[,3:8], MARGIN=1, FUN=distProf)
res <- cbind(res, tmp)

colnames(res) <- c("name", "seq", "D1A", "D2A", "D3A", "D1K", "D2K", "D3K", "distance");
write.table(x=res, file=OUT, quote=FALSE, row.names=FALSE, sep="\t")
