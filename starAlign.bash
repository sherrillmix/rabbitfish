#!/bin/bash

#make errors end script
set -e

#fastq files are stored as .txt.gz
for ii in  data/UGUAM0001JB/RNAseq_RawData/Samples/*.txt.gz;do
  echo $ii
  base=$(basename $ii)
  outFile=work/${base%.txt.gz}
  finalFile=$outFile.bam
  echo Processing $base to $finalFile

  if [ ! -f "$finalFile" ];then
    date
    removeshort "$ii" >work/unzipped.fastq
    echo "Unzipped"
    date
    echo "Aligning"
    STAR/bin/Linux_x86_64_static/STAR --genomeDir index   --runThreadN 18 --readFilesIn work/unzipped.fastq --outFileNamePrefix $outFile.

    echo "Sorting"
    samtools view -bS "$outFile.Aligned.out.sam" > work/tmp.bam
    samtools sort -m 5000000000 work/tmp.bam $outFile #use ~5G of RAM
    samtools index $finalFile
    rm "$outFile.Aligned.out.sam"
    rm work/unzipped.fastq
    rm work/tmp.bam
    echo "Done"
  else
    echo "Already processed. Skipping."
  fi
done
echo "Done with singles"

echo "Working on paired data"
read1=data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_1.txt.gz
read2=data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_2.txt.gz
base=$(basename $read1)
outFile=work/${base%_1.txt.gz}
finalFile=$outFile.bam
echo Processing $read1 and $read2 to $finalFile
if [ ! -f "$finalFile" ];then
 date
 removeshort "$read1" >work/unzipped1.fastq
 removeshort "$read2" >work/unzipped2.fastq
 echo "Unzipped"
 date
 echo "Aligning"
 STAR/bin/Linux_x86_64_static/STAR --genomeDir index   --runThreadN 18 --readFilesIn work/unzipped1.fastq work/unzipped2.fastq --outFileNamePrefix $outFile.

 echo "Sorting"
 samtools view -bS "$outFile.Aligned.out.sam" > work/tmp.bam
 samtools sort -m 5000000000 work/tmp.bam $outFile #use ~5G of RAM
 samtools index $finalFile
 rm "$outFile.Aligned.out.sam"
 rm work/unzipped1.fastq
 rm work/unzipped2.fastq
 rm work/tmp.bam
 echo "Done"
else
 echo "Already processed. Skipping."
fi
done

echo "Done. Thanks"

