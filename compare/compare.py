import pandas as pd
a = "long/blast"
b = "normal/blast"
a = pd.read_csv(a,	header=None,	sep='\t')
b = pd.read_csv(b,	header=None,	sep='\t')

a = a[[0,1]]
b = b[[1,0]]
a.columns = ["normal","long"]
b.columns = ["normal","long"]
c = pd.merge(a, b, how='inner')
print(a.info())
print(b.info())
print(c.info())
print(c.describe())
c.to_csv("brh",sep='\t')

