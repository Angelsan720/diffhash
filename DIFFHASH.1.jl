
#__precompile__()
using BioSequences
using CSV
using DataFrames
using JLD

function update_kmercount!(filename, kmers, pos , df)
    # modifies kmers
    reader = FASTA.Reader(open(filename, "r"))

    for record in reader
        # Do something
        for (_, kmer) in each(DNAKmer{13}, sequence(record))
            cank = convert(String, canonical(kmer)) # store kmers as strings
            oldcount = get!(kmers, cank, zeros(Int64, nrow(df)))
            kmers[cank][pos] = oldcount[pos] + 1
        end
    end

    close(reader)
end

function count_kmers(df)
    kmers = Dict()

    for rowi in 1:nrow(df)
        sample_name = df[rowi,:rep_id]
        println(sample_name)
        forward_name = "simulated_reads/" * sample_name * "_1.fasta"
        reverse_name = "simulated_reads/" * sample_name * "_2.fasta"
        update_kmercount!(forward_name, kmers, rowi , df)
        update_kmercount!(reverse_name, kmers, rowi , df)
    end
    return kmers
end

function diffhash(file , delimiter , DEBUG)
	if DEBUG
		println("Running Diffhash")
	end
	##update_kmercount("reads.fasta", kmers, 1)

	### main


	df = CSV.File(file, delim = delimiter) |> DataFrame
	if DEBUG
		println("Reading Data")
	end


	@show df

	kmers = count_kmers(df)
	@save "kmers.jld" kmers
	#@show kmers
	if DEBUG
		println("Finished diffhash")
	end

end

dic = Dict{String,String}()
dic["threads"]="1"
dic["working_dir"]="."
dic["data_source"]="simulated_reads/sim_rep_info.txt"
dic["out_dir"]="output"
dic["arg_delimiter"]="="
dic["DEBUG"]="False"
dic["verbose"]="True"
include("loader.jl")
loadARGS!(dic)
diffhash( , "\t" , DEBUG)
