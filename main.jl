#=########################################################
Angel A. Sanquiche Sanchez
angelsan720@gmail.com
angel.sanquiche@upr.edu
801-13-7075
=#########################################################

#=First thing to note
^^ is how to start a multiline comment
and you end one with ->=#

#nano does not play nice with these multiline comments

#########################################################
#julia command line arguments exist within ARGS which is iterable

#########################################################
#=
#this is a for loop
for x in ARGS
	#indentation doesnt define scope but I will use TAB to make the the code more legible unless I forget or explicitly do not wish to use tab 
	println(x)
#fors need an end at the end
end
########################################################
=#

#now to start the important stuff
dic = Dict{String,String}()
#this section bellow will contain the different settings that will controll the code we will be modifying
#we will initialyze the settings with some default values and a few place holders for later use
dic["threads"]="1"
dic["working_dir"]="."
dic["data_source"]="file.fasta"
dic["out_dir"]="output"
dic["arg_delimiter"]="="
dic["DEBUG"]="False"
dic["verbose"]="True"
#dic[]=
#more will be added as this grows

#now we add whatever arguments the user wants
for line in ARGS
	s = split(line , dic["arg_delimiter"])
	if (length(s)==2)
		try
			dic[s[1]]=s[2] #as a computer science student I find arrays not starting at zero blasphemous

		catch e
			println(e)
		end

	end
end
if dic["DEBUG"]=="true"

	print("Julia Version:\t")
	println(VERSION)

	print("Julia Path:\t")
	println(Sys.BINDIR)

	print("CPU Threads:\t")
	println(Sys.CPU_THREADS)

	print("Architecturet:\t")
	println(Sys.ARCH)

	print("Memory\n")
	print("Total:\t")
	print(floor(Sys.total_memory()/2^20))
	println("MB")
	print("Free:\t")
	print(floor(Sys.free_memory()/2^20))
	println("MB")

	print("OS:\t")
	println(Sys.MACHINE)

	print("Arguments:\n")
	for arg in ARGS
		println(arg)
	end

	#print()
	#println()
	#print()
	#println()
	#print()
	#println()
end
include("diffhash.jl")
include("showhash.jl")
include("filter-reads.jl")

DEBUG=dic["DEBUG"]=="true"

diffhash("simulated_reads/sim_rep_info.txt" , "\t" , DEBUG)
showhash(DEBUG=DEBUG)
filter_reads(DEBUG=DEBUG)