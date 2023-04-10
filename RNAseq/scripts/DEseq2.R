# Todo: Install Packages

#import library
library(ggplot2)
library(pheatmap)
library(optparse)

# BiocManager Packages
library(DESeq2)
library(ensembldb)
library(EnsDb.Mmusculus.v79)
library(EnhancedVolcano)
library(apeglm)
library(genefilter)

# Parse the input options
options <- list(
  make_option(c("-i", "--counts"), action="store", type="character",
              default=NA, help="Input file with read counts"),
  make_option(c("-d", "--design"), action="store", type="character",
              default=NA, help="Input file with design matrix"),
  make_option(c("-o", "--output"), action="store", type="character",
              default="DESeq2_results.txt", help="Output file"),
  make_option(c("-a", "--alpha"), action="store", type="numeric",
              default=0.05, help="Threshold for adjusted p-value"),
  make_option(c("-m", "--min"), action="store", type="numeric",
              default=10, help="Threshold for minimum count sum of a gene"),
  make_option(c("-r", "--ref"), action="store", type="character",
              default="Control", help="Reference condition for differential expression analysis")
)

opt_parser <- OptionParser(option_list=options)
opt <- parse_args(opt_parser)

# Read the count data file
counts_data <- as.matrix(read.csv(file=opt$counts, sep='\t', row.names='Transcript'))
colnames(counts_data) <- gsub("\\.", "-", colnames(counts_data))


# Read the design matrix file
design_matrix <- read.csv(file=opt$design,sep='\t', header=TRUE, row.names=1)
design_matrix$condition <- as.factor(design_matrix$condition)

# sort column data based on design matrix
counts_data <- counts_data[, row.names(design_matrix)]


# Check that the rownames of design and column names of counts match
stopifnot(all(rownames(design_matrix) %in% colnames(counts_data)))
stopifnot(all(rownames(design_matrix) == colnames(counts_data)))

# Create a DESeqDataSet object from the count data and design matrix
dds <- DESeqDataSetFromMatrix(countData = counts_data,
                              colData = design_matrix,
                              design = ~ condition,)

# Filter transcripts with low counts
dds <- dds[rowSums(counts(dds)) >= opt$min,]

# Set the reference condition
dds$condition <- relevel(dds$condition, ref=opt$ref)
dds$condition

# Run the differential expression analysis
des <- DESeq(dds)

#! Visualizations for sample variability
vsd <- vst(dds, blind = TRUE)

plotDists = function (vsd.obj) {
  sampleDists <- dist(t(assay(vsd.obj)))
  sampleDistMatrix <- as.matrix( sampleDists )
  rownames(sampleDistMatrix) <- paste( vsd.obj$condition )
  colors <- colorRampPalette( rev(RColorBrewer::brewer.pal(9, "Blues")) )(255)
  pheatmap::pheatmap(sampleDistMatrix,
                     clustering_distance_rows = sampleDists,
                     clustering_distance_cols = sampleDists,
                     annotation_col = design_matrix,
                     col = colors)
}
#! Visualizations for sample variability
png('sample_variability_plot.png',width=4, height=4, unit='in', res=300)
plotDists(vsd)
dev.off()

#! Plot PCA
png('pca_plot.png',width=8, height=4, unit='in', res=300)
plotPCA(vsd, intgroup = c("condition"))
dev.off()


# Extract the results
res <- results(des)

#! plot dispersion
png('dispersion_deseq2_plot.png',width=4, height=4, unit='in', res=300)
plotDispEsts(des)
dev.off()


# Extract the results
res <- results(des, alpha = opt$alpha)

#! Hist of FDR
use <- res$baseMean > metadata(res)$filterThreshold
h1 <- hist(res$pvalue[!use], breaks=0:50/50, plot=FALSE)
h2 <- hist(res$pvalue[use], breaks=0:50/50, plot=FALSE)
colori <- c(`do not pass`="khaki", `pass`="powderblue")



barplot(height = rbind(h1$counts, h2$counts), beside = FALSE,
        col = colori, space = 0, main = "", ylab="frequency")
text(x = c(0, length(h1$counts)), y = 0, label = paste(c(0,1)),
     adj = c(0.5,1.7), xpd=NA)
legend("topright", fill=rev(colori), legend=rev(names(colori)))

png('hist_fdr_plot.png',width=4, height=4, unit='in', res=300)
dev.off()

# summary
summary(res)


# Write the filtered results to a file
write.table(res, file=opt$output, sep="\t", quote=FALSE, row.names=TRUE)
