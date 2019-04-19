import pandas as pd
f1 = "normal/output_file"
f2 = "diffhash/output_file"

db1 = pd.read_csv(f1,	header=None,	sep='\t')
db2 = pd.read_csv(f2,	header=None,	sep='\t')
db1 = db1[[0,1]]
db2 = db2[[1,0]]
db1.columns = ["diff","norm"]
db2.columns = ["diff","norm"]

intersected_df = pd.merge(db1, db2, how='inner')
print(intersected_df)
intersected_df.to_csv("WEDONE",sep='\t')
#print(db1.head())
#print(db2.head())
