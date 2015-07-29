#!/usr/bin/env Rscript

### Usage : plot_count_mirna_21102013_normDeSeq_byRepBSex.r sequence sortie

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=2)
  {
    cat("Erreur :\nUsage : plot_count_mirna_21102013_normDeSeq_byRepBSex.r sequence sortie\n")
    quit()
  }

mi  <- arg[1]
out <- arg[2]

normdata.pcr <- read.table(file="~/travail/donnees/donnees_original/mirna_21102013/count_mirna_21102013_normDeSeq.txt", sep="\t", header=TRUE)


### Si dans la séquence du miARN il y a des U, change en T
mi <- gsub(pattern="u", replacement="t", x=mi)


id    <- which(rownames(normdata.pcr)==mi)
titre <- paste("nom : ", mi, sep="")
count <- normdata.pcr[id,]

newCount <- NULL
for(i in 1:24)
{
  sup <- i*3
  inf <- sup-2
  newCount <- c(newCount, rowMeans(count[inf:sup]))
}

newRepB <- rep(c(1,2,3),8)
newSex  <- c(rep("A",12), rep("K",12))

png(file=out, width=800, height=800)
yLim=c(min(newCount), max(newCount))
  plot(c(0,1,2,3), newCount[newRepB==1 & newSex=="A"], type="b", pch=16, col="blue", lwd=3, cex=2, cex.main=1.5, cex.lab=1.5, cex.axis=1.5, xlim=c(-1,3), ylim=yLim, main=titre, xlab="temps", ylab="reads")
points(c(0,1,2,3), newCount[newRepB==2 & newSex=="A"], type="b", pch=17, col="blue", lwd=3, cex=2)
points(c(0,1,2,3), newCount[newRepB==3 & newSex=="A"], type="b", pch=18, col="blue", lwd=3, cex=2)
points(c(0,1,2,3), newCount[newRepB==1 & newSex=="K"], type="b", pch=16, col="red", lwd=3, cex=2)
points(c(0,1,2,3), newCount[newRepB==2 & newSex=="K"], type="b", pch=17, col="red", lwd=3, cex=2)
points(c(0,1,2,3), newCount[newRepB==3 & newSex=="K"], type="b", pch=18, col="red", lwd=3, cex=2)
legend(x=-1, y=(yLim[2]-1), legend=c("sex","asex","bio1","bio2","bio3"), col=c("blue","red",rep("black",3)), pch=c(-1,-1,16,17,18), text.col=c("blue","red",rep("black",3)), cex=1.5, lwd=3)
dev.off()
