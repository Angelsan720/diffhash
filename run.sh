DataDir="/data/angelsan720/diffhashtmp"
DataFrame="DataFrame"
OutFile="diff.kmers"
Filter="all"
#rm -rf simulated_reads
#Rscript diffhash.1.R
#mv simulated_reads/sim* .
#rm hashcount.tsv

julia diffhash.jl DataDir=$DataDir DataFrame=$DataFrame OutFile=$OutFile
Rscript diffhash.2.R
julia filter-reads.jl DataDir=$DataDir kmers=$OutFile DataFrame=$DataFrame Filter=$Filter
