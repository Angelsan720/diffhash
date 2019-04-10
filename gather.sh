for file in *.pe.*
do
  extract-paired-reads.py ${file} && \
        rm ${file}
done