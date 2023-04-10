packages_to_install <- c("ggplot2", "pheatmap", "optparse")

for (package in packages_to_install) {
  tryCatch({
    library(package, character.only = TRUE)
  },
  error = function(e) {
    if (!require(package, character.only = TRUE)) {
      install.packages(package, dependencies = TRUE, repos='http://cran.us.r-project.org', type='source', update = FALSE)
    }
    library(package, character.only = TRUE)
  })
}

packages_to_install <- c("DESeq2", "ensembldb", "EnsDb.Mmusculus.v79", "EnhancedVolcano", "apeglm", "genefilter")

if (!require("BiocManager", character.only = TRUE)) {
  install.packages("BiocManager", dependencies = TRUE, repos='http://cran.us.r-project.org', type='source', update = FALSE)
}
library("BiocManager", character.only = TRUE)

for (package in packages_to_install) {
  tryCatch({
    library(package, character.only = TRUE)
  },
  error = function(e) {
    if (!require(package, character.only = TRUE)) {
      BiocManager::install(package, dependencies = TRUE, type='source', update = FALSE)
    }
    library(package, character.only = TRUE)
  })
}

