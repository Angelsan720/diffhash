include("loader.jl")
using BioSequences
using CSV
using DataFrames

function filter_file(filename, kmers , filter)

    print(filename*"\n")
    if occursin("FASTQ" , uppercase(filename))
        reader = FASTQ.Reader(open(filename, "r"))
        writer = FASTQ.Writer(open(filename * ".filtered.FASTQ", "w" ))
    elseif occursin("FASTA" , uppercase(filename))

        reader = FASTA.Reader(open(filename, "r"))
        writer = FASTA.Writer(open(filename * ".filtered.FASTA", "w" ))
    else
	return
    end
    for record in reader
        # Do something
        eachkmer = [kmer for (_, kmer) in each(DNAKmer{13}, sequence(record))]
        canks = [convert(String, canonical(kmer)) for kmer in eachkmer]
        # use any or all to select reads that pass
	# Anonymous function to check if all kmers are present
        if filter
            if (all(cank -> haskey(kmers, cank), canks))
                write(writer, record)
            end
        else
            if (any(cank -> haskey(kmers, cank), canks))
                write(writer, record)
            end
        end

    end

    close(reader)
    close(writer)
end

function filter_files(kmers , datadir , filter)
    print(datadir*"\n")
    files = readdir(datadir)
    for file in files
        samp = joinpath(datadir , file)
        filter_file(samp , kmers , filter)
    end
end

function filter_reads(diffkmers , datadir , filter)
	### main


	kmers = Dict()

	for kmer in eachline(diffkmers)
		kmers[kmer] = 1
	end

	filter_files(kmers , datadir , filter)
end

dic = Dict( "ArgDelimiter"=>"=",
            "DataDir"=>"/data/angelsan720/projecto2/files/diffhash/",
            "kmers"=>"diffkmers.txt",
            "Filter"=>"all")

#dic = loadARGS(dic)
print(dic)
filter_reads(dic["kmers"] , dic["DataDir"] , dic["Filter"]=="all")
