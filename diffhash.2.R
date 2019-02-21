df <- read.delim("DataFrame")

n <- nrow(df)

print(n)

## ------------------------------------------------------------------------
sim_rep_info <- read.delim("sim_rep_info.txt")
hashcounts <- read.delim("hashcounts.tsv", header=FALSE, row.names=1)

## ------------------------------------------------------------------------
design <- cbind(rep(1, n), c(rep(0,n/2), rep(1,n/2))) ## needs to be generalized
colnames(design) <- c("C", "CvsT")

## ------------------------------------------------------------------------
library(edgeR)
dge <- DGEList(counts=hashcounts)
logCPM <- cpm(dge, log=TRUE, prior.count=3)
fit <- lmFit(logCPM, design)
fit <- eBayes(fit, trend=TRUE)
topTable(fit, coef=ncol(design))

## ------------------------------------------------------------------------
testresults <- decideTests(fit[,2]$p.value, adjust.method = "fdr")
sum(testresults != 0)

## ------------------------------------------------------------------------
diffkmers <- rownames(fit)[testresults != 0]
write(diffkmers, "diffkmers.txt")
