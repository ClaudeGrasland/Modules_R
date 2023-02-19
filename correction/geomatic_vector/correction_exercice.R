######################################################
####--------- EXERCICE GEOMATIQUE avec R--------- ####
######################################################


##------------------ PACKAGES ----------------------##

# install.packages("sf")
# install.packages("mapview")
# install.packages("dplyr")



##------------------- IMPORT -----------------------##

library(sf)
africapolis <- st_read("data/AFRICAPOLIS_2020/africapolis_extract.shp",  quiet = TRUE)





##---------- Contrôle CRS et reprojection ----------##  

# Connaitre le système de référence et de projection d'une couche
st_crs(africapolis)
 
# Reprojection en UTM zone 31N
africapolis <- st_transform(africapolis, crs = 32631)




##------------ Affichage de la couche --------------##


# Affichage de la geometrie
plot(st_geometry(africapolis))


# Affichage sur un fond de carte dynamique
library(mapview)
mapview(africapolis)





##--------------- Calcul de surface ----------------##


# Calcul des surface (dans l'unité du crs)
africapolis$superficie <- st_area(africapolis)





##------ Regroupement - calcul surface totale ------##

library(dplyr)

Surf_tot <- africapolis %>% 
                group_by(ISO3) %>% 
                summarise(superficie_tot = sum(superficie),
                          nb_agglo = n())

# Affichage du résultat
View(Surf_tot)





##----- Création d'une couche géographique (sf) -----##


# Création d'un data.frame avec une colonne latitude et longitude
IRSP <- data.frame(name = "Institut Régional de Santé Publique", 
                   lat = 2.0879482065861783, 
                   long =  6.349223507626634)

# Création d'un couche géographique à partir de ces cordonnées
IRSP_geo <- st_as_sf(IRSP, 
                     coords = c("lat", "long"), 
                     crs = 4326)


# Reprojection en UTM zone 31N
IRSP_geo <- st_transform(IRSP_geo, crs = 32631)





##----------- Création d'une zone tampon ------------##

# Zone dtampon de 50000 métres
IRSP_buff_50km <- st_buffer(x = IRSP_geo, dist = 50000)






##--------------- Sélection spatiale ----------------##

# Quelles agglomérations intersectent la zone tampon ?
africapolis$in_buffer <- st_intersects(africapolis, IRSP_buff_50km, sparse = FALSE)





##--------------- Affichage des couches -------------##

plot(st_geometry(IRSP_buff_50km), col = NA)
plot(africapolis["in_buffer"],border = NA, add = TRUE)
plot(st_geometry(IRSP_geo), col="red", pch = 20, cex = 1.5, add = TRUE)
plot(st_geometry(IRSP_buff_50km),  border = "red", lwd = 2, add = TRUE)






##-- Nombre d'habitants dans les proches agglomérations ---##

# Sélection des agglomérations qui intersectent la zone tampon
africapolis_in_buff <- africapolis[africapolis$in_buffer == TRUE, ]

# Calcul de la population totale de ces agglomérations
sum(africapolis_in_buff$Pop2015)

