#!/bin/bash

for file in ../data/mini_data/*.fasta; do
	echo ${file:19:8}
	./run_disopred_plus.pl $file
done

mv ../data/mini_data/*.diso ./results_disopred/results_reduce/
mv ../data/mini_data/*.diso2 ./results_disopred/results_reduce/

ls ./results_disopred/results_reduce/*.diso > ./results_disopred/results_reduce/list_files_diso.txt
