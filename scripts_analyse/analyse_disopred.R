setwd("~/Documents/Projet_long/DISOPRED/results_disopred/results_reduce/")

library(stringr)
require(MASS)

list_files = as.vector(read.table("list_files_diso.txt")[,1])

list_diso_result = list()
cpt = 2
cpt_iso = 1

list_diso_result[[1]] = read.table(list_files[1], skip = 3)
list_diso_result[[1]] = data.frame(list_diso_result[[1]],
                                   iso = rep(cpt_iso, nrow(list_diso_result[[1]])))
cpt_iso = cpt_iso + 1
name_prot = str_sub(list_files[1],1, 6)

for (file in list_files[2:length(list_files)]) {
  if (str_sub(file,1, 6) == name_prot) {
    df_tmp = read.table(file, skip = 3)
  }
  list_diso_result[[cpt]] = read.table(file, skip = 3)
  cpt = cpt + 1
}


str_sub(list_files[1],1, 6)
list_files[2]

