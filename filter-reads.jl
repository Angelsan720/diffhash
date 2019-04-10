include("loader.jl")
using BioSequences
using CSV
using DataFrames

function filter_file(filename, kmers , filter)

    print(filename * "\n")
    if occursin("FASTQ" , uppercase(filename))
        reader = FASTQ.Reader(open(filename, "r"))
        writer = FASTQ.Writer(open(filename * ".filtered.FASTQ", "w" ))
    else
        reader = FASTA.Reader(open(filename, "r"))
        writer = FASTA.Writer(open(filename * ".filtered.FASTA", "w" ))
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

function filter_files(df , kmers , datadir , filter)
    files = readdir(datadir)
    for file in files
        samp = joinpath(datadir , file)
        filter_file(samp , kmers , filter)
    end
end

function filter_reads(datafile , delimiter , diffkmers ,datadir, filter)
	### main

	df = CSV.File(datafile, delim = delimiter) |> DataFrame

	kmers = Dict()

	for kmer in eachline(diffkmers)
		kmers[kmer] = 1
	end

	filter_files(df , kmers , datadir , filter)
end

dic = Dict( "ArgDelimiter"=>"=",
            "DataFrame"=>"",
            "FrameDelimiter"=>"\t",
            "DataDir"=>"",
            "kmers"=>"diff.kmers",
            "Filter"=>"all")

dic = loadARGS(dic)

filter_reads(dic["DataFrame"] , dic["FrameDelimiter"] , dic["kmers"] , dic["DataDir"],dic["Filter"]=="all")
