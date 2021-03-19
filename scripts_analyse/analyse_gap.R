#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if (length(args == 0)) {
  setwd("~/Documents/M2_BI/Projet_long/CLUSTAL/results_clustal/results_clustal_cross_pdb/")
  #setwd("~/Documents/M2_BI/Projet_long/CLUSTAL/results_clustal/results_clustal_data_reduce/")
}else{
  setwd(args[1])
}

library(stringr)
require(MASS)

#Fichier d'alignement
all_alignement = read.table(file = "all_files.fasta", sep = "\t",
                            stringsAsFactors = FALSE)

#Concaténation des différentes lignes de séquences alignées en une seule
all_align_c = all_alignement[1,]
seq_tmp = ""
for (i in 2:nrow(all_alignement)) {
  if(str_detect(all_alignement[i,], ">")){
    all_align_c = rbind(all_align_c, seq_tmp)
    all_align_c = rbind(all_align_c, all_alignement[i,])
    seq_tmp = ""
  }else{
    seq_tmp = str_c(seq_tmp, all_alignement[i,])
  }
  print(i)
}
all_align_c = rbind(all_align_c, seq_tmp)
name_seq = rep(c("name", "seq"), nrow(all_align_c)/2)
rownames(all_align_c) = name_seq

all_align_c = data.frame(all_align_c)

#Passage 1 colonne nom, 1 colonne séquence
col_names = all_align_c[seq(1, nrow(all_align_c), 2),]
col_seq = all_align_c[seq(2, nrow(all_align_c), 2),]
all_align_c = data.frame(name = col_names, seq = col_seq)

#Matrice pour analyser gap (trouve les positions des gap > 1)
#On ajoute des marqueurs -10 pour savoir quand on change de séquence
mat_gap = c(0,0)

for (i in 1:nrow(all_align_c)) {
  mat_gap = rbind(mat_gap, c(-10,-10))
  mat_gap = rbind(mat_gap, str_locate_all(all_align_c[i,2], "-*-")[[1]])
}

mat_gap = mat_gap[-1,]

#Nombre de gap par séquence
vec_nb_gap = c()
#Longueur des gap détectés
vec_lg_gap = c()
j = 1
k = 1
cpt = 0
for (i in 1:nrow(mat_gap)) {
  if ((! is.na(mat_gap[i,1])) && (mat_gap[i,1] == -10)){
    vec_nb_gap[j] = cpt
    j = j+1
    cpt = 0
  }else{
    cpt = cpt+1
    vec_lg_gap[k] = mat_gap[i,2] - mat_gap[i,1]
    k = k+1
  }
}

print("Résumé statistique du nombre de gap par séquence")
vec_nb_gap = vec_nb_gap[-which(vec_nb_gap == 0)]
print(summary(vec_nb_gap))
truehist(vec_nb_gap, xlab = "Nombre de gap par séquence")
boxplot(vec_nb_gap)

print("Résumé statistique de la longueur des gap par séquence")
vec_lg_gap = vec_lg_gap[-which(vec_lg_gap == 0)]
print(summary(vec_lg_gap))
truehist(vec_lg_gap[-which(vec_lg_gap > 200)])
truehist(vec_lg_gap, xlab = "Longueur de gap")
boxplot(vec_lg_gap, main = "Boxplot des longueurs de gap")
boxplot(vec_lg_gap[which(vec_lg_gap < 500)], main = "Boxplot des longueurs de gap < 500")

