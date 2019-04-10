for filename in *R1*.extract.fastq
do
     # first, make the base by removing .extract.fastq.gz
     base=$(basename $filename .extract.fastq)
     #echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1/_R2}
     #echo $baseR2

     # construct the output filename
     output=${base/_R1/}.pe.extract.fastq

     interleave-reads.py ${base}.extract.fastq ${baseR2}.extract.fastq > $output
     #echo $filename
done