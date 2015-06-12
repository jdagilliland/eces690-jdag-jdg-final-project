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

### WARNING: this script only works on a head node, not on a compute node.
# I guess this is because of the firewall that safeguards the cluster.
PATH=/mnt/HA/groups/nsftuesGrp/.local/bin:$PATH
PATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest/bin:$PATH
PROJPATH=/mnt/HA/groups/nsftuesGrp/data/gilliland-guest

# ---- Keep the following
. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1

module load ncbi-blast/gcc/64/2.2.30
# ---- Keep the foregoing

# Set up variables to keep organized.
DATAPATH=$PROJPATH/data

# Perform blast on differentially expressed genes.
dequeries=($(ls *-up.fa *-dn.fa))
for query in "${dequeries[@]}"
do :
	outfile="${query%%.*}.txt"
	blastn -query $query -out $outfile \
		-remote -db nr
done
