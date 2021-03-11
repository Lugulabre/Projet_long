setwd("~/Documents/Projet_long/psipred/results_reduce/")
#setwd("~/Documents/M2_BI/Projet_long/results_psipred/results_reduce/")

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


#Fin création dataframe
#################################################

setwd("../../CLUSTAL/results_clustal/results_clustal_data_reduce/")

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

#P27482 en trop

df_seq = data.frame(df_seq, align_pred = rep(NA, nrow(df_seq)))
for (name in df_seq$name) {
  align_tmp = df_align$V1[which(df_align$V1 == name)]
}

aalig = str_split(df_align$V2[2], "")[[1]]
pos_ = which(aalig == "-")
posaa = which(aalig != "-")
apred = str_split(df_seq$pred[2], "")[[1]]
vec_test_aa = c()
vec_test_aa[pos_] = "-"
vec_test_aa[posaa] = apred
paste(vec_test_aa)

str_locate_all(df_align$V2[2], "-")

as.character(df_align[1,1])
substr(df_align[10,1], 5, 13)

patt = "\\|.*\\|"
m = regexpr(patt, as.character(df_align[1,1]))
regmatches(df_align[1,1], m)

str_split(df_align[1,1], "\\|")[[1]][2]