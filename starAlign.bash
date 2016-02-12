#!/bin/bash

#make errors end script
set -e

#fastq files are stored as .txt.gz
for ii in data/UTAH_CORE/*/9386R/Fastq/*.txt.gz data/UGUAM0001JB/RNAseq_RawData/Samples/*.txt.gz;do
  echo $ii
  base=$(basename $ii)
  outFile=work/${base%.txt.gz}
  finalFile=$outFile.bam
  echo $ii = $finalFile
  continue

  if [ ! -f "$finalFile" ];then
    date
    removeshort $ii >work/unzipped.fastq
    echo "Unzipped"
    date
    echo "Aligning"
    index=~/rabbitfish/index
    ~/installs/STAR/bin/Linux_x86_64_static/STAR --genomeDir $index  --readFilesIn ~/rabbitfish/unzipped.fastq --outFileNamePrefix $outFile. --runMode genomeGenerate   --runThreadN 24   --genomeDir index/ --sjdbGTFfile zebrafishgenome/Drerio_ensGene.GTF --genomeFastaFiles zebrafishgenome/danRer10.fa

    echo "Sorting"
    samtools view -bS "$outFile.Aligned.out.sam" > work/tmp.bam
    samtools sort -m 5000000000 work/tmp.bam $outFile #use ~5G of RAM
    samtools index $finalFile
    rm "$outFile.Aligned.out.sam"
    rm rabbitfish/trialunzipped.fastq
    rm work/tmp.bam
    echo "Done"
  else
    echo "Already processed. Skipping."
  fi
done
echo "Done. Thanks"

