#!/bin/bash

for file in ../../data/mini_data/*.fasta; do
	echo ${file:19:8}
	./run_disopred_plus.pl $file
done

