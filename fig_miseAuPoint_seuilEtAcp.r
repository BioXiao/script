#!/usr/bin/env Rscript

### Usage : fig_miseAuPoint_seuilEtAcp.r chemin_donne nom_donne1(ex:sup3Q_2001UTR) nom_donne2(ex:scoreMin_total) dossier_sortie

library(FactoMineR, quietly=TRUE)

### Valeur TRUE permet de n'avoir que les arguments d'interet
arg = commandArgs(TRUE)

if(length(arg)!=4)
  {
    cat("Erreur :\nUsage : fig_miseAuPoint_seuilEtAcp.r chemin_donne nom_donne1(ex:sup3Q_2001UTR) nom_donne2(ex:scoreMin_total) dossier_sortie max_targetscan max_pita max_miranda\n")
    quit()
  }

donne <- read.table(arg[1], header=TRUE)
if(dim(donne)[2]!=4)
  {
    cat("Erreur :\nPas le bon format en entrée")
  }
attach(donne)

nom1    <- arg[2]
nom2    <- arg[3]
sortie  <- arg[4]

if( substr( x=sortie, start=nchar(sortie), stop=nchar(sortie) ) != "/" )
  {
    sortie <- paste(sortie, "/", sep="")
  }

nomObtention <- paste("\nObtenue sur les données ", nom1, ", ", nom2, sep="")
nomACP       <- paste("ACP des coefficients et contribution des variables", nomObtention, sep="")
nomMT        <- paste("Valeurs des coefficients en fonctions des seuils de MiRanda et de TargetScan", nomObtention, sep="")
nomPM        <- paste("Valeurs des coefficients en fonctions des seuils de PITA et de MiRanda", nomObtention, sep="")
nomPT        <- paste("Valeurs des coefficients en fonctions des seuils de PITA et de TargetScan", nomObtention, sep="")

fichierACP <- paste(sortie, "acp_ind_coef_seuil_", nom2, ".jpeg", sep="")
fichierMT <- paste(sortie, "coef_en_fnt_seuil_miranda_targetscan_", nom2, ".jpeg", sep="")
fichierPM <- paste(sortie, "coef_en_fnt_seuil_pita_miranda_", nom2, ".jpeg", sep="")
fichierPT <- paste(sortie, "coef_en_fnt_seuil_pita_targetscan_", nom2, ".jpeg", sep="")

indMax <- which(donne[,1]==max(donne[,1]))
maxTS  <- donne[indMax,3]
maxPI  <- donne[indMax,2]
maxMI  <- donne[indMax,4]

donne.acp <- PCA(donne, graph=FALSE)

dim1    <- round(donne.acp$eig[1,2], 2)
nomDim1 <- paste("Dim 1 (", dim1, " %)", sep="")
dim2    <- round(donne.acp$eig[2,2], 2)
nomDim2 <- paste("Dim 2 (", dim2, " %)", sep="")

maxDim1 <- donne.acp$ind$coord[indMax,1]
maxDim2 <- donne.acp$ind$coord[indMax,2]

### Plot de l'ACP
cat("ACP\n")
jpeg(file=fichierACP, height=800, width=800)
pal <- colorRampPalette(c("lightgreen", "darkgreen", "darkblue", "lightblue", "violet", "violetred", "violetred1", "violetred2", "violetred3", "violetred4", "gold", "yellow", "darkred", "red"))
palette(pal(13))
plot(donne.acp$ind$coord[,1], donne.acp$ind$coord[,2], col=(floor(donne[,1]/100)+1), main=nomACP, xlab=nomDim1, ylab=nomDim2, lwd=1.5, xlim=c(-5,5), ylim=c(-5,5), cex.main=1.7, cex.lab=1.5, cex.axis=1.5)
abline(v=0, lty=2)
abline(h=0, lty=2)
segments(x0=0, y0=0, x1=donne.acp$var$coord[,1]*5, y1=donne.acp$var$coord[,2]*5, lwd=2.5)
text(donne.acp$var$coord[,1]*5+0.2, donne.acp$var$coord[,2]*5+0.25, label=c("coefficient", "PITA", "TargetScan", "MiRanda"), cex=1.5)
abline(h=maxDim2, col="red", lty=2)
abline(v=maxDim1, col="red", lty=2)
poubelle <- dev.off()

### Plot de MiRanda vs TargetScan
cat ("MiRanda vs TargetScan\n")
jpeg(file=fichierMT, height=800, width=800)
pal <- colorRampPalette(c("lightgreen", "darkgreen", "darkblue", "lightblue", "violet", "violetred", "violetred1", "violetred2", "violetred3", "violetred4", "gold", "yellow", "darkred", "red"))
palette(pal(13))
plot(seuilMiRanda, seuilTargetScan, col=(floor(coef/100)+1), main=nomMT, xlab="Seuil MiRanda", ylab="Seuil TargetScan", lwd=1.5, cex.main=1.7, cex.lab=1.5, cex.axis=1.5)
abline(h=maxTS, lty=2)
abline(v=maxMI, lty=2)
poubelle <- dev.off()

### Plot de PITA vs MiRanda
cat("PITA vs MiRanda\n")
jpeg(file=fichierPM, height=800, width=800)
pal <- colorRampPalette(c("lightgreen", "darkgreen", "darkblue", "lightblue", "violet", "violetred", "violetred1", "violetred2", "violetred3", "violetred4", "gold", "yellow", "darkred", "red"))
palette(pal(13))
plot(seuilPITA, seuilMiRanda, col=(floor(coef/100)+1), main=nomPM, xlab="Seuil PITA", ylab="Seuil MiRanda", lwd=1.5, cex.main=1.7, cex.lab=1.5, cex.axis=1.5)
abline(h=maxMI, lty=2)
abline(v=maxPI, lty=2)
poubelle <- dev.off()

### Plot de PITA vs TargetScan
cat("PITA vs TargetScan\n")
jpeg(file=fichierPT, height=800, width=800)
pal <- colorRampPalette(c("lightgreen", "darkgreen", "darkblue", "lightblue", "violet", "violetred", "violetred1", "violetred2", "violetred3", "violetred4", "gold", "yellow", "darkred", "red"))
palette(pal(13))
plot(seuilPITA, seuilTargetScan, col=(floor(coef/100)+1), main=nomPT, xlab="Seuil PITA", ylab="Seuil TargetScan", lwd=1.5, cex.main=1.7, cex.lab=1.5, cex.axis=1.5)
abline(h=maxTS, lty=2)
abline(v=maxPI, lty=2)
poubelle <- dev.off()
