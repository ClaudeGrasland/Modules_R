library(quarto)

pth <- getwd()

quarto_render(paste0(pth,"/modules/import/import.qmd"), output_file = "import.pdf", output_format = "pdf")
# quarto_render(paste0(pth,"/modules/graphique/Rbase_graph.qmd"), output_file = "Rbase_graph.pdf", output_format = "pdf")
quarto_render(paste0(pth,"/modules/reproductibilite/minicran.qmd"), output_file = "miniCRAN.pdf", output_format = "pdf")
