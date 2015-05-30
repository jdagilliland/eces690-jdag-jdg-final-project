#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M jdg323@drexel.edu
#$ -P nsftuesPrj
#$ -pe openmpi_ib 16
#$ -l h_rt=24:00:00
#$ -l h_vmem=16G
##$ -pe shm 32-64 #for parallel processing
#$ -l mem_free=8G
# select the queue all.q, using hostgroup @intelhosts
#$ -q all.q@@amdhosts

PATH=/mnt/HA/groups/nsftuesGrp/.local/bin:$PATH
PATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest/bin:$PATH
PROJPATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest

# ---- Keep the following
. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1

# Load bowtie2 module.
module load bowtie2/2.2.5
# Load appropriate python.
module load python/2.7-current
# ---- Keep the foregoing

# Set up variables to keep organized.
IDBAPATH="$PROJPATH/data/idba_trans-out/transcript-60.fa"
IDBAINDEXNAME="idba-assembly"
REFPATH=$(ls -m $PROJPATH/refgen/* | sed -e 's/,\w*/,/g' |tr -d '\n')
REFINDEXNAME="ref-genomes"
INDEXDIR="${TMP}/index"
mkdir -p "$INDEXDIR"
COLLECTDATADIR="$PROJPATH/data/index"
mkdir -p "$COLLECTDATADIR"

# Assemble the reads *de novo*.
bowtie2-build $IDBAPATH $INDEXDIR/$IDBAINDEXNAME
bowtie2-build $REFPATH $INDEXDIR/$REFINDEXNAME

# Clean up, clean up, everybody clean up.
mv $INDEXDIR/* $COLLECTDATADIR/
rmdir $INDEXDIR
