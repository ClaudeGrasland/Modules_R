
# IMPORT
file <- "_site/modules/import"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)
       
# MANIPULATION
file <- "_site/modules/manipulation"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)

# STATISTIQUE
file <- "_site/modules/statistique"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)

# GRAPHIQUE
file <- "_site/modules/graphique"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)

# GEOMATIQUE
file <- "_site/modules/geomatique"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)

# CARTOGRAPHIE
file <- "_site/modules/cartographie"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)

# REPRODUCTIBILITE
file <- "_site/modules/reproductibilite"
list_files <- list.files(file, ".html")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)

# CSS
file <- "./"
list_files <- list.files(file, ".css")
file.copy(from = file.path(file,list_files), to = paste0("Modules_R/", list_files), overwrite = TRUE)


# library(quarto)
# pth <- getwd()
# quarto_render(paste0(pth,"/modules/import/import.qmd"), output_file = "import.pdf", output_format = "pdf")
# # quarto_render(paste0(pth,"/modules/graphique/Rbase_graph.qmd"), output_file = "Rbase_graph.pdf", output_format = "pdf")
# quarto_render(paste0(pth,"/modules/reproductibilite/minicran.qmd"), output_file = "miniCRAN.pdf", output_format = "pdf")