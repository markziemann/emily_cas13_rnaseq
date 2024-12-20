#!/bin/bash

cd ref

wget https://ftp.ensembl.org/pub/release-113/fasta/gallus_gallus/cdna/Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.cdna.all.fa.gz

wget https://ftp.ensembl.org/pub/release-113/fasta/gallus_gallus/ncrna/Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.ncrna.fa.gz

cat Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.cdna.all.fa.gz Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.ncrna.fa.gz > Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.cdna+ncrna.fa.gz

zcat Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.cdna+ncrna.fa.gz | cat dsred.fa cas13.fa - > ref.fa

kallisto index -i ref.fa.idx ref.fa

wget https://ftp.ensembl.org/pub/release-113/gtf/gallus_gallus/Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.113.gtf.gz

zcat Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.113.gtf.gz \
| grep -v '#!' | awk '$3=="transcript"' | cut -f9 \
| cut -d '"' -f2,6,10 | tr '"' '\t' \
| awk '{OFS="\t"} {print $0,$1}' | sed 's/ensembl\t//' | sed 's/RefSeq\t//' | cut -f-3 \
| awk '{OFS="\t"}{print $2,$1,$3}' > Gallus_gallus.bGalGal1.mat.broiler.GRCg7b.113.tx2gene.tsv

