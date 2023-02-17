#### EXERCICE GEOMATIQUE avec R ####


##--------------------##  
## Import des données ##
##--------------------##

# Import du fond de carte pays
library(sf)
pays <- st_read("data/GADM_AFRICA_2020/afrika_map.shp",  quiet = TRUE)

# Import des données AFRICAPOLIS
africapolis <- st_read("data/AFRICAPOLIS_2020/africapolis_extract.shp",  quiet = TRUE)


##---------------------------------------------##  
## Contrôle et transformation de la projection ##
##---------------------------------------------##

# Connaitre le système de référence et de projection d'une couche
st_crs(pays)
st_crs(africapolis)

# Transformation de la projection d'une couche 
# Pays == africapolis
pays <- st_transform(pays, crs = st_crs(africapolis))


##-------------------------------------##  
## création d'une couche de centroïdes ##
##-------------------------------------##

# Correction de la topologie des polygones
africapolis <- st_make_valid(africapolis)

# Extraction des centroïdes (création d'une couche géographique ponctuelle)
africapolis_centre <- st_centroid(africapolis)



##------------------------------------##
## Création d'une couche géographique ##
##------------------------------------##

# Création d'un data.frame avec une colonne latitude et longitude
djegba_hotel <- data.frame(name = "Hotel Djegba", 
                           lat = 2.080248682100427, 
                           long = 6.323648667935729)

# Création d'un couche géographique à partir de ces cordonnées
djegba_hotel_geo <- st_as_sf(djegba_hotel, 
                             coords = c("lat", "long"), 
                             crs = 4326)


##----------------------------------##
## Affichage intéractif des couches ##
##----------------------------------##

# Affichage interactif du point sur le fond de carte OpenStreetMap
library(mapview)
mapview(pays) +
  mapview(africapolis) + 
  mapview(africapolis_centre ) + 
  mapview(djegba_hotel_geo) 




# pays_GTB <- pays[pays$iso3 %in% c("GHA", "TGO", "BEN"), ] 

africapolis$sup_urb <- st_area(africapolis)


library(dplyr)
surf_agglo_by_pays <- africapolis %>% 
                          group_by(ISO3) %>% 
                          summarise(sup_urb = sum(sup_urb))



pays$sup_pays <- st_area(pays)


surf_agglo_by_pays <-merge(surf_agglo_by_pays, st_drop_geometry(pays),by.x="ISO3", by.y="iso3")

surf_agglo_by_pays$part_urb <- round(surf_agglo_by_pays$sup_urb / surf_agglo_by_pays$sup_pays * 100, 2)

surf_agglo_by_pays[surf_agglo_by_pays$part_urb == max(surf_agglo_by_pays$part_urb), ]

intersection<- st_intersection(pays, africapolis)

st_crs(africapolis)

