
#__precompile__()
include("loader.jl")
using CSV
using DataFrames
using BioSequences
#using JLD

function update_kmercount!(filename, kmers, pos, n)
    #ask what this does in detail
    # modifies kmers

    if occursin(uppercase(sample_name) , "FASTQ")	
        println("Reading FASTQ")
        reader = FASTQ.Reader(open(filename, "r")) #add functionaily to read compressed files #Doesnt seem possible
    else
        println("Reading FASTA")
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

function count_kmers(df , datadir , DEBUG , VERBOSE)
    kmers = Dict()
    files = readdir(datadir)
    for rowi in 1:size(df,1)
        sample_name = df[rowi,:rep_id]
        for file in files
            if occursin(sample_name , file)
                samp = joinpath(datadir , file)

                println(samp)
		println(file)
		println(datadir)
		println(rowi)
                update_kmercount!( samp , kmers, rowi , nrow(df))
            end
        end
    end


    return kmers
end

function showhash(kmers , DEBUG , VERBOSE , outfile)

	if DEBUG
		println("Running showhash")
	end

	out = ""
	for (key, counts) in pairs(kmers)
		if length(counts) < sum(counts) # there's at least 1 kmer in every file
			if VERBOSE
				println("$key\t$(join(counts, "\t"))\n")
			end
			out = string(out ,"$key\t$(join(counts, "\t"))\n")
		end
	end
	if DEBUG
		println("Writing $outfile")
	end
	open(outfile , "w") do file
		write(file , out)
	end

	if DEBUG
		println("Finished showhash")
	end
end

dic = Dict( "DEBUG"=>"false",
            "datadir"=>"data",
            "VERBOSE"=>"false",
            "outfile"=>"hashcounts.tsv",
            "arg_delimiter"=>"=",
            "out_delim"=>"\t",
            "frame_delimiter"=>"\t",
            "dataframe"=>"")
dic = loadARGS(dic)
#######################################################################
DEBUG = dic["DEBUG"]=="true"
VERBOSE = dic["VERBOSE"]=="true"

if DEBUG
	println("Running Diffhash")
end

df = CSV.File(dic["dataframe"], delim = dic["frame_delimiter"]) |> DataFrame
@show df
kmers = count_kmers(df , dic["datadir"] , DEBUG , VERBOSE)
if DEBUG
	println("Finished diffhash")
end
#######################################################################



#######################################################################
if DEBUG
	println("Starting showhash")
end
outfile = dic["outfile"]
out_delim = dic["out_delim"]
showhash(kmers , DEBUG , VERBOSE , outfile)
if DEBUG
	println("Finished showhash")
end
#######################################################################
