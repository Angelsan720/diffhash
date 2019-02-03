
#__precompile__()
using CSV
using DataFrames
using BioSequences
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

function count_kmers(df , datadir , double_ended)
    kmers = Dict()
    files = readdir(datadir)
    if double_ended
        println("Double ended")
    end
    for row in 1:nrow(df)
        sample_name = df[row,:rep_id]
        work = []
        for file in files
            if occursin(sample_name, file)
                append!(work , file)
            end
        for job in work
            jobname = datadir + job
            println(jobname)
            update_kmercount!(jobname, kmers, row , df)#parralelizing tentative
        end



    end
















            update_kmercount!(forward_name, kmers, row , df)
            update_kmercount!(reverse_name, kmers, row , df)
        end


    end
    return kmers
end


if DEBUG
	println("Running Diffhash")
end
### main
df = CSV.File(file, delim = delimiter)## |> DataFrame
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
