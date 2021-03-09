#!/bin/bash

for file in ./*.fasta; do
	./fasta_to_pir.sh $file

done