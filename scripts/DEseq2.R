library(DESeq2)
library(pheatmap)
library(RColorBrewer)
library(ggplot2)
library(EnhancedVolcano)


counts <- as.matrix(read.csv('./all_counts.tsv', sep='\t', row.names='TranscriptID'))
counts
col_data <- read.csv('design.txt', sep='\t', row.names=1)
col_data
