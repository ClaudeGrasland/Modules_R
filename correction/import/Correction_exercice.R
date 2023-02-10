#### EXERCICE IMPORT DE DONNEES ####


## 1) Import du fichier csv "afrika_don.csv"
data_csv <- read.csv2(file = "data/DEV_AFRICA_2018/afrika_don.csv")

## 2) Import du fichier xls "afrika_don.xls"
# install.packages("readxl")
library(readxl)
data_xls <- read_excel(path = "data/DEV_AFRICA_2018/afrika_don.xls")

## 3) Import du fichier shp "afrika_map.shp"
# install.packages("sf")
library(sf)
data_shp <- st_read("data/GADM_AFRICA_2020/afrika_map.shp",  quiet = TRUE)

## 4) Importer du fichier tif "elevation.tif"
# install.packages("terra")
library(terra)
data_tif <- rast("data/elevation.tif") 


