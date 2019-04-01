DataDir="/data/angelsan720/diffhashtmp"
DataFrame="DataFrame"
OutFile="hashcounts.tsv"
Filter="all"
#rm -rf simulated_reads
#Rscript diffhash.1.R
#mv simulated_reads/sim* .

rm hashcount.tsv
echo "diffhash"
julia diffhash.jl DataDir=$DataDir DataFrame=$DataFrame OutFile=$OutFile
echo "analisys"
Rscript diffhash.2.R
echo "filter-reads"
julia filter-reads.jl DataDir=$DataDir kmers=$OutFile DataFrame=$DataFrame Filter=$Filter
