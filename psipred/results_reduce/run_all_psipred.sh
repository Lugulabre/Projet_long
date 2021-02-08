#!/bin/bash

for file in ../../data/mini_data/*.fasta; do
	echo ${file:1:6}
	../BLAST+/runpsipredplus $file
done

