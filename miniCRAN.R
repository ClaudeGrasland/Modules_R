path_miniCRAN <- "/home/hugues/Documents/5.Cours/Modules_R/miniCRAN"
path_miniCRAN <- "C:/Users/HP/Documents/Modules_R"

# Création du répertoire nommé "miniCRAN"
dir.create(path = path_miniCRAN)



# Création d'un vecteur avec le ou les package(s) ciblé(s)
mes_pkgs <- c("data.table", 
              "tidyverse",
              "openxlsx",
              "ggplot2", 
              "dplyr", 
              "tidyr", 
              "haven", 
              "lubridate", 
              "stringr",
              "sf",
              "raster",
              "terra",
              "stars",
              "mapsf",
              "tanaka",
              "leaflet", 
              "tmap",
              "MTA",
              "osrm", 
              "maptiles",
              "rmarkdown",
              "revealjs",
              "knitr", 
              "kableExtra",
              "DT",
              "shiny",
              "gtsummary",
              "igraph",
              "xaringan",
              "FactoMineR",               
              "factoextra",
              "car", 
              "spatstat", 
              "maptools", 
              "questionr", 
              "esquisse",
              "survey",
              "quanteda",
              "reticulate",
              "htmltools",
              "tinytex",
              "miniCRAN")


library(miniCRAN)
# Téléchargement des sources des packages (+ dépendances) dans le répertoire "miniCRAN"
makeRepo(pkgDep(mes_pkgs), path = path_miniCRAN, type = c("source", "mac.binary", "win.binary"), writePACKAGES = TRUE)
