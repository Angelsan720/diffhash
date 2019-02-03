using JLD

function showhash(DEBUG)
	if DEBUG
		println("Running showhash")
	end
	@load "kmers.jld" kmers
	#@show kmers
	out = ""
	for (key, counts) in pairs(kmers)
		if length(counts) < sum(counts) # there's at least 1 kmer in every file
			#print("$key\t$(join(counts, "\t"))\n")
			out = string(out ,"$key\t$(join(counts, "\t"))\n")
			#print("$key\t")
			#println(join(counts, "\t"))
		end
	end
	open("hashcounts.tsv" , "w") do file
		write(file , out)
	end

	if DEBUG
		println("Finished showhash")
	for (key, counts) in pairs(kmers)
		if length(counts) < sum(counts) # there's at least 1 kmer in every file
			print("$key\t")
			println(join(counts, "\t"))
		end
	end
end
