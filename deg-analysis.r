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
expdata <- readDGE(fnames, columns=c(1, 8), group=groups, labels=id)
expdata <- calcNormFactors(expdata)
expdata <- estimateCommonDisp(expdata)
expdata <- estimateTagwiseDisp(expdata)
et <- exactTest(expdata)
topTags(et)
