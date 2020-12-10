#!/bin/bash

for file in ./prot+iso_data_reduce/*.fasta; do
	echo ${file:23:12}
	#./clustalo -i $file -o ./results_clustal_cross_pdb/${file:21:12}
	#./clustalo -i $file --outfmt=vienna -o ./results_clustal_cross_pdb_vienna/${file:21:6}.asi
	./clustalo -i $file -o ./results_clustal_data_reduce/${file:23:12} --force
done

