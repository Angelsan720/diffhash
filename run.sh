rm -rf simulated_reads
Rscript diffhash.1.R
mv simulated_reads/sim* .

julia diffhash.jl DEBUG=true datadir=simulated_reads outfile=hashcounts.tsv dataframe=sim_rep_info.txt

Rscript diffhash.2.R
