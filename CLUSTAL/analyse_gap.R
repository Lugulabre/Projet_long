setwd("Documents/M2_BI/Projet_long/CLUSTAL/results_clustal_cross_pdb/")

library(stringr)
require(MASS)

all_alignement = read.table(file = "all_files.fasta", sep = "\t",
                            stringsAsFactors = FALSE)


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
name_seq = rep(c("name", "seq"), 14328/2)
rownames(all_align_c) = name_seq
head(all_align_c)

all_align_c = data.frame(all_align_c)


mat_gap = c(0,0)

for (i in seq(from = 2, to = 14328, by = 2)) {
  mat_gap = rbind(mat_gap, c(-10, -10))
  mat_gap = rbind(mat_gap, str_locate_all(all_align_c[i,], "-*-")[[1]])
}

vec_nb_gap = c()
vec_lg_gap = c()
j = 1
k = 1
cpt = 0
for (i in 2:nrow(mat_gap)) {
  if ((! is.na(mat_gap[i,1])) && (mat_gap[i,1] == -10)){
    vec_nb_gap[j] = cpt
    j = j+1
    cpt = 0
  }else{
    cpt = cpt+1
    vec_lg_gap[k] = mat_gap[i,2] - mat_gap[i,1]
    if ((mat_gap[i,2] - mat_gap[i,1] > 3000)){
      print(i)
    }
    k = k+1
  }
}

vec_nb_gap = vec_nb_gap[-which(vec_nb_gap == 0)]
summary(vec_nb_gap)
truehist(vec_nb_gap)

vec_lg_gap = vec_lg_gap[-which(vec_lg_gap == 0)]
summary(vec_lg_gap)
truehist(vec_lg_gap[-which(vec_lg_gap > 200)])

which(vec_lg_gap > 3000)
