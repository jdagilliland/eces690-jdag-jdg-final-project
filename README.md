Ant gut metatranscriptomic analysis
===================================

Prior to *de novo* assembly, we have to merge our paired reads into fasta
files where pairs of reads appear on adjacent lines.
To accomplish this we use the script supplied with the IDBA tools as seen
[below](mergedata.sh).
We then move on to *de novo* assembly, for which we use IDBA-UD.
See the [script below](run-idba.sh).
IDBA-UD feeds into IDBA-MT, a Metatranscriptomic analyzer that removes
chimeric contigs produced by IDBA-UD.
That script is also present [below].
Following assembly, we must build a bowtie index, for which we use the
following [script](buildindices.sh), and then align reads to the assembled
transcriptome as [linked below](bowtie-align.sh).
After alignment, we used eXpress to quantify expression levels for each
transcript in our transcriptome as [seen below](run-express.sh).
Once we have quantified each transcript, we are in a position to use the
edgeR package for R to check for differential gene
expression, as shown in the script [below] (deg-analysis.r).

* [Merge paired read data into combined fasta file](mergedata.sh)
* [IDBA-UD script](run-idba.sh)
* IDBA-MT script
* [Build Bowtie index](buildindices.sh)
* [Align to assembled transcriptome](bowtie-align.sh)
* [eXpress script](run-express.sh)
* [edgeR script](deg-analysis.r)
