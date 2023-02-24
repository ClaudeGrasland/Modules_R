######################################################
####--------- MANIPULATION de data.frame -------- ####
######################################################



##------------- Import des données------------------##

# Tableau csv
data <- read.csv2(file = "data/DEV_AFRICA_2018/afrika_don.csv")

# ESRI shapefile (données géographiques)
library(sf)
basemap <- st_read("data/GADM_AFRICA_2020/afrika_map.shp",  quiet = TRUE)




##------------------ Jointure ---------------------##

# Clef de jointure : iso3
data_map <- merge(basemap, data, by="iso3", all.x = TRUE)




##-------------- Création colonne -----------------##

# Chaîne de caractère en Majuscule
data_map$NOM <- toupper(data_map$name.x)




##------------------ Sélection ---------------------##

# Lignes où LANGFR = 1
data_map_fr <- data_map[data_map$LANGFR == 1, ]




##------ Regroupement - Calcul moyenne PIB/Hab -----##

# Regroupement par la variable SUBREG et calcul de la moyenne du PIB par habitant
PIBhab_by_subreg <- aggregate(iso3 ~ SUBREG, 
                              data = data_map_fr, 
                              FUN = length)




##---------- Modification noms colonnes ------------##

# Changement des noms de colonnes
colnames(PIBhab_by_subreg) <- c("Sous-région", "Nb_pays_franco")

# Affichage du tableau dans la console
PIBhab_by_subreg


