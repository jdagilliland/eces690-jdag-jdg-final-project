#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M jdg323@drexel.edu
#$ -P nsftuesPrj
#$ -pe openmpi_ib 1
#$ -l h_rt=24:00:00
#$ -l h_vmem=8G
##$ -pe shm 32-64 #for parallel processing
#$ -l mem_free=6G
#$ -q all.q@@amdhosts

# ---- Keep the following
. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
# ---- Keep the foregoing

PATH=/mnt/HA/groups/nsftuesGrp/.local/bin:$PATH
PATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest/bin:$PATH
PROJPATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest

# Set up variables to keep organized.
DATADIR="$PROJPATH/idba-mapped"
SAMFILES=$DATADIR/*.sam

for f in $SAMFILES
do :
	echo $f
	newf=$DATADIR/$(basename $f)
	samtools view -bS $f > $newf.bam
done

