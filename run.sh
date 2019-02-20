rm -rf simulated_reads
Rscript diffhash.1.R
mv simulated_reads/sim* .

julia diffhash.jl DEBUG=true datadir=$(cat datadir) outfile=hashcounts.tsv dataframe=$(cat DataFrame)
echo "##################################################################################################"
Rscript diffhash.2.R
