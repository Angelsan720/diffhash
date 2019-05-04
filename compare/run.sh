rm -rf normal
rm -rf short
rm -rf long

mkdir normal
mkdir short
mkdir long

cp out/Trinity.fasta normal/
cd normal
makeblastdb -in Trinity.fasta -title normal -dbtype nucl
cd ..

cp out/sequence.long.fasta long/
cd long
makeblastdb -in sequence.long.fasta -title long -dbtype nucl
cd ..

cp out/sequence.short.fasta short/
cd short
makeblastdb -in sequence.short.fasta -title long -dbtype nucl

cd ../normal/
blastn -query ../long/sequence.long.fasta -db Trinity.fasta \
		-outfmt 6 -num_alignments 1 -num_descriptions 1 \
		-out ../long-normal.txt
blastn -query ../short/sequence.short.fasta -db Trinity.fasta \
		-outfmt 6 -num_alignments 1 -num_descriptions 1 \
		-out ../short-normal.txt

cd ../long/
blastn -query ../normal/Trinity.fasta -db sequence.long.fasta \
		-outfmt 6 -num_alignments 1 -num_descriptions 1 \
		-out ../normal-long.txt
blastn -query ../short/sequence.short.fasta -db sequence.long.fasta \
		-outfmt 6 -num_alignments 1 -num_descriptions 1 \
		-out ../short-long.txt

cd ../short/
blastn -query ../long/sequence.long.fasta -db sequence.short.fasta \
		-outfmt 6 -num_alignments 1 -num_descriptions 1 \
		-out ../long-short.txt
blastn -query ../normal/Trinity.fasta -db sequence.short.fasta \
		-outfmt 6 -num_alignments 1 -num_descriptions 1 \
		-out ../normal-short.txt

cd ..
#python compare.py