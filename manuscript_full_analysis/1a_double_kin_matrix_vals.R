library(tidyverse)
library(dplyr)
library(Matrix)
library(data.table)

#load annotation file
annot_file <- fread("/TOPMed/Freeze8_annotation_file/freeze8_sample_annot_2020-07-07.txt", data.table = FALSE)
dim(annot_file) 

JHS_only <- annot_file[which(annot_file$study == "JHS"),]


#select only JHS IDs
sample.keep <- JHS_only$sample.id
sample.keep <- data.frame(sample.keep)
colnames(sample.keep) <- "NWD_ID"

kinMat <- readRDS("/Data/Kinship_matrix/20240125_JHS_freeze8_pcrelate_dense_km.rds")
dim(kinMat) #3418 3418

isSymmetric(kinMat) #TRUE


#we need to multiply each value of the matrix by two because the original values are closer to 0.5 than to 1 
kinMat_mult_by_two <- 2*kinMat


# confirm there are no NA rows: result should be FALSE
if(any(is.na(rowMeans(kinMat_mult_by_two)))) warning('There are some NAs in the matrix!')


saveRDS(kinMat_mult_by_two, file = "/Data/Kinship_matrix/JHS_kinship_matrix_from_dense_TOPMed_freeze_8.rds")
