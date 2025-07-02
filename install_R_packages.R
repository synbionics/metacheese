install.packages(c(
  "optparse", "ggplot2", "dplyr", "reshape2", "tidyr", "scales"
), repos = "https://cloud.r-project.org")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos = "https://cloud.r-project.org")

BiocManager::install(c("phyloseq", "microbiome", "vegan", "ade4"))
