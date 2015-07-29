#!/usr/bin/env Rscript

### Usage : getImageFromOptOneNeigh.r rOrderFile cOrderFile interactionFile thresold outFile

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg <- commandArgs(TRUE)

if(length(arg)!=5)
{
  print("Pas le bon nombre d'arguments :\nUsage : getImageFromOptOneNeigh.r rOrderFile cOrderFile interactionFile thresold outFile\n")
  quit()
}

library(bitops, quietly=TRUE, verbose=FALSE)
library(gdata,  quietly=TRUE, verbose=FALSE)
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
outFile <- arg[5]
rorder  <- read.table(nrOrder)
corder  <- read.table(ncOrder)
inter   <- read.table(ninter)

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


png(file=outFile, width=1600, height=1600)
heatmap.2(mat, Rowv=FALSE, Colv=FALSE, col=c("black","red"), scale="none", dendrogram="none", trace="none", key=FALSE, keysize=0.3)
dev.off()
