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
INDATADIR="${TMP}/in-data"
mkdir -p "$INDATADIR"

# Download the requisite data.
echo 'Concatenating fwd reads...'
cat $RAWPATH/*R1*.fastq > $INDATADIR/fwd.fastq
echo 'Converting fwd reads to fasta...'
fq2fa $INDATADIR/fwd.fastq $INDATADIR/fwd.fasta
echo 'Concatenating rev reads...'
cat $RAWPATH/*R2*.fastq > $INDATADIR/rev.fastq
echo 'Converting rev reads to fasta...'
fq2fa $INDATADIR/rev.fastq $INDATADIR/rev.fasta

# Clean up, clean up, everybody clean up.
mv $INDATADIR/* $RAWPATH/
rmdir $OUTDATADIR
