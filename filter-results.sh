#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M jdg323@drexel.edu
#$ -P nsftuesPrj
#$ -pe openmpi_ib 1
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
SOURCE=$PROJPATH/data/idba_trans-out/transcript-60.fa
defilestring=$(ls *-up.list *-dn.list)
defiles=($defilestring)
for fname in "${defiles[@]}"
do :
	fafile="${fname%%.*}.fa"
	python filter-fasta.py $fafile $fname $SOURCE
done
