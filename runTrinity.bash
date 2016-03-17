#looks like sequencing is not strand specific


#pairs genome guided
if [ ! -f "work/trinity/Trinity-GG.fasta" ];then
	~/installs/trinity/Trinity --seqType fq --left data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_1.txt.gz --right data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_2.txt.gz  --CPU 12 --max_memory 120G --output work/trinity --trimmomatic --genome_guided_bam work/9386X1_140606_D00294_0102_AC4JVKACXX_6.bam --genome_guided_max_intron 40000
fi

#pairs non genome guided
if [ ! -f "work/trinity_noGenome/Trinity-GG.fasta" ];then
	~/installs/trinity/Trinity --seqType fq --left data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_1.txt.gz --right data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_2.txt.gz  --CPU 12 --max_memory 120G --output work/trinity_noGenome --trimmomatic
fi

#everything no pairs
if [ ! -f "work/trinity_unpaired/Trinity-GG.fasta" ];then
	~/installs/trinity/Trinity --seqType fq --single data/UTAH_CORE/101Paired_end/9386R/Fastq/9386X1_140606_D00294_0102_AC4JVKACXX_6_[1].txt.gz data/UGUAM0001JB/RNAseq_RawData/Samples/*_sequence.txt.gz  --CPU 12 --max_memory 120G --output work/trinity_unpaired --trimmomatic
fi
