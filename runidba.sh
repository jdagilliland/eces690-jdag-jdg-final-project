#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M jdg323@drexel.edu
#$ -P nsftuesPrj
#$ -pe openmpi_ib 64
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

# Load appropriate python.
module load python/2.7-current
# ---- Keep the foregoing

# Set up variables to keep organized.
RAWPATH=$PROJPATH/data/rawread
INDATADIR="${TMP}/in-data"
mkdir -p "$INDATADIR"
OUTDATADIR="${TMP}/idba_ud-out"
mkdir -p "$OUTDATADIR"
COLLECTDATADIR="$PROJPATH/data/idba_ud-out"
mkdir -p "$COLLECTDATADIR"

# Download the requisite data.
cp $RAWPATH/*merge*.fasta $INDATADIR
# Assemble the reads *de novo*.
idba_ud \
	--num_threads 64 \
	-r $INDATADIR/*merge*.fasta \
	-o $OUTDATADIR

# Clean up, clean up, everybody clean up.
mv $OUTDATADIR/* $COLLECTDATADIR/
rmdir $OUTDATADIR
