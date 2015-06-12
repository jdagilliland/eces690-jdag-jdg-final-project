library('edgeR')
groups <- factor(c('H', 'P', 'U', 'C','H', 'P', 'U', 'C','H', 'P', 'U',
    'C','H', 'P', 'U', 'C', 'F', 'F', 'F'))
# Relevel to make sure that H is the control.
groups <- relevel(groups, 'H')
# We will have to control for batch effects in our model.
batch <- factor(c('JR037',
                  'JR037',
                  'JR037',
                  'JR037',
                  'JR001',
                  'JR001',
                  'JR001',
                  'JR001',
                  'JR022',
                  'JR022',
                  'JR022',
                  'JR022',
                  'JR028B',
                  'JR028B',
                  'JR028B',
                  'JR028B',
                  'JR028B',
                  'JR022',
                  'JR001'))
# Put in the IDs for labeling.
id <- c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S')
rootpath <- paste0('/mnt/HA/groups/nsftuesGrp/data/',
    'gilliland-guest/express-quant/JRYH001')
fnames <- c()
for (i in 1:length(id)) {
    fname <- file.path(paste0(rootpath, id[i]), 'results.xprs')
    fnames[i] <- fname
}
print('Loading expression data...')
expdata <- readDGE(fnames, columns=c(2, 8), group=groups, labels=id)
print('Done!')

# Filter the expression data to remove low expression transcripts.
# keep <- rowSums(cpm(expdata)>10) >= 16
# expdata <- expdata[keep,]
# print('We kept this many transcripts which were reasonably expressed...')
# table(keep)

# Normalization stuff...
expdata <- calcNormFactors(expdata)
expdata <- estimateCommonDisp(expdata)
expdata <- estimateTagwiseDisp(expdata)

# Make multidimensional scaling plot.
png('mdsplot-sample.png', 640, 480)
plotMDS(expdata, main="MDS plot of effective counts by sample",
        labels=colnames(expdata$counts))
dev.off()
png('mdsplot-diet.png', 640, 480)
plotMDS(expdata, main="MDS plot of effective counts by diet",
        labels=groups)
dev.off()
png('mdsplot-batch.png', 640, 480)
plotMDS(expdata, main="MDS plot of effective counts by batch",
        labels=batch)
dev.off()
# Make biological coefficient of variation plot.
# pdf('bcvplot.pdf', height=7, width=7)
png('bcvplot.png', 640, 480)
plotBCV(expdata)
dev.off()
# Make heatmap.
cpm_log <- cpm(expdata, log = TRUE)
# pdf('correlation-heatmap.pdf', height=7, width=7)
png('correlation-heatmap-sample.png', 640, 480)
heatmap(cor(cpm_log))
dev.off()
png('correlation-heatmap-diet.png', 640, 480)
heatmap(cor(cpm_log), labRow=groups, labCol=groups)
dev.off()
png('correlation-heatmap-batch.png', 640, 480)
heatmap(cor(cpm_log), labRow=batch, labCol=batch)
dev.off()

# Set FDR cutoff of 0.05.
fdr.cutoff = 0.05

# # Try exact tests between pairs
# print('Performing exact test')
# et <- exactTest(expdata, pair=c('H', 'P'))
# print('Top tags for exact test between control diet and pollen')
# topEt <- topTags(et)
# topEt

# Try a GLM approach
print('Fitting a GLM')
design <- model.matrix(~batch+groups)
fit <- glmFit(expdata, design)
colnames(fit)

# Check whether batch effect was a problem
lrt.batch <- glmLRT(fit, coef=paste0('batch', levels(batch)[-1]))
topBatch <- topTags(lrt.batch)
FDR <- p.adjust(lrt.batch$table$PValue, method="BH")
print('The number of genes that differed significantly between batches was...')
sum(FDR < fdr.cutoff)
# We can see that there are a great number of genes that differed
# significantly between batches.

# Test for differential expression between control and each variable.
lrt.P <- glmLRT(fit, coef=c('groupsP'))
topP <- topTags(lrt.P)
degP <-decideTestsDGE(lrt.P, p.value=fdr.cutoff, adjust.method="BH")

lrt.U <- glmLRT(fit, coef=c('groupsU'))
topU <- topTags(lrt.U)
degU <-decideTestsDGE(lrt.U, p.value=fdr.cutoff, adjust.method="BH")

lrt.C <- glmLRT(fit, coef=c('groupsC'))
topC <- topTags(lrt.C)
degC <-decideTestsDGE(lrt.C, p.value=fdr.cutoff, adjust.method="BH")

print(summary(degP))
print(summary(degU))
print(summary(degC))

genenames.C.up <- rownames(expdata)[degC == 1]
genenames.C.dn <- rownames(expdata)[degC == -1]
genenames.U.up <- rownames(expdata)[degU == 1]
genenames.U.dn <- rownames(expdata)[degU == -1]

cat(genenames.C.up, sep='\n', file='cellobiose-up.list')
cat(genenames.C.dn, sep='\n', file='cellobiose-dn.list')
cat(genenames.U.up, sep='\n', file='urea-up.list')
cat(genenames.U.dn, sep='\n', file='urea-dn.list')
