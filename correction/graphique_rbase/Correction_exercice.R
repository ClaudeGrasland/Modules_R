######################################################
####--------- EXERCICE GRAPHIQUE R-BASE --------- ####
######################################################


##------------- Import des données------------------##

data <- read.csv2(file = "data/DEV_AFRICA_2018/afrika_don.csv")




##----------- Paramétrage fenêtre graphique ---------##

par(bg = "cornsilk3")



##------------  Histogramme variable 'POP'-----------##

hist(data$POP, 
     breaks  = quantile(data$POP),
     col = "green4",
     border = "white",
     xlab = "Nombre d'habitants (millions)", 
     ylab = "Proportion", 
     main = "Répartition des pays africains selon leur population")

# Ajout de marques pour chaque individus (axe des abscisses)
rug(data$POP)

# Ajout de la source des données
mtext(side = 4, "source : UN, 2020", cex = 0.8)



##------------------- Export en PNG ------------------##

dev.print(device = png, file = "mon_graphique.png", width = 600)

