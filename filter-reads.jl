include("loader.jl")
using BioSequences
using CSV
using DataFrames

function filter_fasta(filename, kmers , allany)

    if occursin("FASTQ" , uppercase(filename))
        if VERBOSE || DEBUG
            println("I/O FASTQ")
        end
        reader = FASTQ.Reader(open(filename, "r"))
        writer = FASTQ.Writer(open(filename + ".filtered.FASTQ", "w" ))
    else
        if VERBOSE || DEBUG
            println("I/O FASTA")
        end
        reader = FASTA.Reader(open(filename, "r"))
        writer = FASTA.Writer(open(filename + ".filtered.FASTA", "w" ))
    end
    for record in reader
        # Do something
        eachkmer = [kmer for (_, kmer) in each(DNAKmer{13}, sequence(record))]
        canks = [convert(String, canonical(kmer)) for kmer in eachkmer]
        # use any or all to select reads that pass
	# Anonymous function to check if all kmers are present
        if allany
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
###############################################
function filter_files(df , kmers , datadir , allany)
    files = readdir(datadir)
    for file in files
        samp = joinpath(datadir , file)
        filter_fasta(samp , kmers , allany)
    end
end

function filter_reads(datafile , delimiter , diffkmers ,datadir, allany)
	if DEBUG
		println("Running filter_reads")
	end
	### main

	df = CSV.File(datafile, delim = delimiter) |> DataFrame

	kmers = Dict()

	for kmer in eachline(diffkmers)
		kmers[kmer] = 1
	end

	filter_files(df , kmers , datadir , allany)
end

dic = Dict( "arg_delimiter"=>"=",
            "DEBUG"=>"false",
            "VERBOSE"=>"false",
            "dataframe"=>"",
            "frame_delimiter"=>"\t",
            "datadir"=>"data",
            "diffkmers"=>"diffkmers.txt",
            "all"=>"all")

dic = loadARGS(dic)

DEBUG = dic["DEBUG"]=="true"
VERBOSE = dic["VERBOSE"]=="true"

filter_reads(dic["dataframe"] , dic["frame_delimiter"] , dic["diffkmers"] , dic["datadir"],dic["all"]=="all")
