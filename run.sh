DataDir="/data/angelsan720/projecto2/files/diffhash/"
DataFrame="DataFrame"
OutFile="hashcounts.tsv"
Filter="all"
K="13"
OutDir="/data/angelsan720/diffhashout"

rm hashcounts.tsv
echo "diffhash"
julia diffhash.jl DataDir=$DataDir DataFrame=$DataFrame OutFile=$OutFile k=$K
echo "analisys"
Rscript diffhash.2.R
#python toFasta.py diffkmers.txt > diffkmers.fasta
echo "filtering reads"
julia filter-reads.jl kmers=diffkmers.txt DataDir=$DataDir Filter=$Filter


K="25"

rm hashcounts.tsv
echo "diffhash"
julia diffhash.jl DataDir=$DataDir DataFrame=$DataFrame OutFile=$OutFile k=$K
echo "analisys"
Rscript diffhash.2.R
python toFasta.py diffkmers.txt > diffkmers.fasta