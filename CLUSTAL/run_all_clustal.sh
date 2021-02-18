#!/bin/bash

for file in ./prot+iso_cross_pdb/*.fasta; do
	echo ${file:21:12}
	#./clustalo -i $file -o ./results_clustal_cross_pdb/${file:21:12}
	./clustalo -i $file --outfmt=vienna -o ./results_clustal_cross_pdb_vienna/${file:21:6}.asi
done

