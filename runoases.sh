#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M jdg77@drexel.edu
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
OASESPATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest/oases/scripts


# ---- Keep the following
. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1

# Load velvet module.
module load velvet/1.2.10
# Load oases?
# Load Python
module load python/2.7-current
# ---- Keep the foregoing

# Set up variables to keep organized.
RAWPATH=$PROJPATH/data/rawread
INDATADIR="${TMP}/rawread"
mkdir -p "$INDATADIR"
OUTDATADIR="${TMP}/oases-shortkout"
mkdir -p "$OUTDATADIR"
COLLECTDATADIR="$PROJPATH/oases_data/oases-shortkout"
mkdir -p "$COLLECTDATADIR"
# KMER=15

# Download the requisite data.
# ls $RAWPATH/*.fastq
# cp $RAWPATH/*.fastq $INDATADIR
# ls $INDATADIR/*.fastq
# velveth $OUTDATADIR $KMER -fastq.gz -longPaired $INDATADIR/*.fastq.gz
# Enumerate the relevant reads
readfiles=$(ls $RAWPATH/*.fastq)
python $OASESPATH/oases_pipeline.py -m 21 -M 27 -o $OUTDATADIR/ \
	-d " -fastq -longPaired $readfiles "

# Clean up, clean up, everybody clean up.
ls -l $OUTDATADIR
rsync -ruv $OUTDATADIR/* $COLLECTDATADIR
rm -rf $OUTDATADIR

