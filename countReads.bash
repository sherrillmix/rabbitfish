#!/bin/bash

echo > fastqReadCounts.txt
for ii in data/UTAH_CORE/101Paired_end/9386R/Fastq/*.txt.gz data/UGUAM0001JB/RNAseq_RawData/Samples/*.txt.gz;do
  echo $ii
  zcat $ii| echo $((`wc -l`/4)
end
