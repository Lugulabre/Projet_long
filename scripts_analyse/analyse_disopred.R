#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args == 0)) {
  #setwd("~/Documents/Projet_long/DISOPRED/results_disopred/results_reduce/")
  setwd("~/Documents/M2_BI/Projet_long/DISOPRED/results_disopred/results_reduce/")
}else{
  setwd(args[1])
}


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
                                     iso = rep(cpt_iso, nrow(list_diso_result[[cpt]])),
                                     name = rep(str_c(str_sub(list_files[1],1, 6), "-", cpt_iso),
                                                nrow(list_diso_result[[cpt]]) ))
list_chi2_diso[[cpt]] = data.frame(c(length(which(list_diso_result[[cpt]]$V3 == "." )),
                                     length(which(list_diso_result[[cpt]]$V3 == "*" ))))
cpt_iso = cpt_iso + 1
name_prot = str_sub(list_files[1],1, 6)

for (file in list_files[2:length(list_files)]) {
  if (str_sub(file,1, 6) == name_prot) {
    df_tmp = read.table(file, skip = 3)
    
    df_tmp = data.frame(df_tmp,
                        iso = rep(cpt_iso, nrow(df_tmp)),
                        name = rep(str_c(str_sub(file,1, 6), "-", cpt),
                                   nrow(df_tmp) ) ) 
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
                                         iso = rep(cpt_iso,nrow(list_diso_result[[cpt]])),
                                         name = rep(str_c(str_sub(file,1, 6), "-", cpt_iso),
                                                nrow(list_diso_result[[cpt]]) ) )
    list_chi2_diso[[cpt]] = data.frame(c(length(which(list_diso_result[[cpt]]$V3 == "." )),
                                         length(which(list_diso_result[[cpt]]$V3 == "*" ))))
    name_prot = str_sub(file,1, 6)
  }
  
}

# Test du chi2 pour désordre

list_pvalue = list()

for (rg_list in c(1:length(list_chi2_diso))) {
  table_tmp = list_chi2_diso[[rg_list]]
  vec_tmp = c(1)
  
  if (ncol(table_tmp) > 1) {
    for (table_col in 2:ncol(table_tmp)) {
      vec_tmp[table_col] = chisq.test(table_tmp[,c(1,table_col)])$p.value
    }
  }else{
    vec_tmp = c(1)
  }

  list_pvalue[[rg_list]] = vec_tmp
  
  # list_pvalue[[rg_list]]
  # vec_pvalue[rg_list] = chisq.test(list_chi2_diso[[rg_list]])$p.value
}

# Proportion de tests significatifs

vec_prop_chi2 = c()

for (rg_list in 1:length(list_pvalue)) {
  prop_tot = 0
  prop_sig = 0
  vec_tmp = list_pvalue[[rg_list]]
  for (rg_vec in 1:length(vec_tmp)) {
    if (!is.nan(vec_tmp[rg_vec]) & vec_tmp[rg_vec] < 0.05) {
      prop_sig = prop_sig + 1
      prop_tot = prop_tot + 1
    }else if( !is.nan(vec_tmp[rg_vec]) ){
      prop_tot = prop_tot + 1
    }
  }
  vec_prop_chi2[rg_list] = prop_sig/prop_tot
}

summary(vec_prop_chi2)



