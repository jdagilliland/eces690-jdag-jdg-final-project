library('edgeR')
groups <- factor(c('H', 'P', 'U', 'C','H', 'P', 'U', 'C','H', 'P', 'U',
    'C','H', 'P', 'U', 'C', 'F', 'F', 'F'))
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
expdata <- calcNormFactors(expdata)
expdata <- estimateCommonDisp(expdata)
expdata <- estimateTagwiseDisp(expdata)

# Try exact tests between pairs
print('Performing exact test')
et <- exactTest(expdata, pair=c('H', 'P'))
print('Top tags for exact test between control diet and pollen')
topEt <- topTags(et)
topEt

# Try a GLM approach
print('Fitting a GLM')
design <- model.matrix(~groups)
fit <- glmFit(expdata, design)
colnames(fit)
lrt.all <- glmLRT(fit, coef=2:5)
print('Top tags for GLM between all groups')
topGlm <- topTags(lrt.all)
topGlm
