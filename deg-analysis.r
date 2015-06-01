group <- factor(c('H', 'P', 'U', 'C','H', 'P', 'U', 'C','H', 'P', 'U',
    'C','H', 'P', 'U', 'C', 'F', 'F', 'F'))
id <- c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S')
rootpath <- paste0('/mnt/HA/groups/nsftuesGrp/data/',
    'gilliland-guest/express-quant/JRYH001')
expdata <- data.frame(row.names=id)
fname <- file.path(paste0(rootpath, id[1]), 'results.xprs')
x <- read.delim(fname, row.names="target_id")
# order(x)
genenames <- row.names(x)
# genenames <- genenames[order(genenames)]
for (i in 1:length(id)) {
    fname <- file.path(paste0(rootpath, id[i]), 'results.xprs')
    i
    sampleexp <- read.delim(fname, row.names="target_id")
    explevel <- sampleexp['eff_counts']
    # sampleexp['eff_counts']
    expdata[i, 1] <- id[i]
    expdata[i, 2] <- group[i]
    # expdata[i, seq(3, 2+length(genenames))] <- aperm(sampleexp['eff_counts'],
    #     c(2, 1))
}
names(expdata) <- c('ID', 'treatment', genenames)
