rm -rf normal
rm -rf short
rm -rf long

mkdir normal
mkdir short
mkdir long
cp data/Trinity.normal.fasta normal/Trinity.normal.fasta
cp data/Trinity.long.fasta long/Trinity.longreads.fasta
cp data/sequence.short.fasta short/secuence.shortreads.fasta

cd normal
makeblastdb -in Trinity.normal.fasta -title normal -dbtype nucl
cd ../long/
makeblastdb -in Trinity.longreads.fasta -title long -dbtype nucl


cd ../normal/
blastn -query ../long/Trinity.longreads.fasta -db Trinity.normal.fasta -outfmt 6 -num_alignments 1 -num_descriptions 1 -out blast

cd ../long/
blastn -query ../normal/Trinity.normal.fasta -db Trinity.longreads.fasta -outfmt 6 -num_alignments 1 -num_descriptions 1 -out blast

cd ..
python compare.py