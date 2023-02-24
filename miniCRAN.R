path_miniCRAN <- "/home/hugues/Documents/5.Cours/Modules_R/miniCRAN"
path_miniCRAN <- "/home/hugues/Bureau/Modules_R/miniCRAN"

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
              "maptiles",
              "osmdata",
              "osmextract",
              "tidygeocoder",
              "tanaka",
              "leaflet", 
              "mapview",
              "rayshader",
              "cartogram",
              "ggmap",
              "ggspatial",
              "tmap",
              "MTA",
              "osrm", 
              "linemap",
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
              "miniCRAN",
              "car",
              "RColorBrewer",
              "reshape2",
              "htmlwidgets",
              "ipumsr",
              "kableExtra",
              "GGally",
              "stargazer",
              "gt",
              "readstata13",
              "rio", 
              "summarytools", 
              "DescTools",
              "Factoshiny",
              "explor", 
              "foreign",
              "lme4", 
              "Rcmdr", 
              "nloptr", 
              "readr",
              "xfun", 
              "DBI", 
              "readxl",
              "geosphere",
              "rgeos", 
              "factoextra", 
              "RSQLite",
              "flexdashboard",
              "caret",
              "randomForest",
              "forcats",  
              "proj4",
              "tidytext",
              "viridis", 
              "sfnetworks",
              "rmapshaper", 
              "cartography", 
              "remotes",
              "xlsx",
              "tinytex", 
              "curl")


# ttt
# tinytext latex
# rayvista




library(miniCRAN)
# Téléchargement des sources des packages (+ dépendances) dans le répertoire "miniCRAN"
makeRepo(pkgDep(mes_pkgs), path = path_miniCRAN, type = c("source", "mac.binary", "win.binary"), writePACKAGES = TRUE)


mes_pkgs <- c()

makeRepo(pkgDep(mes_pkgs), path = path_miniCRAN, type = c("source", "mac.binary", "win.binary"), writePACKAGES = TRUE)



