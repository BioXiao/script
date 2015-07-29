#!/usr/bin/env Rscript

### Usage : plot_count_mrna_05122012_normDeSeq_byRepBSex.r rnaID sortie

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=2)
  {
    cat("Erreur :\nUsage : plot_count_mrna_05122012_normDeSeq_byRepBSex.r rnaID sortie\n")
    quit()
  }



name <- arg[1]
out  <- arg[2]

normdata.pcr <- read.table(file="~/travail/donnees/donnees_original/analyse_dif/arn/count_mrna_05122012_normDeSeq.txt", sep="\t", header=TRUE)

id    <- which(rownames(normdata.pcr)==name)
titre <- paste("nom : ", name, sep="")
count <- normdata.pcr[id,]

newCount <- unlist(c(rowMeans(count[1:6]),
                     count[7:9],
                     count[10:12],
                     count[13:15],
                     rowMeans(count[16:21]),
                     count[22:24],
                     count[25:27],
                     count[28:30]))

newSex  <- c(rep("A",10), rep("K",10))
newRepB <- rep( c(0, rep(c(1,2,3),3)), 2)

png(file=out, width=800, height=800)
yLim=c(min(newCount), max(newCount))
  plot(c(0,1,2,3), newCount[(newRepB==1 | newRepB==0) & newSex=="A"], type="b", pch=16, col="blue", lwd=3, cex=2, cex.main=1.5, cex.lab=1.5, cex.axis=1.5, xlim=c(-1,3), ylim=yLim, main=titre, xlab="temps", ylab="reads")
points(c(0,1,2,3), newCount[(newRepB==2 | newRepB==0) & newSex=="A"], type="b", pch=17, col="blue", lwd=3, cex=2)
points(c(0,1,2,3), newCount[(newRepB==3 | newRepB==0) & newSex=="A"], type="b", pch=18, col="blue", lwd=3, cex=2)
points(c(0,1,2,3), newCount[(newRepB==1 | newRepB==0) & newSex=="K"], type="b", pch=16, col="red", lwd=3, cex=2)
points(c(0,1,2,3), newCount[(newRepB==2 | newRepB==0) & newSex=="K"], type="b", pch=17, col="red", lwd=3, cex=2)
points(c(0,1,2,3), newCount[(newRepB==3 | newRepB==0) & newSex=="K"], type="b", pch=18, col="red", lwd=3, cex=2)
legend(x=-1, y=(yLim[2]-1), legend=c("sex","asex","bio1","bio2","bio3"), col=c("blue","red",rep("black",3)), pch=c(-1,-1,16,17,18), text.col=c("blue","red",rep("black",3)), cex=1.5, lwd=3)
dev.off()
