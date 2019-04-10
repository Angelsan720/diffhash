DataDir="/data/angelsan720/diffhash"
DataFrame="DataFrame"
OutFile="hashcounts.tsv"
Filter="all"
K="20"
#rm -rf simulated_reads
#Rscript diffhash.1.R
#mv simulated_reads/sim* .

rm hashcount.tsv
echo "diffhash"
julia diffhash.jl DataDir=$DataDir DataFrame=$DataFrame OutFile=$OutFile k=$K
echo "analisys"
Rscript diffhash.2.R
#python toFasta.py diffkmers.txt > diffkmers.fasta
julia filter_reads.jl