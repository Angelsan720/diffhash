import sys

for counter , line in enumerate(open(sys.argv[1],'r').read().split("\n")):
	if line:
		print(f">{counter}\n{line}")