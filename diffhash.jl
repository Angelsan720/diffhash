
#__precompile__()
include("loader.jl")
using CSV
using DataFrames
using BioSequences
#using JLD

function update_kmercount!(filename, kmers, pos, n)#ask what this does in detail
    # modifies kmers
    reader = FASTA.Reader(open(filename, "r"))

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
#function joinpath(dir , file)
#    if dir[len(dir)] == "/"
#        return dir + files
#    return dir + "/" + file
#end

function count_kmers(df , datadir , DEBUG , VERBOSE)
    kmers = Dict()
    files = readdir(datadir)
    n = length(files)
    for i in 1:length(files)
        job = joinpath(datadir , files[i])
	if VERBOSE
	        println(job)
	end
        update_kmercount!(job, kmers, i , n)#parralelizing tentative
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

dic = Dict("DEBUG"=>"false","datadir"=>"data","VERBOSE"=>"false","outfile"=>"hashcounts.tsv","arg_delimiter"=>"=" , "out_delim"=>"\t" , "dataframe"=>"")
dic = loadARGS(dic)

DEBUG = dic["DEBUG"]=="true"
VERBOSE = dic["VERBOSE"]=="true"

if DEBUG
	println("Running Diffhash")
end
df = CSV.File(dic["dataframe"], delim = delimiter)

kmers = count_kmers(dic["datadir"] , DEBUG , VERBOSE)
if DEBUG
	println("Finished diffhash")


end
if DEBUG
	println("Starting showhash")
end
outfile = dic["outfile"]
out_delim = dic["out_delim"]
showhash(kmers , DEBUG , VERBOSE , outfile)
if DEBUG
	println("Finished showhash")
end