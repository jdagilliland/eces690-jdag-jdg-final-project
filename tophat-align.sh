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

# Load bowtie2 module.
module load bowtie2/2.2.5
# Load appropriate python.
module load python/2.7-current
# ---- Keep the foregoing

# Set up variables to keep organized.
RAWPATH=$PROJPATH/data/rawread
INDEXNAME="ref-genomes"
INDEXDIR="$PROJPATH/data/index"
TMPDIR="${TMP}/map"
mkdir -p "$TMPDIR"
REFSEQDIR="$PROJPATH/refseq-mapped"
mkdir -p "$REFSEQDIR"

# Align reads using bowtie2
ids=(A B C D E F G H I J K L M N O P Q R S)
for i in "${ids[@]}"
do :
	echo $i
	forwardreadsstring=$(ls -m $RAWPATH/JRYH001${i}*_R1_*.fastq | tr -d '\n')
	reversereadsstring=${forwardreadsstring//R1/R2}
	outdir="${TMPDIR}/JRYH001${i}/"
	mkdir -p "$outdir"
	# echo $forwardreadsstring
	tophat \
		-p 64 \
		-o "$outdir" \
		"$INDEXDIR/$INDEXNAME" \
		"$forwardreadsstring" \
		"$reversereadsstring"
done

# Clean up, clean up, everybody clean up.
rsync -ruv $TMPDIR/* $REFSEQDIR/
rm -rf $TMPDIR
