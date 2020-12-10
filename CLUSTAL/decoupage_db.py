import argparse
import os
import re
import sys

def isfile(path):
    """Check if path is an existing file.
      :Parameters:
          path: Path to the file
    """
    if not os.path.isfile(path):
        if os.path.isdir(path):
            msg = "{0} is a directory".format(path)
        else:
            msg = "{0} does not exist.".format(path)
        raise argparse.ArgumentTypeError(msg)

    return path

def get_arguments():
    '''Retrieves the arguments of the program.
      Returns: An object that contains the arguments
    '''
    parser = argparse.ArgumentParser(description=__doc__, usage="{0} -h"
                                     .format(sys.argv[0]))
    parser.add_argument('-i', dest='database', type=isfile,
                        default="../data/human_proteome_cross_pdb/isoforme-uniprot-database-homo+sapiens-reviewed.fasta",
                        help="data for parsing prot+iso")
    parser.add_argument('-o', dest='repository', type=str,
                        default="prot+iso_cross_pdb/",
                        help="repository where the results are stored")
    return parser.parse_args()


def seq_read_fasta(filename, repository):
    ''' Lit un fichier fasta et enregistre protéine + isoformes
        (quand ils existent) dans un fichier portant le nom de la protéine
    '''
    seq = []
    flag = False

    with open(filename, "r") as filin:
        for line in filin.readlines():
            if line.startswith(">") and seq:
                if re.search("Isoform", line):
                    seq.append("\n"+line)
                    flag = True
                else:
                    if flag:
                        with open(file_out_tmp, "w") as filout:
                            filout.write("".join(seq))
                    seq = []
                    seq.append(line)
                    flag = False
                    file_out_tmp = repository + line[4:10] + ".fasta"
                    #print(file_out_tmp)
            elif line.startswith(">"):
                seq.append(line)
                file_out_tmp = repository + line[4:10] + ".fasta"
                #print(file_out_tmp)
            else:
                seq.append(line.rstrip('\n'))

        with open(file_out_tmp, "w") as filout:
            filout.write("".join(seq))

    return seq


if __name__ == '__main__':
    args = get_arguments()
    seq_read_fasta(args.database, args.repository)
