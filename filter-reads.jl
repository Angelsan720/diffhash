include("loader.jl")
using BioSequences
using CSV
using DataFrames

function filter_fasta(inname, outname, kmers)

    reader = FASTA.Reader(open(inname, "r"))
    writer = FASTA.Writer(open(outname, "w" ))
    for record in reader
        # Do something
        eachkmer = [kmer for (_, kmer) in each(DNAKmer{13}, sequence(record))]
        canks = [convert(String, canonical(kmer)) for kmer in eachkmer]
        # use any or all to select reads that pass
	# Anonymous function to check if all kmers are present
        if (all(cank -> haskey(kmers, cank), canks))
            write(writer, record)
        end
    end

    close(reader)
    close(writer)
end

function filter_files(df, kmers)

    for rowi in 1:nrow(df)
        sample_name = df[rowi,:rep_id]
        println(sample_name)
        forward_name = "simulated_reads/" * sample_name * "_1.fasta"
        forward_out = sample_name * "_1.filtered.fa"
        reverse_out = sample_name * "_2.filtered.fa"
        reverse_name = "simulated_reads/" * sample_name * "_2.fasta"
        filter_fasta(forward_name, forward_out, kmers)
        filter_fasta(reverse_name, reverse_out, kmers)
    end
end

function filter_reads(datafile , delimiter , diffkmers)
	if DEBUG
		println("Running filter_reads")
	end
	### main

	df = CSV.File(datafile, delim = delimiter) |> DataFrame

	kmers = Dict()

	for kmer in eachline(diffkmers)
		kmers[kmer] = 1
	end

	filter_files(df, kmers)
end

dic = Dict( "DEBUG"=>"false",
            "datadir"=>"data",
            "VERBOSE"=>"false",
            "outfile"=>"hashcounts.tsv",
            "arg_delimiter"=>"=",
            "out_delim"=>"\t",
            "frame_delimiter"=>"\t",
            "dataframe"=>"",
            "diffkmers"=>"diffkmers.txt" )

dic = loadARGS(dic)

filter_reads(dic["dataframe"] , dic["out_delim"] , dic["diffkmers"])