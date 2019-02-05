
#__precompile__()
using CSV
using DataFrames
using BioSequences
#using JLD

function update_kmercount!(filename, kmers, pos , df)#ask what this does in detail
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
function joinpath(dir , file)
    if dir[len(dir)] == "/"
        return dir + files
    return dir + "/" + file
end

function count_kmers(df , datadir)
    kmers = Dict()
    files = readdir(datadir)
    for file in files
        job = joinpath(datadir , file)
        println(job)
        update_kmercount!(job, kmers, row , df)#parralelizing tentative
    end

    return kmers
end
function showhash(kmers)
	if DEBUG
		println("Running showhash")
	end

	out = ""
	for (key, counts) in pairs(kmers)
		if length(counts) < sum(counts) # there's at least 1 kmer in every file
			out = string(out ,"$key\t$(join(counts, "\t"))\n")
		end
	end
	open("hashcounts.tsv" , "w") do file
		write(file , out)
	end

	if DEBUG
		println("Finished showhash")
end

if DEBUG
	println("Running Diffhash")
end
df = CSV.File(file, delim = delimiter)

kmers = count_kmers(df , "simulated_reads")
if DEBUG
	println("Finished diffhash")
end
if DEBUG
	println("Finished showhash")
end
showhash(kmers)
if DEBUG
	println("Finished showhash")
end
