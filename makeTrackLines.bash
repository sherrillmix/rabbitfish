#!/bin/bash

#need to do make the files publically available
#ln -s /home/jude/rabbitfish/work/*.bam /home/jude/rabbitfish/work/*.bai /var/www/html/rabbit

#remove rabbit.tracks so we can start from scratch
if [ -e rabbit.tracks ];then rm rabbit.tracks;fi
for ii in work/*.bam;do
	bam=$(basename $ii)
	echo track type=bam name="$bam" bigDataUrl=http://microb253.med.upenn.edu/rabbit/$bam pairEndsByName=True db=danRer10 visibility=squish>> rabbit.tracks
done

#track type=bam name="My BAM" 
