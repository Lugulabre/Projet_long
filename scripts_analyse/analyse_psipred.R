setwd("~/Documents/M2_BI/Projet_long/results_psipred/results_reduce/")

library(stringr)
require(MASS)

#Liste des noms de fichiers avec prédiction ss
list_pred = read.table("list_file.txt",  stringsAsFactors = FALSE)

list_pred = list_pred[-which(list_pred == "all_prot.horiz"),]

#################################################
#Création data frame concaténation séquences

df_seq = matrix(data = NA, nrow = 95, ncol = 3)
df_seq = as.data.frame(df_seq)
colnames(df_seq) = c("name", "pred", "aa")

row_df = 1

for (name_prot in list_pred) {
  tmp = read.table(name_prot, sep = "\n",
                   stringsAsFactors = FALSE)
  
  num_pred = seq(from = 2, to = nrow(tmp), by = 4)
  seq_pred = ""
  for (i in num_pred) {
    seq_pred = str_c(seq_pred, str_remove(tmp[i,][1], "Pred: "))
  }
  
  num_aa = seq(from = 3, to = nrow(tmp), by = 4)
  seq_aa = ""
  for (i in num_aa) {
    seq_aa = str_c(seq_aa, str_remove(tmp[i,][1], "  AA: "))
  }
  
  df_seq[row_df, 3] = seq_aa
  df_seq[row_df, 2] = seq_pred
  df_seq[row_df, 1] = str_split(name_prot, ".h")[[1]][1]
  len_str = str_length(df_seq[row_df, 1])
  if (len_str > 6) {
    df_seq[row_df, 1] = str_c(str_sub(df_seq[row_df, 1], 1, 6), "-",
                              str_sub(df_seq[row_df, 1], 7, len_str))
  }
  row_df = row_df + 1
}

#Ajout désordre
setwd("~/Documents/M2_BI/Projet_long/DISOPRED/results_disopred/results_reduce/")

list_files = as.vector(read.table("list_files_diso.txt")[,1])

df_seq$diso = NA

for (file in list_files) {
  df_tmp = read.table(file, skip = 3)
  file = str_split(file, ".d")[[1]][1]
  
  if (str_length(file) > 6) {
    name = str_c(str_sub(file, 1, 6), "-", str_sub(file, 7, str_length(file)))
  }else{
    name = str_sub(file, 1, 6)
  }
  
  if (length(which(df_seq$name == name)) !=0) {
    seq_tmp = ""
    for (i in 1:length(df_tmp$V3)) {
      seq_tmp = str_c(seq_tmp, df_tmp$V3[i])
    }
    df_seq$diso[which(df_seq$name == name)] = seq_tmp
  }
  
}
remove(df_tmp)
remove(seq_tmp)

#Fin création dataframe
#################################################

setwd("~/Documents/M2_BI/Projet_long/CLUSTAL/results_clustal/results_clustal_data_reduce/")

#Liste des noms de fichiers résultats clustal
list_clust = read.table("list_file.txt",  stringsAsFactors = FALSE)
list_clust = list_clust[,1]

df_align = c("1st col", "2nd col")

for (filename in list_clust) {
  filin = read.table(filename, sep = "\n")
  seq_tmp = ""
  for (n_line in c(1:nrow(filin))) {
    if(str_detect(filin[n_line,], ">")  ){
      if(seq_tmp != ""){
        df_align = rbind(df_align, c(title_tmp, seq_tmp))
        title_tmp = str_split(as.character(filin[n_line,]),"\\|")[[1]][2]
        seq_tmp = ""
      }else{
        title_tmp = str_split(as.character(filin[n_line,]),"\\|")[[1]][2]
      }
    }else{
      seq_tmp = str_c(seq_tmp, filin[n_line,])
    }
  }
  df_align = rbind(df_align, c(title_tmp, seq_tmp))
}

df_align = as.data.frame(df_align[-1,])

#Ajouter gap aux séquences psipred

df_seq$align_pred = NA
df_seq$align_diso = NA

for (name in df_align$V1) {
  ind = which(df_align$V1 == name)
  if (length(ind) != 0) {
    align_tmp = df_align$V2[ind]
    align_tmp = str_split(align_tmp, "")[[1]]
    posgap = which(align_tmp == "-")
    posaa = which(align_tmp != "-")
    apred = str_split(df_seq$pred[which(df_seq$name == name)], "")[[1]]
    adiso = str_split(df_seq$diso[which(df_seq$name == name)], "")[[1]]
    
    apregap = c()
    apregap[posgap] = "-"
    apregap[posaa] = apred
    apregap_col = ""
    
    adisogap = c()
    adisogap[posgap] = "-"
    adisogap[posaa] = adiso
    adisogap_col = ""
    
    for (i in 1:length(apregap)) {
      apregap_col = str_c(apregap_col, apregap[i])
    }
    for (i in 1:length(adisogap)) {
      adisogap_col = str_c(adisogap_col, adisogap[i])
    }
    df_seq$align_pred[which(df_seq$name == name)] = apregap_col
    df_seq$align_diso[which(df_seq$name == name)] = adisogap_col
    
  }
}
remove(apregap)
remove(apregap_col)
remove(adisogap)
remove(adisogap_col)

#Calcul des proportions psipred

df_seq$C = NA
df_seq$E = NA
df_seq$H = NA
df_seq$res.no.diso = NA
df_seq$res.diso = NA

for (rg_row in 1:nrow(df_seq)) {
  df_seq$C[rg_row] = str_count(df_seq$pred[rg_row], "C")
  df_seq$H[rg_row] = str_count(df_seq$pred[rg_row], "H")
  df_seq$E[rg_row] = str_count(df_seq$pred[rg_row], "E")
  df_seq$res.no.diso[rg_row] = str_count(df_seq$diso[rg_row], "\\.")
  df_seq$res.diso[rg_row] = str_count(df_seq$diso[rg_row], "\\*")
}

#Calcul des matchs psipred

df_seq$pvalue_psipred = 0
df_seq$match_psipred = 0
df_seq$mismatch_psipred = 0
df_seq$prop_match_psipred = 0

prot_ref = df_seq[1,]

for (rg_row in 2:nrow(df_seq)) {
  if (str_detect(df_seq$name[rg_row], prot_ref$name)) {
    
    if (!is.na(df_seq$align_pred[rg_row])) {

      vec_ref = str_split(prot_ref$align_pred, "")[[1]]
      vec_alg = str_split(df_seq$align_pred[rg_row], "")[[1]]
      
      #match mismatch
      for (rg in 1:length(vec_ref)) {
        if (vec_ref[rg] == vec_alg[rg]) {
          df_seq$match_psipred[rg_row] = df_seq$match_psipred[rg_row] + 1
        }else if (vec_alg[rg] != "-") {
          df_seq$mismatch_psipred[rg_row] = df_seq$mismatch_psipred[rg_row] + 1
        }
      }
      df_seq$prop_match_psipred = df_seq$match_psipred/(df_seq$match_psipred+df_seq$mismatch_psipred)
      
      #pvalue proportions
      df_seq$pvalue_psipred[rg_row] = chisq.test(rbind(prot_ref[,7:9], df_seq[rg_row,7:9]))$p.value
    
    }
    
  }else{
    prot_ref = df_seq[rg_row,]
  }
}


#Calcul des matchs disopred

df_seq$pvalue_diso = 0
df_seq$match_diso = 0
df_seq$mismatch_diso = 0
df_seq$prop_match_diso = 0

prot_ref = df_seq[1,]

for (rg_row in 2:nrow(df_seq)) {
  if (str_detect(df_seq$name[rg_row], prot_ref$name)) {
    
    if (!is.na(df_seq$align_diso[rg_row])) {
      
      vec_ref = str_split(prot_ref$align_diso, "")[[1]]
      vec_alg = str_split(df_seq$align_diso[rg_row], "")[[1]]
      
      #match mismatch
      for (rg in 1:length(vec_ref)) {
        if (vec_ref[rg] == vec_alg[rg]) {
          df_seq$match_diso[rg_row] = df_seq$match_diso[rg_row] + 1
        }else if (vec_alg[rg] != "-") {
          df_seq$mismatch_diso[rg_row] = df_seq$mismatch_diso[rg_row] + 1
        }
      }
      df_seq$prop_match_diso = df_seq$match_diso/(df_seq$match_diso+df_seq$mismatch_diso)
      
      #pvalue proportions
      df_seq$pvalue_diso[rg_row] = chisq.test(rbind(prot_ref[,10:11], df_seq[rg_row,10:11]))$p.value
      
    }
    
  }else{
    prot_ref = df_seq[rg_row,]
  }
}

#Résumé stats
print("Résumé des matchs psipred avec alignement")
summary(df_seq$prop_match_psipred)
print("Code uniprot des protéines avec moins de 80% de match")
df_seq$name[which(df_seq$prop_match_psipred < 0.7)]
print("Proportion des p-value significatives sur psipred")
length(which(df_seq$pvalue_psipred < 0.05 & df_seq$pvalue_psipred!=0))/length(which(df_seq$pvalue_psipred!=0))


print("Résumé des matchs disopred avec alignement")
summary(df_seq$prop_match_diso)
print("Code uniprot des protéines avec moins de 80% de match")
df_seq$name[which(df_seq$prop_match_diso < 0.7)]
print("Proportion des p-value significatives sur disopred")
length(which(df_seq$pvalue_diso < 0.05 & df_seq$pvalue_diso!=0))/length(which(df_seq$pvalue_diso!=0))


