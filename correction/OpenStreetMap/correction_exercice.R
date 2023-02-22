########################################################################
####-------------------- OpenStreetMap & R ------------------------ ####
########################################################################


##--------------------------- PACKAGES -------------------------------##

# install.packages("tidygeocoder")
# install.packages("sf")
# install.packages("mapview")
# install.packages("maptiles")
# install.packages("osrm")





##---------------------- Géocodage adresse ---------------------------##

"LARESPD" "Université de Parakou, Bénin"

# Construction d'un data.frame avec nom et adresse
IRSP <- data.frame(name = "IRSP",
                   addresse = "Institut Régional de Santé Publique de Ouidah, Bénin")

# Géocodage de l'adresse à partir de la base de données OpenStreetMap
library(tidygeocoder)
IRSP_loc <- geocode(IRSP, addresse)





##----------------- Création d'un point (objet sf) ------------------##

library(sf)
IRSP_sf <- st_as_sf(IRSP_loc, coords = c("long", "lat"), crs = 4326)

# Transformation de la projection en Pseudo-Mercator (3857)
IRSP_sf <- st_transform(IRSP_sf, crs = 3857)





##----------- Visualisation du point - carte interactive ------------##

library(mapview)
mapview(IRSP_sf)





##----------------- Import des données Africapolis ------------------##

africapolis <- st_read("data/AFRICAPOLIS_2020/africapolis_extract.shp",  quiet = TRUE)

# Transformation de la projection en Pseudo-Mercator (3857)
africapolis <- st_transform(africapolis, crs =3857)






##------------- Sélection de agglomérations Béninoises --------------##

africapolis_ben <- africapolis[africapolis$ISO3 == "BEN", ]





##----------- Extraction des centroides d'agglomérations ------------##

africapolis_ben_pt <- st_centroid(africapolis_ben)






##-------------- Extraction de tuile OpenStreetMap -----------------##

library(maptiles)
osm_tiles <- get_tiles(x = st_buffer(africapolis_ben_pt, 30000) , zoom = 8, crop = TRUE)





##-------------------- Affichage des données -----------------------##
plot_tiles(osm_tiles)
plot(st_geometry(africapolis_ben_pt), border = NA, col="blue" , cex = 2, pch = 20, add = TRUE)
plot(st_geometry(IRSP_sf), border = NA, col="red" , cex = 3, pch = 20, add = TRUE)
mtext(side = 1, line = -1, text = get_credit("OpenStreetMap"), col="tomato")





##--------------- Calcul de matrice de distance --------------------##



#------------------- Distance Euclidienne ---------------------------#

mat_eucli_km <- st_distance(x = IRSP_sf, y = africapolis_ben_pt)/1000

# Changement nom de ligne et de colonne
rownames(mat_eucli_km) <- IRSP_sf$name
colnames(mat_eucli_km) <- africapolis_ben_pt$agglosName






#---------------- Distance et temps par la route  -------------------#

library(osrm)
dist <- osrmTable(src = IRSP_sf, 
                  dst = africapolis_ben_pt,
                  measure = c("distance", "duration"))
                  

# Stockage des résultats dans deux matrices différentes :

# Conversion des distances en Km
mat_route_km <- as.matrix(dist$distances) / 1000

# Conversion du temps de trajet en heure
mat_route_hr <- as.matrix(dist$durations) / 60





#------ Ajout des valeurs comme attributs des agglomérations ---------#

africapolis_ben_pt$IRSP_eucli_dist <- as.numeric(mat_eucli_km)
africapolis_ben_pt$IRSP_route_km <- as.numeric(mat_route_km)
africapolis_ben_pt$IRSP_route_hr <- as.numeric(mat_route_hr)






#------------------ Calcul indice d'accessibilité  -------------------#

mean(africapolis_ben_pt$IRSP_eucli_dist)
max(africapolis_ben_pt$IRSP_eucli_dist)

mean(africapolis_ben_pt$IRSP_route_km)
max(africapolis_ben_pt$IRSP_route_km)

mean(africapolis_ben_pt$IRSP_route_hr)
max(africapolis_ben_pt$IRSP_route_hr)






#------------------ Calcul indice de performance ---------------------#

# Indice de sinuosité # Plus c'est bas plus c'est direct
africapolis_ben_pt$ind_sinuo <- round(africapolis_ben_pt$IRSP_route_km / africapolis_ben_pt$IRSP_eucli_dist, 2)

# Indice de vitesse sur route # Plus c'est haut plus c'est rapide
africapolis_ben_pt$ind_speed <- round(africapolis_ben_pt$IRSP_route_km / africapolis_ben_pt$IRSP_route_hr, 1)

# Indice global de performance # Plus c'est haut plus c'est bien
africapolis_ben_pt$ind_perf <- round(africapolis_ben_pt$ind_speed / africapolis_ben_pt$ind_sinuo, 1)







#------------- Cartographie des indices de performance ---------------#

library(mapsf)
plot_tiles(osm_tiles)


mf_map(x = africapolis_ben_pt,
       var = "ind_perf",
       type = "choro",
       col = "brown4",
       leg_pos = "bottomleft2",
       leg_title = "Nombre d'habitants (en millions)",
       breaks = "jenks",
       nbreaks = 5,
       leg_val_rnd = 0,
       border=NA,
       cex = 2,
       add = TRUE)


Itinéraire premier du classement 
winner_city <- africapolis_ben_pt[africapolis_ben_pt$Ind_performance == max(africapolis_ben_pt$Ind_performance),]
route <- osrmRoute(src = IRSP_sf[1,], 
                   dst = winner_city )

plot_tiles(osm_tiles)
plot(st_geometry(route), col = "grey10", lwd = 6, add = T)
plot(st_geometry(route), col = "grey90", lwd = 1, add = T)


# mat_dist_eucli <- units::drop_units(mat_dist_eucli)

plot(st_geometry(IRSP_sf[1,]), border = "red", col="red" , lwd = 10, pch = 20, add = TRUE)
mtext(side = 1, line = -1, text = get_credit("OpenStreetMap"), col="tomato")

row.names(mat_dist_eucli) <- IRSP_sf$name
colnames(mat_dist_eucli, do.NULL =FALSE)<- africapolis$agglosName


1. adresse ouidah - Création table

2. Géocodage

3. Mapview

3. Extraction tuile OSM et mapssf

4. Matrice de distance sf entre IRSP et AFRICAPOLIS centroide


5. Pareil avec osrm


6. Calcul d'itinéraire du plus long chemin.
)




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

