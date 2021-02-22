setwd("~/Documents/Projet_long/DISOPRED/results_disopred/results_reduce/")

library(stringr)
require(MASS)

list_files = as.vector(read.table("list_files_diso.txt")[,1])

list_diso_result = list()
cpt = 2

list_diso_result[[1]] = read.table(list_files[1], skip = 3)
name_prot = str_sub(list_files[1],1, 6)

for (file in list_files[2:length(list_files)]) {
  list_diso_result[[cpt]] = read.table(file, skip = 3)
  cpt = cpt + 1
}


str_sub(list_files[1],1, 6)
list_files[2]

