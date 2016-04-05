#!/bin/bash

set -e
trinonateDir=~/installs/trinotate

#following http://transdecoder.github.io/
for dir in work/trinity_noGenome work/trinity_unpaired;do
	if [ ! -f "$dir/transdecode/longest_orfs.pep" ];then
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
	outFile=$dir/blastx.outfmt6
	if [ ! -f "$outFile" ];then
		echo "blastx $dir"
		blastx -query $dir/Trinity.fasta -db ~/installs/trinotate/db/uniprot_sprot.pep -num_threads 12 -max_target_seqs 1 -outfmt 6 > $outFile
	fi
	outFile=$dir/blastp.outfmt6
	if [ ! -f "$outFile" ];then
		echo "blastp $dir"
		blastp -query $dir/transdecode/longest_orfs.pep -db ~/installs/trinotate/db/uniprot_sprot.pep -num_threads 12 -max_target_seqs 1 -outfmt 6 > $outFile
	fi
	outFile=$dir/pfam.log
	if [ ! -f "$outFile" ];then
		echo "hmmscan $dir"
		hmmscan --cpu 12 --domtblout $dir/TrinotatePFAM.out ~/installs/trinotate/db/Pfam-A.hmm $dir/transdecode/longest_orfs.pep > $outFile
	fi
done


if [ ! -f "work/Trinotate.sqlite" ];then
	wget "https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/Trinotate_v3.sqlite.gz" -O work/Trinotate.sqlite.gz
	gunzip -f work/Trinotate.sqlite.gz
fi


for dir in work/trinity_noGenome work/trinity_unpaired;do
	echo "Loading $dir"
	echo "Copy premade sqlite db"
	cp work/Trinotate.sqlite $dir
	#Trinotate writes to temp file in current directory so cd to work dir
	cd $dir
	echo "Gene map"
	~/installs/trinity/util/support_scripts/get_Trinity_gene_to_trans_map.pl Trinity.fasta >  Trinity.fasta.gene_trans_map
	echo "Init"
	$trinonateDir/Trinotate Trinotate.sqlite init --gene_trans_map Trinity.fasta.gene_trans_map --transcript_fasta Trinity.fasta --transdecoder_pep transdecode/longest_orfs.pep
	echo "Load protein hits"
	$trinonateDir/Trinotate Trinotate.sqlite LOAD_swissprot_blastp blastp.outfmt6
	echo "Load transcript hits"
	$trinonateDir/Trinotate Trinotate.sqlite LOAD_swissprot_blastx blastx.outfmt6
	echo "Load Pfam"
	$trinonateDir/Trinotate Trinotate.sqlite LOAD_pfam TrinotatePFAM.out
	echo "make report"
	$trinonateDir/Trinotate Trinotate.sqlite report  > trinotate_annotation_report.xls
	cd -
done








echo "All done"
