ERROR: LoadError: BioSequences.FASTA.Reader file format error on line 1 ~>"for file"
Stacktrace:
 [1] error(::Type, ::String, ::Int64, ::String, ::String) at ./error.jl:42
 [2] _read!(::BioSequences.FASTA.Reader, ::BioCore.Ragel.State{BufferedStreams.BufferedInputStream{IOStream}}, ::BioSequences.FASTA.Record) at /home/angelsan720/.julia/packages/BioCore/YBJvb/src/ReaderHelper.jl:164
 [3] read!(::BioSequences.FASTA.Reader, ::BioSequences.FASTA.Record) at /home/angelsan720/.julia/packages/BioCore/YBJvb/src/ReaderHelper.jl:134
 [4] tryread!(::BioSequences.FASTA.Reader, ::BioSequences.FASTA.Record) at /home/angelsan720/.julia/packages/BioCore/YBJvb/src/IO.jl:73
 [5] iterate at /home/angelsan720/.julia/packages/BioCore/YBJvb/src/IO.jl:84 [inlined] (repeats 2 times)
 [6] filter_file(::String, ::Dict{Any,Any}, ::Bool) at /home/angelsan720/github/diffhash/filter-reads.jl:15
 [7] filter_files(::DataFrame, ::Dict{Any,Any}, ::String, ::Bool) at /home/angelsan720/github/diffhash/filter-reads.jl:41
 [8] filter_reads(::String, ::String, ::String, ::String, ::Bool) at /home/angelsan720/github/diffhash/filter-reads.jl:56
 [9] top-level scope at none:0
 [10] include at ./boot.jl:317 [inlined]
 [11] include_relative(::Module, ::String) at ./loading.jl:1044
 [12] include(::Module, ::String) at ./sysimg.jl:29
 [13] exec_options(::Base.JLOptions) at ./client.jl:266
 [14] _start() at ./client.jl:425
in expression starting at /home/angelsan720/github/diffhash/filter-reads.jl:68
