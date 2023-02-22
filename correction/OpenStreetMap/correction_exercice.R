######################################################
####------------- OpenStreetMap & R ------------- ####
######################################################


##------------------ PACKAGES ----------------------##

# install.packages("tidygeocoder")
# install.packages("sf")
# install.packages("mapview")
# install.packages("maptiles")
# install.packages("osrm")



##------------------- Géocodage adresse -----------------------##


"Institut Régional de Santé Publique de Ouidah, Route des Esclaves, 01 BP 918 Cotonou, Bénin"

library(tidygeocoder)
Univ_benin <- data.frame(name = c("IRSP", "LARESPD"),
                         addresse = c("Institut Régional de Santé Publique de Ouidah, Bénin",
                                      "Université de Parakou, Bénin"))


Univ_benin_loc <- geocode(Univ_benin, addresse)
Univ_benin_loc

library(sf)
Univ_benin_sf <- st_as_sf(Univ_benin_loc, coords = c("long", "lat"), crs = 4326)
Univ_benin_sf

library(mapview)
mapview(Univ_benin_sf)

Univ_benin_sf <- st_transform(Univ_benin_sf, 3857)

library(maptiles)
osm_tiles <- get_tiles(x = st_buffer(Univ_benin_sf, 80000), zoom = 8, crop = TRUE)


plot_tiles(osm_tiles)
plot(st_geometry(Univ_benin_sf), border = "red", col="red" , lwd = 10, pch = 20, add = TRUE)
mtext(side = 1, line = -1, text = get_credit("OpenStreetMap"), col="tomato")


library(sf)
africapolis <- st_read("data/AFRICAPOLIS_2020/africapolis_extract.shp",  quiet = TRUE)

africapolis <- st_transform(africapolis, 3857)

africapolis_ben <- africapolis[africapolis$ISO3 == "BEN", ]
africapolis_ben_pt <- st_centroid(africapolis_ben)


mapview(africapolis_ben_pt)



mat_dist_eucli_km <- as.matrix(st_distance(x = Univ_benin_sf, y = africapolis_ben_pt))/1000
class(mat_dist_eucli_km)

rownames(mat_dist_eucli_km) <- Univ_benin_sf$name
colnames(mat_dist_eucli_km) <- africapolis_ben_pt$agglosName

View(mat_dist_eucli_km)





library(osrm)
dist <- osrmTable(src = Univ_benin_sf, 
                  dst = africapolis_ben_pt,
                  measure = c("distance", "duration"))
                  
dist$destinations
dist$sources
dist$durations

mat_dist_route_km <- as.matrix(dist$distances)/1000
mat_dist_route_hrs <- as.matrix(dist$durations)/60

## Indices accessibilité

# Accessibilité moyenne

mean(africapolis_ben_pt$dist_IRSP)
mean(africapolis_ben_pt$dist_LARESPD)

# Éloignement maximal

max(africapolis_ben_pt$dist_IRSP)
max(africapolis_ben_pt$dist_LARESPD)

## Indices de performance


# Indice de sinuosité
ind1<-mat_dist_route_km/mat_dist_eucli_km

moyenne<-apply(ind1,2,mean,na.rm=T)
ind1<-rbind(ind1,moyenne)
knitr::kable(ind1, digits=2, caption = "Indice de sinuosité ")

# Indice de vitesse sur route
mat_dist_route_hrs <- mat_dist_route_min / 60
ind2 <- mat_dist_route_km / mat_dist_route_hrs

moyenne<-apply(ind2,2,mean,na.rm=T)
ind2<-rbind(ind2,moyenne)

# Indice global de performance
ind3<-ind2/ind1




africapolis_ben_pt$dist_eucli_km_IRSP <- as.numeric(mat_dist_eucli_km[1,])
africapolis_ben_pt$dist_eucli_km_LARESPD <- as.numeric(mat_dist_eucli_km[2,])
africapolis_ben_pt$dist_route_km_IRSP <- as.numeric(mat_dist_route_km[1,])
africapolis_ben_pt$dist_route_km_LARESPD <- as.numeric(mat_dist_route_km[2,])
africapolis_ben_pt$dist_route_hrs_IRSP <- as.numeric(mat_dist_route_hrs[1,])
africapolis_ben_pt$dist_route_hrs_LARESPD <- as.numeric(mat_dist_route_hrs[2,])


africapolis_ben_pt$Ind_Sinuosite <- africapolis_ben_pt$dist_route_km_IRSP / africapolis_ben_pt$dist_eucli_km_IRSP
# Plus c'est bas plus c'est direct

africapolis_ben_pt$Ind_Vitesse <- africapolis_ben_pt$dist_route_km_IRSP / africapolis_ben_pt$dist_route_hrs_IRSP 
# Plus c'est haut plus c'est rapide

africapolis_ben_pt$Ind_performance <- africapolis_ben_pt$Ind_Vitesse / africapolis_ben_pt$Ind_Sinuosite 
# Plus c'est haut plus c'est bien

library(mapsf)
plot_tiles(osm_tiles)


mf_map(x = africapolis_ben_pt,
       var = "Ind_performance",
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
route <- osrmRoute(src = Univ_benin_sf[1,], 
                   dst = winner_city )

plot_tiles(osm_tiles)
plot(st_geometry(route), col = "grey10", lwd = 6, add = T)
plot(st_geometry(route), col = "grey90", lwd = 1, add = T)


# mat_dist_eucli <- units::drop_units(mat_dist_eucli)

plot(st_geometry(Univ_benin_sf[1,]), border = "red", col="red" , lwd = 10, pch = 20, add = TRUE)
mtext(side = 1, line = -1, text = get_credit("OpenStreetMap"), col="tomato")

row.names(mat_dist_eucli) <- Univ_benin_sf$name
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

