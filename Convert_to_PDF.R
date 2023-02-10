library(quarto)

pth <- getwd()

quarto_render(paste0(pth,"/modules/import/import.qmd"), output_file = "import.pdf", output_format = "pdf")
# quarto_render(paste0(pth,"/modules/graphique/Rbase_graph.qmd"), output_file = "Rbase_graph.pdf", output_format = "pdf")
quarto_render(paste0(pth,"/modules/reproductibilite/minicran.qmd"), output_file = "miniCRAN.pdf", output_format = "pdf")




file <- "_site/modules/import"
list_files <- list.files(file, ".html")
file.copy( from = paste0(file,list_files)
           
           
           > to = "/Modules_R", list_files, "/Modules_R")


manip <- "_site/modules/manipulation"
list_files   <- c(list_files, list.files(manip, ".html"))
stat <- "_site/modules/statistique"
list_files   <- c(list_files, list.files(stat, ".html"))
graph <- "_site/modules/graphique"
list_files   <- c(list_files, list.files(graph, ".html"))
geo <- "_site/modules/geomatique"
list_files   <- c(list_files, list.files(geo, ".html"))
carto <- "_site/modules/cartographie"
list_files   <- c(list_files, list.files(carto, ".html"))
repro <- "_site/modules/reproductibilite"
list_files   <- c(list_files, list.files(repro, ".html"))


file.copy(list.of.files, new.folder)
