# rabbitfish

## Alignment
### makeIndex.bash
Take annotated transcripts and zebrafish genome and generate STAR index
### starAlign.bash
Align various fastq files against the zebrafish genome
### runTrinity.bash
Run contig building using trinity over a few parameter combinations

## Analysis
### countReads.bash
Count the number of reads in the fastq and unique reads in the alignments.

### mappingProportion.R
Calculate the proportion of reads aligned for each file

### makeTrackLines.bash
Make track file for input into UCSC genome browser

### annotateTrinity.bash
Usr trinotate pipeline to annotate contigs
