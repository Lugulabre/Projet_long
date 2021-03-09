from Bio import SeqIO



records = SeqIO.parse("THIS_IS_YOUR_INPUT_FILE.fasta", "fasta")
count = SeqIO.write(records, "THIS_IS_YOUR_OUTPUT_FILE.pir", "pir")
print("Converted %i records" % count)