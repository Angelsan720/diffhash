#rm -rf simulated_reads
#Rscript diffhash.1.R
#mv simulated_reads/sim* .
rm hashcount.tsv

julia diffhash.jl DEBUG=true datadir=$(cat datadir) outfile=hashcounts.tsv dataframe=DataFrame
Rscript diffhash.2.R
julia showhash.jl