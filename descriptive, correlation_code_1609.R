#title: "descriptive table, correlation matrix"
#author: "Jihye Kim"
#date: "16/09/2021"

library(tidyverse)
library(lme4)
#install.packages("lme4")
#install.packages("Hmisc")
library(Hmisc)

data_cmie <- read_csv("C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Model/Data/data_cmie_16Sep.csv")
data_itus <- read_csv("C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Model/Data/data_itus_16Sep.csv")


sum_data_cmie <- data_cmie %>% ungroup() %>%  summarise_at( c("wtime", "htime","etime", "fwtime", "fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"),
                                                           funs(mean=sum(. * fwt)/sum(fwt), min, max))

sum_data_cmie_w1 <- data_cmie %>% filter( wave==1) %>% ungroup() %>%  summarise_at( c("wtime", "htime","etime", "fwtime", "fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"),
                                                            funs(mean=sum(. * fwt)/sum(fwt), min, max))
sum_data_cmie_w2 <- data_cmie %>% filter( wave==2) %>% ungroup() %>%  summarise_at( c("wtime", "htime","etime", "fwtime", "fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"),
                                                                                  funs(mean=sum(. * fwt)/sum(fwt), min, max))
sum_data_cmie_w3 <- data_cmie %>% filter( wave==3) %>% ungroup() %>%  summarise_at( c("wtime", "htime","etime", "fwtime", "fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"),
                                                                                    funs(mean=sum(. * fwt)/sum(fwt), min, max))
sum_data_cmie_w4 <- data_cmie %>% filter( wave==4) %>% ungroup() %>%  summarise_at( c("wtime", "htime","etime", "fwtime", "fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"),
                                                                                    funs(mean=sum(. * fwt)/sum(fwt), min, max))

sum_data_itus <- data_itus %>% ungroup() %>%  summarise_at( c("wtime", "htime","etime", "fwtime", "fhtime","fetime","unemployed","age", "age_c", "age2_z", "female", "urban", "hhsize", "hhsize_c", "evermarried","depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary",  "wave", "fwt", "weight",  "expenditure", "expenditure_z"),
                                                            funs(mean=sum(. * fwt)/sum(fwt), min, max))


write.csv(sum_data_cmie, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_summary.csv")
write.csv(sum_data_cmie_w1, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_summary_w1.csv")
write.csv(sum_data_cmie_w2, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_summary_w2.csv")
write.csv(sum_data_cmie_w3, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_summary_w3.csv")
write.csv(sum_data_cmie_w4, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_summary_w4.csv")


write.csv(sum_data_itus, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_itus_16Sep_summary.csv")

cmie_cor <- subset(data_cmie, select=c("wtime","htime","etime","fwtime","fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"))

data_cmie_w1 <- data_cmie %>% filter( wave==1)
cmie_cor_w1 <- subset(data_cmie_w1, select=c("wtime","htime","etime","fwtime","fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"))

data_cmie_w2 <- data_cmie %>% filter( wave==2)
cmie_cor_w2 <- subset(data_cmie_w2, select=c("wtime","htime","etime","fwtime","fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"))

data_cmie_w3 <- data_cmie %>% filter( wave==3)
cmie_cor_w3 <- subset(data_cmie_w3, select=c("wtime","htime","etime","fwtime","fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"))

data_cmie_w4 <- data_cmie %>% filter( wave==4)
cmie_cor_w4 <- subset(data_cmie_w4, select=c("wtime","htime","etime","fwtime","fhtime","fetime","unemployed","age", "age_c", "age2_z","female","urban", "hhsize", "hhsize_c", "evermarried", "depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary", "wave", "fwt", "weight"))


itus_cor <- subset(data_itus, select=c("wtime","htime","etime","fwtime","fhtime","fetime","unemployed","age", "age_c", "age2_z", "female", "urban", "hhsize", "hhsize_c", "evermarried","depndt_child_under15", "depndt_child_u15_pc", "depndt_child_under13", "havingchildunder13", "havingchildunder15", "lockdown", "belowprimary", "primary_scndry", "abovesecondary",  "wave", "fwt", "weight",  "expenditure", "expenditure_z"))
write.csv(cor(cmie_cor), "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_cor.csv")
write.csv(cor(itus_cor), "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_itus_16Sep_cor.csv")

write.csv(cor(cmie_cor_w1), "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_cor_w1.csv")
write.csv(cor(cmie_cor_w2), "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_cor_w2.csv")
write.csv(cor(cmie_cor_w3), "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_cor_w3.csv")
write.csv(cor(cmie_cor_w4), "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Descriptive Table/data_cmie_16Sep_cor_w4.csv")


