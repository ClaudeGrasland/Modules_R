path_miniCRAN <- "/home/hugues/Documents/5.Cours/Modules_R/miniCRAN"

# Création du répertoire nommé "miniCRAN"
dir.create(path = path_miniCRAN)



# Création d'un vecteur avec le ou les package(s) ciblé(s)
mes_pkgs <- c("openxlsx", "haven", "maptiles",
              "lubridate", "stringr","FactoMineR", "sf",
              "terra", "mapsf", "rmarkdown", "knitr", 
              "data.table", "leaflet", "tidyverse", 
              "factoextra", "miniCRAN", "osrm")


library(miniCRAN)
# Téléchargement des sources des packages (+ dépendances) dans le répertoire "miniCRAN"
makeRepo(pkgDep(mes_pkgs), path = path_miniCRAN, type = c("source", "mac.binary", "win.binary"))
