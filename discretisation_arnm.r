#! /usr/bin/Rscript

### Usage : discretisation_arnm.r entree sortie pvalue/pop

##!!!!!!
options(error=recover)
##!!!!!!

cmd_args = commandArgs(TRUE)

if(length(cmd_args)!=3)
  {
    cat("Erreur :\nUsage : discretisation_arnm.r entree sortie pvalue/pop\n")
    quit()
  }

IN   <- cmd_args[1]
OUT  <- cmd_args[2]

if(cmd_args[3]<1)
  {
    pval   <- as.numeric(cmd_args[3])
    select <- "pval"
  }
if(cmd_args[3]>=1)
  {
    pop    <- as.numeric(cmd_args[3])
    select <- "pop"
  }
  
discretisation <- function(vect, pTest = pval)
  {
    t1 <- vect[1]
    t2 <- vect[2]
    pp <- vect[3]
    
    if(is.na(pp) || pp > pval) # ne bouge pas
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


CountTable <- read.table(IN, header=TRUE)
res        <- data.frame(CountTable[,1])
Dall       <- matrix(c( 2,3,4, 5,6,7, 8,9,10 ), ncol=3, byrow=TRUE)

if(select=="pval")
  {
    for(diff in 1:nrow(Dall))
      {
        tmp <- cbind(CountTable[,Dall[diff,1]], CountTable[,Dall[diff,2]], CountTable[,Dall[diff,3]])
        res <- cbind(res, apply(X=tmp, MARGIN=1, FUN=discretisation, pTest=pval) )
      }
  }

if(select=="pop")
  {
    allpval <- CountTable[, c(1,4,7,10) ]
    seuil   <- quantile(x=as.vector(as.matrix(allpval[,2:4])), probs=(pop/100), na.rm=TRUE)
    tmp     <- matrix(0, nrow=nrow(allpval), ncol=(ncol(allpval)-1))

    for( ligne in 1:nrow(allpval) )
      {
        for( colonne in 2:ncol(allpval) )
          {
            colonne2 = colonne - 1
            if( !is.na(allpval[ligne,colonne]) && allpval[ligne,colonne] <= seuil )
              {
                t1 <- CountTable[ligne, Dall[colonne2,1]]
                t2 <- CountTable[ligne, Dall[colonne2,2]]
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


colnames(res) <- c("name", "T1", "T2", "T3");
write.table(x=res, file=OUT, quote=FALSE, row.names=FALSE, sep="\t")
