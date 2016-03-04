#!/bin/bash

# > overwrites a file. here we're adding column names
#note this will clobber any existing files called fastqReadCounts.txt
echo file,count > out/fastqReadCounts.txt
#loop over files with names like XXX.txt.gz in data/UTAH... or data/UGUAM...
for ii in data/UTAH_CORE/101Paired_end/9386R/Fastq/*.txt.gz data/UGUAM0001JB/RNAseq_RawData/Samples/*.txt.gz;do
  echo $ii
  #$(()) is used for basic math in bash. here we're dividing by 4. 
  #Things between `` are evaluated then the result is substituted in. 
  #So we uncompress the fastq and pipe to wc to count lines. 
  #That number is pasted in (like an excel =A4/4 formula) and the # lines divided by 4 is saved in readCount
  readCount=$((`zcat $ii|wc -l`/4))
  #print filename,XXXXX to fastqReadCounts.txt
  #a single > replaces a file with the output. A double >> appends to the end of the file. 
  #so at each step we append the results to the file to give us a single file with all values
  #note we did an echo > fastqReadCounts.txt before the loop to clear out the file.
  #otherwise the file would grow and grow every time we called this script
  echo $ii,$readCount >>out/fastqReadCounts.txt
done

#note this will clobber any existing files called uniqueBamCounts.txt
echo file,count > out/uniqueBamCounts.txt
#loop over XXX.bam files in work directory
for ii in work/*.bam;do
  echo $ii
  #stuff between `` is evaluated and the result pasted in
  #we use`samtools view` to output the reads with the argument `-F 0x4` to exclude unmapped reads.
  # and pipe the output to cut to select the first column (the read name column) 
  # and pipe that  to then piping that to sort to sort the reads
  # and pipe that to uniq to retain only the unique read names (uniq requires sorted input so that's why we sorted)
  # and finally pipe to wc to count lines (where we have set it up so that each unique read name is a separate line)
  readCount=`samtools view -F 0x4 "$ii" | cut -f 1 | sort | uniq | wc -l`
  #append to output file
  echo $ii,$readCount >>out/uniqueBamCounts.txt
done

