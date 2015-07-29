#!/usr/bin/env Rscript

### Usage : fig2_miseAuPoint_seuilEtAcp.r chemin_donne nom_donne1(ex:sup3Q_2001UTR) nom_donne2(ex:scoreMin_total) dossier_sortie methode1 methode2

library(FactoMineR, quietly=TRUE)

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=6)
  {
    cat("Erreur :\nUsage : fig2_miseAuPoint_seuilEtAcp.r chemin_donne nom_donne1(ex:sup3Q_2001UTR) nom_donne2(ex:scoreMin_total) dossier_sortie methode1 methode2\n")
    quit()
  }

donne <- read.table(arg[1], header=TRUE)
if(dim(donne)[2]!=3)
  {
    cat("Erreur :\nPas le bon format en entrée")
    quit()
  }
attach(donne)

nom1    <- arg[2]
nom2    <- arg[3]
sortie  <- arg[4]
meth1   <- arg[5]
meth2   <- arg[6]


if( substr( x=sortie, start=nchar(sortie), stop=nchar(sortie) ) != "/" )
  {
    sortie <- paste(sortie, "/", sep="")
  }

nomObtention <- paste("\nObtenue sur les données ", nom1, ", ", nom2, sep="")
nomACP       <- paste("ACP des taux de recouvrement et contribution des variables ", meth1, " et ", meth2, nomObtention, sep="")
nomS         <- paste("Valeurs des taux de recouvrement en fonctions des seuils de ", meth1, " et de ", meth2, nomObtention, sep="")

fichierACP <- paste(sortie, "acp_ind_coef_seuil_", meth1, "_", meth2, "_", nom2, ".jpeg", sep="")
fichierS   <- paste(sortie, "coef_en_fnt_seuil_", meth1, "_", meth2, "_", nom2, ".jpeg", sep="")

indMax <- which(donne[,1]==max(donne[,1]))
max1   <- donne[indMax,2]
max2   <- donne[indMax,3]

donne.acp <- PCA(donne, graph=FALSE)

dim1    <- round(donne.acp$eig[1,2], 2)
nomDim1 <- paste("Dim 1 (", dim1, " %)", sep="")
dim2    <- round(donne.acp$eig[2,2], 2)
nomDim2 <- paste("Dim 2 (", dim2, " %)", sep="")

maxDim1 <- donne.acp$ind$coord[indMax,1]
maxDim2 <- donne.acp$ind$coord[indMax,2]

nbrcolor <- max(unique((floor(donne[,1]/100)+1)))

### Plot de l'ACP
cat("ACP\n")
jpeg(file=fichierACP, height=800, width=800)
pal <- colorRampPalette(c("lightgreen", "darkgreen", "darkblue", "lightblue", "violet", "violetred", "violetred1", "violetred2", "violetred3", "violetred4", "gold", "yellow", "darkred", "red"))
palette(pal(nbrcolor))
plot(donne.acp$ind$coord[,1], donne.acp$ind$coord[,2], col=(floor(donne[,1]/100)+1), main=nomACP, xlab=nomDim1, ylab=nomDim2, lwd=1.5, xlim=c(-5,5), ylim=c(-5,5), cex.main=1.7, cex.lab=1.5, cex.axis=1.5)
abline(v=0, lty=2)
abline(h=0, lty=2)
segments(x0=0, y0=0, x1=donne.acp$var$coord[,1]*5, y1=donne.acp$var$coord[,2]*5, lwd=2.5)
text(donne.acp$var$coord[,1]*5+0.2, donne.acp$var$coord[,2]*5+0.25, label=c("taux de recouvrement", meth1, meth2), cex=1.5)
abline(h=maxDim2, col="red", lty=2)
abline(v=maxDim1, col="red", lty=2)
poubelle <- dev.off()

### Plot de methode1 vs methode2
cat ("Seuil 1 vs Seuil 2\n")
jpeg(file=fichierS, height=800, width=800)
pal <- colorRampPalette(c("lightgreen", "darkgreen", "darkblue", "lightblue", "violet", "violetred", "violetred1", "violetred2", "violetred3", "violetred4", "gold", "yellow", "darkred", "red"))
palette(pal(nbrcolor))
plot(seuil1, seuil2, col=(floor(coef/100)+1), main=nomS, xlab=paste("Seuil", meth1), ylab=paste("Seuil", meth2), lwd=1.5, cex.main=1.7, cex.lab=1.5, cex.axis=1.5)
abline(h=max2, lty=2)
abline(v=max1, lty=2)
poubelle <- dev.off()
