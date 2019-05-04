import pandas as pd
l = [(	"long-normal.txt",
	"normal-long.txt"),
(	"short-long.txt",
	"long-short.txt"),
(	"normal-short.txt",
	"short-normal.txt")]








for a , b in l:
	print(a , b)
	a = pd.read_csv(a,	header=None,	sep='\t')
	b = pd.read_csv(b,	header=None,	sep='\t')
	a = a[[0,1]]
	b = b[[1,0]]
	a.columns = ["a","b"]
	b.columns = ["a","b"]
	c = pd.merge(a, b, how='inner')
	#print(a.info())
	#print(b.info())
	#print(c.info())
	#print(c.describe())
	c.to_csv("brh",sep='\t')
	print(c.to_latex())
