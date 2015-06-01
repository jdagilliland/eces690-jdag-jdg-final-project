Ant gut metatranscriptomic analysis
===================================

Prior to *de novo* assembly, we have to merge our paired reads into fasta
files where pairs of reads appear on adjacent lines.
To accomplish this we use the script supplied with the IDBA tools as seen
[here](mergedata.sh).
We then move on to *de novo* assembly, for which we use IDBA-tran.
See the [script](run-idba.sh).
Following assembly, we must build a bowtie index, for which we use the
following [script](buildindices.sh), and then align reads to the assembled
transcriptome as [follows](bowtie-align.sh).
After alignment, we used eXpress to quantify expression levels for each
transcript in our transcriptome as [such](run-express.sh).
