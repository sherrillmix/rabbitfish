#!/bin/bash

set -e

#following http://transdecoder.github.io/
for dir in work/trinity_noGenome work/trinity_unpaired;do
	if [ ! -f "work/$dir/transdecode/longest_orfs.pep" ];then
		#cd to avoid permission issue with Transdecoder forced directory path
		cd $dir
		echo "Transdecoding $dir"
		~/installs/transdecoder/TransDecoder.LongOrfs -t Trinity.fasta
		mv Trinity.fasta.transdecoder_dir transdecode
		cd -
	fi
done

#following https://trinotate.github.io/#SequencesRequired
for dir in work/trinity_noGenome work/trinity_unpaired;do
	blastx -query $dir/Trinity.fasta -db ~/installs/trinotate/db/uniprot_sprot.pep -num_threads 12 -max_target_seqs 1 -outfmt 6 > $dir/blastx.outfmt6
	blastp -query $dir/transdecoder.pep -db ~/installs/trinotate/db/uniprot_sprot.pep -num_threads 12 -max_target_seqs 1 -outfmt 6 > $dir/blastp.outfmt6
	hmmscan --cpu 12 --domtblout $dir/TrinotatePFAM.out ~/installs/trinotate/db/Pfam-A.hmm $dir/transdecode/longest_orfs.pep > $dir/pfam.log
done
