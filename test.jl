function t()
	let x::UInt128 = 1
		while x!=0
			x += 1
		end
	return x-1
	end
end

function t2()
	t()
end
#@time print(t2())
function defaults(a,b=4,x=5,y=6)
    return "$a $b and $x $y"
end

#print(defaults(1))

#print(readdir(".git"))

#print(occursin("/","//"))
#print("abc"[2])

#print(occursin("abc","a"))
#import Pkg; Pkg.add("DataFrames")

using CSV
using DataFrames
file = "sim_rep_info.txt"
df = CSV.File(file, delim = "\t") |> DataFrame
println(size(df, 1))
println(df[1,:rep_id])