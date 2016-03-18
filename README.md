# rabbitfish

## Alignment
### makeIndex.bash
Take annotated transcripts and zebrafish genome and generate STAR index
### starAlign.bash
Align various fastq files against the zebrafish genome

## Analysis
### countReads.bash
Count the number of reads in the fastq and unique reads in the alignments.

### mappingProportion.R
Calculate the proportion of reads aligned for each file

### makeTrackLines.bash
Make track file for input into UCSC genome browser
