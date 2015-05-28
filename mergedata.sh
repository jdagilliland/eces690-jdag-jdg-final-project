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

# Load appropriate python.
module load python/2.7-current
# ---- Keep the foregoing

# Set up variables to keep organized.
RAWPATH=$PROJPATH/data/rawread
forwardreadsstring=$(ls $RAWPATH/*_R1_*.fastq)
forwardreads=($forwardreadsstring)
reversereads=(${forwardreadsstring//R1/R2})
mergedreads=${forwardreadsstring//R1/merge}
mergedreads=(${mergedreads//fastq/fasta})
# echo $forwardreads
# echo $reversereads
# echo $mergedreads
i=1
for forw in "${forwardreads[@]}"
do :
	echo $i
	forwardread=${forwardreads[$i]}
	echo $forwardread
	reverseread=${reversereads[$i]}
	echo $reverseread
	mergedread=${mergedreads[$i]}
	echo $mergedread
	fq2fa --merge --filter $forwardread $reverseread $mergedread
	((i++))
done
