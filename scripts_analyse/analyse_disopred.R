setwd("~/Documents/Projet_long/DISOPRED/results_disopred/results_reduce/")

library(plyr)
library(stringr)
require(MASS)

list_files = as.vector(read.table("list_files_diso.txt")[,1])


#Liste des data frame de protéines avec un data frame par protéine + isoformes
list_diso_result = list()
list_chi2_diso = list()
cpt = 1
cpt_iso = 1

list_diso_result[[cpt]] = read.table(list_files[cpt], skip = 3)
list_diso_result[[cpt]] = data.frame(list_diso_result[[cpt]],
                                     iso = as.factor(rep(cpt_iso, nrow(list_diso_result[[cpt]]))))
list_chi2_diso[[cpt]] = data.frame(c(length(which(list_diso_result[[cpt]]$V3 == "." )),
                                     length(which(list_diso_result[[cpt]]$V3 == "*" ))))
cpt_iso = cpt_iso + 1
name_prot = str_sub(list_files[1],1, 6)

for (file in list_files[2:length(list_files)]) {
  if (str_sub(file,1, 6) == name_prot) {
    df_tmp = read.table(file, skip = 3)
    df_tmp = data.frame(df_tmp,
                        iso = as.factor(rep(cpt_iso, nrow(df_tmp))))
    cpt_iso = cpt_iso + 1
    list_diso_result[[cpt]] = rbind(list_diso_result[[cpt]], df_tmp)
    vec_tmp = c(length(which(df_tmp$V3 == "." )),
                length(which(df_tmp$V3 == "*" )))
    list_chi2_diso[[cpt]] = cbind(list_chi2_diso[[cpt]], vec_tmp)
  }else{
    cpt = cpt + 1
    cpt_iso = 1
    list_diso_result[[cpt]] = read.table(file, skip = 3)
    list_diso_result[[cpt]] = data.frame(list_diso_result[[cpt]],
                                         iso = as.factor(rep(cpt_iso,
                                                             nrow(list_diso_result[[cpt]]))))
    list_chi2_diso[[cpt]] = data.frame(c(length(which(list_diso_result[[cpt]]$V3 == "." )),
                                         length(which(list_diso_result[[cpt]]$V3 == "*" ))))
    name_prot = str_sub(file,1, 6)
  }
  
}

b = list_chi2_diso[[1]]
a = list_diso_result[[1]]

vec_pvalue = c()
for (rg_list in c(1:length(list_chi2_diso))) {
  vec_pvalue[rg_list] = chisq.test(list_chi2_diso[[rg_list]])$p.value
}
vec_pvalue[which(vec_pvalue < 0.05)]


