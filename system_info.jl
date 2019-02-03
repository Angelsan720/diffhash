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
