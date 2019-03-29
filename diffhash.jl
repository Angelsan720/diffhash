#import Pkg;
#Pkg.add("JLD")
#Pkg.add("BioSequences")
#Pkg.add("CSV")
#Pkg.add("DataFrames")
include("loader.jl")
using CSV
using DataFrames
using BioSequences
#using JLD

function count_kmers(df , datadir)
    kmers = Dict()
    files = readdir(datadir)
    for rowi in 1:size(df,1)
        sample_name = df[rowi,:rep_id]
        for file in files
            if occursin(sample_name , file)
                samp = joinpath(datadir , file)
                update_kmercount!( samp , kmers, rowi , nrow(df))
            end
        end
    end


    return kmers
end

function update_kmercount!(filename, kmers, pos, n)
    #ask what this does in detail
    # modifies kmers

    if occursin("FASTQ" , uppercase(filename))
        reader = FASTQ.Reader(open(filename, "r"))
    else
        reader = FASTA.Reader(open(filename, "r"))
    end

    for record in reader
        # Do something
        for (_, kmer) in each(DNAKmer{13}, sequence(record))
            cank = convert(String, canonical(kmer)) # store kmers as strings
            oldcount = get!(kmers, cank, zeros(Int64, n))
            kmers[cank][pos] = oldcount[pos] + 1
        end
    end

    close(reader)
end

function showhash(kmers , outfile)
	out = ""
	for (key, counts) in pairs(kmers)
		if length(counts) < sum(counts) # there's at least 1 kmer in every file
			out = string(out ,"$key\t$(join(counts, "\t"))\n")
		end
	end
	open(outfile , "w") do file
		write(file , out)
	end
end

dic = Dict( "ArgDelimiter"=>"=",
            "DataDir"=>"",
            "FrameDelimiter"=>"\t",
            "DataFrame"=>"DataFrame",
            "OutFile"=>"diff.kmers")

dic = loadARGS(dic)
df = CSV.File(dic["DataFrame"], delim = dic["FrameDelimiter"]) |> DataFrame
@show df
kmers = count_kmers(df , dic["DataDir"])
outfile = dic["OutFile"]
showhash(kmers , outfile)
