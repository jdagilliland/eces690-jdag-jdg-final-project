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
RAWPATH="$PROJPATH/data/rawread"
ASSEMBLYDIR="$PROJPATH/data/idba_ud-out"
INDATADIR="${TMP}/in-data"
mkdir -p "$INDATADIR"
OUTDATADIR="${TMP}/idba_mt-out"
mkdir -p "$OUTDATADIR"
COLLECTDATADIR="$PROJPATH/data/idba_mt-out"
mkdir -p "$COLLECTDATADIR"

# Correct assembly results using IDBA-MT.
echo 'Correcting assembly using IDBA-MT'
idba-mt \
	-t $RAWPATH/fwd.fasta \
	-f $RAWPATH/rev.fasta \
	-c $ASSEMBLYDIR/contig-100.fa \
	-r 100 \
	-i 153 \
	-O $OUTDATADIR/idba-ud-mt-assembly.fa

# Clean up, clean up, everybody clean up.
mv $OUTDATADIR/* $COLLECTDATADIR/
rmdir $OUTDATADIR
