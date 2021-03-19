# Projet_long

### Data
Les données étudiées se trouvent dans le sous-répertoire data/mini_data.
Le fichier original est data/data_sample.fasta.
Celui-ci est composée d'une dizaine de protéines prises aléatoirement dans la base de données du protéome humain d'uniprot se retrouvant dans la pdb.
Les fichiers pdb correspondant se situent dans le sous-répertoire data/mini_data_pdb
L'association fasta-pdb de ces fichiers est indiquée dans le fichier data/list_uniprot_pdb.txt.
Le script python data/fasta_unique.py permet de séparer un fichier dans lequel sont concaténées plusieurs séquences fasta de différentes protéines en plusieurs fichiers, chacun contenant une séquence au format fasta, et appelée par son identifiant uniprot.

### Psipred
Le dossier psipred contient l'outil de prédition de structures secondaires en local.
Les résultats obtenus sont dans le répertoire results_psipred/results_reduce, dans lequel on trouve également le script bash run_all_psipred.sh permettant d'obtenir les résultats.