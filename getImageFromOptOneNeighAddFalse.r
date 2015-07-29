#!/usr/bin/env Rscript

### Usage : getImageFromOptOneNeigh.r rOrderFile cOrderFile trueInteractionFile thresoldTrue falseInteractionFile thresoldFalse outFile

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg <- commandArgs(TRUE)

if(length(arg)!=7)
{
  print("Pas le bon nombre d'arguments :\nUsage : getImageFromOptOneNeigh.r rOrderFile cOrderFile trueInteractionFile thresoldTrue falseInteractionFile thresoldFalse outFile\n")
  quit()
}

library(gplots, quietly=TRUE, verbose=FALSE)

parse <- function(vect)
{
  tmp1 = sub(".*\\(", "", vect)
  tmp2 = gsub("\"", "", tmp1)
  tmp3 = gsub("\\).*", "", tmp2)
  res  = strsplit(tmp3, ",")[[1]]
  return(res)
}


### Read arguments
nrOrder <- arg[1]
ncOrder <- arg[2]
ninter  <- arg[3]
thres   <- as.numeric(arg[4])
nfalse  <- arg[5]
thresf  <- as.numeric(arg[6])
outFile <- arg[7]
rorder  <- read.table(nrOrder)
corder  <- read.table(ncOrder)
inter   <- read.table(ninter)
false   <- read.table(nfalse)

tmp <- t(apply(rorder, 1, parse))
fol <- names(which(table(c(tmp[,1],tmp[,2]))==1))
if( sum(fol[1]==tmp[,1])==1 )
  {
    first <- fol[1]
    last  <- fol[2]
  }
if( sum(fol[1]==tmp[,1])==0 )
  {
    first <- fol[2]
    last  <- fol[1]
  }

rnames <- first
for( i in 1:nrow(tmp) )
  {
    second <- tmp[tmp[,1]==rnames[i],2]
    rnames <- c(rnames, second)
  }


tmp <- t(apply(corder, 1, parse))
fol <- names(which(table(c(tmp[,1],tmp[,2]))==1))
if( sum(fol[1]==tmp[,1])==1 )
  {
    first <- fol[1]
    last  <- fol[2]
  }
if( sum(fol[1]==tmp[,1])==0 )
  {
    first <- fol[2]
    last  <- fol[1]
  }

cnames <- first
for( i in 1:nrow(tmp) )
  {
    second <- tmp[tmp[,1]==cnames[i],2]
    cnames <- c(cnames, second)
  }

inter.parse <- apply(inter, 1, parse)
inter.thres <- inter.parse[1:2,as.numeric(inter.parse[3,])<=thres]

false.parse <- apply(false, 1, parse)
false.thres <- false.parse[1:2,as.numeric(false.parse[3,])<=thresf]

tmp1 <- unique(false.thres[1,])
tmp2 <- unique(false.thres[2,])

if( sum(tmp1 %in% rnames)>=1 )
  {
    frnames = tmp1
    fcnames = tmp2
  }
if( sum(tmp1 %in% rnames)==0 )
  {
    frnames = tmp2
    fcnames = tmp1
  }

spefrnames <- frnames[!(frnames%in%rnames)]
spefcnames <- fcnames[!(fcnames%in%cnames)]
rnames     <- c(rnames, spefrnames)
cnames     <- c(cnames, spefcnames)

### Add true interactions
mat <- matrix(data=0, nrow=length(rnames), ncol=length(cnames), dimnames=list(rnames,cnames))
if( sum(rownames(mat)==inter.thres[1,1])==1 )
{
  for( i in 1:ncol(inter.thres) )
    {
      j <- inter.thres[,i]
      mat[j[1], j[2]] <- 1
    }
}

if( sum(rownames(mat)==inter.thres[1,1])==0 )
{
  for( i in 1:ncol(inter.thres) )
    {
      j <- inter.thres[,i]
      mat[j[2], j[1]] <- 1
    }
}

flag <- 0
### Add false interactions
if( sum(rownames(mat)==false.thres[1,1])>=1 )
{
  for( i in 1:ncol(false.thres) )
    {
      j <- false.thres[,i]
      if( (2 %in% colSums(apply(inter.thres, 2, "%in%", j)))==FALSE )
        {
          mat[j[1], j[2]] <- -1
        }
      if( (2 %in% colSums(apply(inter.thres, 2, "%in%", j)))==TRUE )
        {
          mat[j[1], j[2]] <- -2
          flag <- 1
        }
    }
}

if( sum(rownames(mat)==false.thres[1,1])==0 )
{
  for( i in 1:ncol(false.thres) )
    {
      j <- false.thres[,i]
      if( (2 %in% colSums(apply(inter.thres, 2, "%in%", j)))==FALSE )
        {
          mat[j[2], j[1]] <- -1
        }
      if( (2 %in% colSums(apply(inter.thres, 2, "%in%", j)))==TRUE )
        {
          mat[j[2], j[1]] <- -2
          flag <- 1
        }
    }
}


png(file=outFile, width=1600, height=1600)
if(flag==0)
  {
    heatmap.2(mat, Rowv=FALSE, Colv=FALSE, col=c("blue","black","red"), scale="none", dendrogram="none", trace="none", key=FALSE, keysize=0.3)
  }
if(flag==1)
  {
    heatmap.2(mat, Rowv=FALSE, Colv=FALSE, col=c("green","blue","black","red"), scale="none", dendrogram="none", trace="none", key=FALSE, keysize=0.3)
  }
dev.off()
