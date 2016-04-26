library(dnar)
trinityDir<-c('work/trinity_noGenome','work/trinity_unpaired')
for(dir in trinityDir){
	message(dir)
	seqs<-read.fa(file.path(dir,'Trinity.fasta'))
	rownames(seqs)<-sub(' .*$','',seqs$name)
	annots<-read.table(file.path(dir,'trinotate_annotation_report.tsv'),sep='\t',stringsAsFactors=FALSE,fill=TRUE,quote='')
	colnames(annots)<-strsplit(sub('^#','',readLines(file.path(dir,'trinotate_annotation_report.tsv'),n=1)),'\t')[[1]]
	p450Ids<-annots[apply(annots,1,function(x)any(grepl('P450',x))),'transcript_id']
	p450<-seqs[p450Ids,]
	message(nrow(p450),' P450 proteins found')
	write.fa(p450$name,p450$seq,file.path(dir,'p450.fa'))
}
