#!/bin/bash

for file in ../../data/mini_data/*.fasta; do
	echo ${file:1:6}
	../../psipred/BLAST+/runpsipredplus $file
done

