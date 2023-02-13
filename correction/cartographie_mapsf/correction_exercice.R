#### EXERCICE CARTOGRAPHIE avec mapsf ####


##--------------------##  
## Import des données ##
##--------------------##

# Tableau csv
data <- read.csv2(file = "data/DEV_AFRICA_2018/afrika_don.csv")

# ESRI shapefile (données géographiques)
library(sf)
basemap <- st_read("data/GADM_AFRICA_2020/afrika_map.shp",  quiet = TRUE)


##----------##
## Jointure ##
##----------##

# R-base
data_map <- merge(basemap, data, by="iso3", all.x = TRUE)

# OU avec le package dplyr
library(dplyr)
data_map <-left_join(basemap, data, by = "iso3")



##----------------------------------##  
## Carte en symboles proportionnels ##
##----------------------------------##

library(mapsf)

# Initialisation de l'export de la carte (format svg)
mf_export(data_map, "Population_in_Afica_2020.svg", width = 7)

# Utilisation du thème darkula
mf_theme("darkula")

# Affichage du fond de carte (pays africains)
mf_map(data_map, col = "grey70", border = "black", lwd = 0.2)

# Affichage de cercles proportionnels (nombre d'habitants)
mf_map(x = data_map,
       var = "POP",
       symbol = "circle",
       type = "prop",
       inches = 0.40,
       col = "brown4",
       border = "white",
       lwd = 0.5,
       leg_pos = "bottomleft2",
       leg_title = "Nombre d'habitants (en millions)", 
       add = TRUE)

# Ajout d'un titre et des sources
mf_layout(title = "Répartition de la population en Afrique, 2020",
          credits = paste0("Sources: Human Development Report 2020\n",
                           "mapsf ", 
                           packageVersion("mapsf")))

# Enregistrement du fichier svg
dev.off()



##-------------------------------##  
## Carte choroplèthe avec Export ##
##-------------------------------##

# Visualisation de la forme de la distribution de la variable "INTERN" 
hist(data_map$INTERN)

# Initialisation de l'export de la carte
mf_export(data_map, "Internet_users_in_Afica_2020.png", width = 700)

# Utilisation du thème jsk
mf_theme("jsk")

# Initialisation d'une carte centré sur la couche géographique "data_map" (pays d'Afrique)
mf_init(x = data_map)

# Ajour d'un effet d'ombrage pour la couche "data_map"
mf_shadow(data_map, add = TRUE)

# Ajout d'un aplat de couleur en fonction de la valeur de "INTERN"
mf_map(x = data_map,
       var = "INTERN",
       type = "choro",
       breaks = "quantile",  # Discrétisation par quantiles
       nbreaks = 6,          # En 6 classes
       pal = "Greens",       # Palette de couleur verte
       leg_val_rnd = 1, 
       border = "grey50",
       lwd = 0.5,
       col_na = "grey80",
       leg_pos = "topright",
       leg_title = "Part des utilisateurs (%)",
       add = TRUE)

# Ajout d'étiquettes pour chaque pays
mf_label(x = data_map, 
         var = "name.x", 
         col = "grey10", 
         cex = 0.5,
         overlap = FALSE,          
         bg = "white",
         halo = TRUE, 
         lines = FALSE)

# Ajout d'un titre et des sources
mf_layout(title = "L'utilisation d'internet en Afrique, 2020",
          credits = paste0("Sources: Human Development Report 2020\n",
                           "mapsf ",
                           packageVersion("mapsf")))

# Enregistrement du fichier png
dev.off()
