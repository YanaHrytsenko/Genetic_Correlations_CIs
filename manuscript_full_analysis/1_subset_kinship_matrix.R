library(tidyverse)
library(dplyr)
library(Matrix)
library(data.table)

#load annotation file
annot_file <- fread("/TOPMed/Freeze8_annotation_file/freeze8_sample_annot_2020-07-07.txt", data.table = FALSE)


JHS_only <- annot_file[which(annot_file$study == "JHS"),]


#select only JHS IDs
sample.keep <- JHS_only$sample.id
sample.keep <- data.frame(sample.keep)
colnames(sample.keep) <- "NWD_ID"

#load TOPMed kinship matrix (skm)
skm <- fread("/TOPMed/Freeze8_relatedness_kinship_matrix/freeze8_pcrelate_dense_km.txt.gz")

# set rownames
row.names(skm) <- colnames(skm)



#pull out data from the kinship matrix by IDs
kmatrS = skm[row.names(skm) %in% sample.keep$NWD_ID, colnames(skm) %in% sample.keep$NWD_ID]
dim(kmatrS) #3418 3418

# memory intensive so free up space
rm(skm)
gc()


# convert to a matrix
kmatrS = as.matrix(kmatrS)


# copy upper triangle down to create symmetrical matrix
makeSymm <- function(m) {
  m[lower.tri(m)] <- t(m)[lower.tri(m)]
  return(m)
}


kmatrS = makeSymm(kmatrS)


JHS_IDs <- sample.keep$NWD_ID
kmatrS_ordered <- kmatrS[JHS_IDs,JHS_IDs]

# confirm there are no NA rows: result should be FALSE
if(any(is.na(rowMeans(kmatrS_ordered)))) warning('There are some NAs in the matrix!')


#save as RData
#save(kmatrS_ordered, file = "/Data/Kinship_matrix/JHS_kinship_matrix.RData")
