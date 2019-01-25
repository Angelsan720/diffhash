julia julia-setup.jl
Rscript diffhash.R;
if [ ! -f hashcounts.tsv ]; then
  julia showhash.jl > hashcounts.tsv
fi
Rscript diffhash.R;
