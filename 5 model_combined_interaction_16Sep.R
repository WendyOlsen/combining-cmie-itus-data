#########################################################
# Flogit Model - Data combined model
# Implementation in STAN
# Code for the manuscript:
# 
# Olsen et al.
#########################################################
# Authors:
# Jihye Kim, 
# Social Statistics Department, UOM
#########################################################
# Run the Poisson  
# using STAN
# Requires: rstan, tidyverse, tictoc


rm(list=ls(all=TRUE))
#install.packages("tidyverse")
#install.packages("rstan")
#install.packages("tictoc")

library(tidyverse)
library(rstan)
library(tictoc)

pkgbuild::has_build_tools(debug = TRUE)
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
Sys.which("make")


#########################################################
######### download data and sampling for model  #########
#########################################################

setwd("D:/")
sample_itus <- read.csv("C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Model/Data/sample_itus_1609.csv")
sample_cmie <- read.csv("C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Model/Data/sample_cmie_1609.csv")
#sample_combined <- bind_rows(sample_cmie, sample_itus)
#write.csv(sample_combined, "C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Model/Data/sample_combined_1609.csv")
#sample_combined <- read.csv("C:/Users/USER/Dropbox (The University of Manchester)/IATUR/Model/Data/sample_combined_1609.csv")
########################################################
##########DATA cleaning for models #####################
########################################################

line.data <-list( "fetime" = c(sample_itus$fetime,sample_cmie$fetime),
			"fhtime" = c(sample_itus$fetime,sample_cmie$fhtime),
			"fwtime" = c(sample_itus$fwtime,sample_cmie$fwtime),
			"umemployed" = c(sample_itus$unemployed,sample_cmie$unemployed),
                  "female" = c(sample_itus$female,sample_cmie$female),
                  "age" = c(sample_itus$age_c,sample_cmie$age_c),
                  "age2" = c(sample_itus$age2_z,sample_cmie$age2_z),
                  "evermarried" = c(sample_itus$evermarried,sample_cmie$evermarried),
                  "hhsize" = c(sample_itus$hhsize_c,sample_cmie$hhsize_c),
                  "depndt_child" = c(sample_itus$depndt_child_u15_pc,sample_cmie$depndt_child_u15_pc),
                  "expenditure" = sample_itus$expenditure_z,
                  "fwt" = c(sample_itus$fwt,sample_cmie$fwt),
                  "lockdown" = c(sample_itus$lockdown,sample_cmie$lockdown),
                  "wave" = c(sample_itus$wave,sample_cmie$wave),
                  "urban" = c(sample_itus$urban,sample_cmie$urban),
                  "unemployed" = c(sample_itus$unemployed,sample_cmie$unemployed),
                  "N"=80000)

####################################################################
################ ITUS & CMIE - Fetime INTERACTION ##################
####################################################################

Model3.e.int <- "
 data {

   // Covariates
   int  N;
   int <lower=0, upper=1> female[N];
   int <lower=0, upper=1> evermarried[N]; 
   int <lower=0, upper=1> urban[N];
   int <lower=0, upper=1> unemployed[N];
   int <lower=1, upper=26> fwt[N]; 
   int <lower=1, upper=4> wave[N]; 
   real age[N];
   real age2[N];
   real depndt_child[N]; 
   real hhsize[N]; 
   real lockdown[N];   
   real expenditure[35000];  
   // outcome
   real <lower=0, upper=1> fetime[N];
}

parameters {
real alpha[10];
real kappa[4];
real kappa2[4];
}


model {

 //Priors
  alpha[1] ~ normal(0.0, 1);
  alpha[2] ~ normal(0.0, 1);
  alpha[3] ~ normal(0.0, 1);
  alpha[4] ~ normal(0.0, 1);
  alpha[5] ~ normal(0.0, 1);
  alpha[6] ~ normal(0.0, 1);
  alpha[7] ~ normal(0.0, 1);
  alpha[8] ~ normal(0.0, 1);
  alpha[9] ~ normal(0.0, 1);
  alpha[10] ~ normal(0.0, 1);
  kappa ~ normal(0.0, 1);
  kappa2 ~ normal(0.0, 1);

//ITUS
  for (i in 1:35000) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[10]*expenditure[i] + kappa[wave[i]] + kappa2[wave[i]]*female[i]), fetime[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[10]*expenditure[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-fetime[i])*fwt[i]));
}

 //CMIE
  for (i in 35001:N) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), fetime[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-fetime[i])*fwt[i]));
}
}
"
init <- function() list(alpha=rep(0.1, 10), kappa=rep(0.1, 4), kappa2=rep(0.1, 4))

tic()
fit3.e.int <- stan(model_code = Model3.e.int, data = line.data, init=init, iter = 800, warmup=300, chains = 2)
toc()

saveRDS(fit3.e.int, "fit3.e.int.rds")



####################################################################
################ ITUS & CMIE - Fhtime INTERACTION ##################
####################################################################

Model3.h.int <- "
 data {

   // Covariates
   int  N;
   int <lower=0, upper=1> female[N];
   int <lower=0, upper=1> evermarried[N]; 
   int <lower=0, upper=1> urban[N];
   int <lower=0, upper=1> unemployed[N];
   int <lower=1, upper=26> fwt[N]; 
   int <lower=1, upper=4> wave[N]; 
   real age[N];
   real age2[N];
   real depndt_child[N]; 
   real hhsize[N]; 
   real lockdown[N];   
   real expenditure[35000];  
   // outcome
   real <lower=0, upper=1> fhtime[N];
}

parameters {
real alpha[10];
real kappa[4];
real kappa2[4];
}


model {

 //Priors
  alpha[1] ~ normal(0.0, 1);
  alpha[2] ~ normal(0.0, 1);
  alpha[3] ~ normal(0.0, 1);
  alpha[4] ~ normal(0.0, 1);
  alpha[5] ~ normal(0.0, 1);
  alpha[6] ~ normal(0.0, 1);
  alpha[7] ~ normal(0.0, 1);
  alpha[8] ~ normal(0.0, 1);
  alpha[9] ~ normal(0.0, 1);
  alpha[10] ~ normal(0.0, 1);
  kappa ~ normal(0.0, 1);
  kappa2 ~ normal(0.0, 1);

//ITUS
  for (i in 1:35000) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[10]*expenditure[i] + kappa[wave[i]] + kappa2[wave[i]]*female[i]), fhtime[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[10]*expenditure[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-fhtime[i])*fwt[i]));
}

 //CMIE
  for (i in 35001:N) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), fhtime[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-fhtime[i])*fwt[i]));
}
}
"
init <- function() list(alpha=rep(0.1, 10), kappa=rep(0.1, 4), kappa2=rep(0.1, 4))

tic()
fit3.h.int <- stan(model_code = Model3.h.int, data = line.data, init=init, iter = 800, warmup=300, chains = 2)
toc()

saveRDS(fit3.h.int, "fit3.h.int.rds")


####################################################################
################ ITUS & CMIE - Fwtime INTERACTION ##################
####################################################################

Model3.w.int <- "
 data {

   // Covariates
   int  N;
   int <lower=0, upper=1> female[N];
   int <lower=0, upper=1> evermarried[N]; 
   int <lower=0, upper=1> urban[N];
   int <lower=0, upper=1> unemployed[N];
   int <lower=1, upper=26> fwt[N]; 
   int <lower=1, upper=4> wave[N]; 
   real age[N];
   real age2[N];
   real depndt_child[N]; 
   real hhsize[N]; 
   real lockdown[N];   
   real expenditure[35000];  
   // outcome
   real <lower=0, upper=1> fwtime[N];
}

parameters {
real alpha[10];
real kappa[4];
real kappa2[4];
}


model {

 //Priors
  alpha[1] ~ normal(0.0, 1);
  alpha[2] ~ normal(0.0, 1);
  alpha[3] ~ normal(0.0, 1);
  alpha[4] ~ normal(0.0, 1);
  alpha[5] ~ normal(0.0, 1);
  alpha[6] ~ normal(0.0, 1);
  alpha[7] ~ normal(0.0, 1);
  alpha[8] ~ normal(0.0, 1);
  alpha[9] ~ normal(0.0, 1);
  alpha[10] ~ normal(0.0, 1);
  kappa ~ normal(0.0, 1);
  kappa2 ~ normal(0.0, 1);

//ITUS
  for (i in 1:35000) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[10]*expenditure[i] + kappa[wave[i]] + kappa2[wave[i]]*female[i]), fwtime[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[10]*expenditure[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-fwtime[i])*fwt[i]));
}

 //CMIE
  for (i in 35001:N) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), fwtime[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[8]*unemployed[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-fwtime[i])*fwt[i]));
}
}
"
init <- function() list(alpha=rep(0.1, 10), kappa=rep(0.1, 4), kappa2=rep(0.1, 4))

tic()
fit3.w.int <- stan(model_code = Model3.w.int, data = line.data, init=init, iter = 800, warmup=300, chains = 2)
toc()

saveRDS(fit3.w.int, "fit3.w.int.rds")


####################################################################
################ ITUS & CMIE - Fwtime INTERACTION ##################
####################################################################

Model3.u.int <- "
 data {

   // Covariates
   int  N;
   int <lower=0, upper=1> female[N];
   int <lower=0, upper=1> evermarried[N]; 
   int <lower=0, upper=1> urban[N];
   int <lower=1, upper=26> fwt[N]; 
   int <lower=1, upper=4> wave[N]; 
   real age[N];
   real age2[N];
   real depndt_child[N]; 
   real hhsize[N]; 
   real lockdown[N];   
   real expenditure[35000];  
   // outcome
   real <lower=0, upper=1> unemployed[N];
}

parameters {
real alpha[10];
real kappa[4];
real kappa2[4];
}


model {

 //Priors
  alpha[1] ~ normal(0.0, 1);
  alpha[2] ~ normal(0.0, 1);
  alpha[3] ~ normal(0.0, 1);
  alpha[4] ~ normal(0.0, 1);
  alpha[5] ~ normal(0.0, 1);
  alpha[6] ~ normal(0.0, 1);
  alpha[7] ~ normal(0.0, 1);
  alpha[8] ~ normal(0.0, 1);
  alpha[9] ~ normal(0.0, 1);
  alpha[10] ~ normal(0.0, 1);
  kappa ~ normal(0.0, 1);
  kappa2 ~ normal(0.0, 1);

//ITUS
  for (i in 1:35000) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i]  + alpha[10]*expenditure[i] + kappa[wave[i]] + kappa2[wave[i]]*female[i]), unemployed[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i]  + alpha[10]*expenditure[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-unemployed[i])*fwt[i]));
}

 //CMIE
  for (i in 35001:N) {
  1 ~ bernoulli(pow(inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), unemployed[i]*fwt[i])*
                 pow(1-inv_logit(alpha[1]*female[i] + alpha[2]*age[i] + alpha[3]*age2[i]  + alpha[4]*evermarried[i] + alpha[5]*hhsize[i] + alpha[6]*depndt_child[i] + alpha[7]*urban[i] + alpha[9]*lockdown[i] + kappa[wave[i]]+ kappa2[wave[i]]*female[i]), (1-unemployed[i])*fwt[i]));
}
}
"
init <- function() list(alpha=rep(0.1, 10), kappa=rep(0.1, 4), kappa2=rep(0.1, 4))

tic()
fit3.u.int <- stan(model_code = Model3.u.int, data = line.data, init=init, iter = 800, warmup=300, chains = 2)
toc()

saveRDS(fit3.u.int, "fit3.u.int.rds")


########################################################
################ Prediction   ##########################
########################################################

print(fit3.e, pars = c("alpha", "kappa"))
print(fit3.e.int, pars = c("alpha", "kappa"))

fit3.e <- readRDS("fit3.e.rds")
fit3.e.int <- readRDS("fit3.e.int.rds")

# prediction without interaction
d <- as.data.frame(fit3.e)
alpha0 <- d[, grep("alpha[", colnames(d), fixed = T)]
dim(alpha0)
head(alpha0)
kappa0 <- d[, grep("kappa[", colnames(d), fixed = T)]
coef0 <- cbind(alpha0, kappa0)
coef <- coef0[rep(1:1000, each=26172), ]
summary(coef)

myvars <- c("female", "age_new", "age2_new", "evermarried", "hhsize_new", "depndt_child_new",  "urban", "lockdown", "expenditure_new", "wave1", "wave2", "wave3", "wave4")
sample_itus$wave1 <- as.numeric(sample_itus$wave==1)
sample_itus$wave2 <- as.numeric(sample_itus$wave==2)
sample_itus$wave3 <- as.numeric(sample_itus$wave==3)
sample_itus$wave4 <- as.numeric(sample_itus$wave==4)


df1 <- sample_itus[myvars]
df1 <- df1[c(1,2,3,4,5,6,7,8,9,10,11,12,13)]
summary(df1)

myvars <- c("female", "age_new", "age2_new", "evermarried", "hhsize_new", "depndt_child_new",  "urban", "lockdown", "wave1", "wave2", "wave3", "wave4")
sample_cmie$wave1 <- as.numeric(sample_cmie$wave==1)
sample_cmie$wave2 <- as.numeric(sample_cmie$wave==2)
sample_cmie$wave3 <- as.numeric(sample_cmie$wave==3)
sample_cmie$wave4 <- as.numeric(sample_cmie$wave==4)

df2 <- sample_cmie[myvars]
head(df2)
df2$expenditure_new <- 0
df2 <- df2[c(1,2,3,4,5,6,7,8,13,9,10,11,12)]
summary(df2)

df3 <- rbind(df1, df2)

df0 <- df3[rep(1:26172, each=1000), ]
p0 <- coef*df0
p0$p <-  GMCM:::inv.logit(rowSums(p0))

p0$wave <- sample_combined$wave[rep(1:26172, each=1000)]
summary(p0)

table0 <- p0  %>% group_by (wave) %>%
  summarize(mean = mean(p), sd = sd(p), n = n()/1000, lower2.5 = quantile(p, probs = 0.025), lower25 = quantile(p, probs = 0.25), mid = quantile(p, probs = 0.5) , upper75 = quantile(p, probs = 0.75), upper97.5 = quantile(p, 0.975))
table0

# prediction with interaction
d <- as.data.frame(fit3.e.int)
alpha0 <- d[, grep("alpha[", colnames(d), fixed = T)]
dim(alpha0)
head(alpha0)
kappa0 <- d[, grep("kappa[", colnames(d), fixed = T)]
kappa2 <- d[, grep("kappa2[", colnames(d), fixed = T)]
coef0 <- cbind(alpha0, kappa0, kappa2)
coef <- coef0[rep(1:1000, each=26172), ]
summary(coef)

myvars <- c("female", "age_new", "age2_new", "evermarried", "hhsize_new", "depndt_child_new",  "urban", "lockdown", "expenditure_new", "wave1", "wave2", "wave3", "wave4", "wave_fem1", "wave_fem2", "wave_fem3", "wave_fem4")
sample_itus$wave1 <- as.numeric(sample_itus$wave==1)
sample_itus$wave2 <- as.numeric(sample_itus$wave==2)
sample_itus$wave3 <- as.numeric(sample_itus$wave==3)
sample_itus$wave4 <- as.numeric(sample_itus$wave==4)
sample_itus$wave_fem1 <- as.numeric(sample_itus$wave*sample_itus$female==1)
sample_itus$wave_fem2 <- as.numeric(sample_itus$wave*sample_itus$female==2)
sample_itus$wave_fem3 <- as.numeric(sample_itus$wave*sample_itus$female==3)
sample_itus$wave_fem4 <- as.numeric(sample_itus$wave*sample_itus$female==4)

df1 <- sample_itus[myvars]
df1 <- df1[c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)]
summary(df1)

myvars <- c("female", "age_new", "age2_new", "evermarried", "hhsize_new", "depndt_child_new",  "urban", "lockdown", "wave1", "wave2", "wave3", "wave4", "wave_fem1", "wave_fem2", "wave_fem3", "wave_fem4")
sample_cmie$wave1 <- as.numeric(sample_cmie$wave==1)
sample_cmie$wave2 <- as.numeric(sample_cmie$wave==2)
sample_cmie$wave3 <- as.numeric(sample_cmie$wave==3)
sample_cmie$wave4 <- as.numeric(sample_cmie$wave==4)
sample_cmie$wave_fem1 <- as.numeric(sample_cmie$wave*sample_cmie$female==1)
sample_cmie$wave_fem2 <- as.numeric(sample_cmie$wave*sample_cmie$female==2)
sample_cmie$wave_fem3 <- as.numeric(sample_cmie$wave*sample_cmie$female==3)
sample_cmie$wave_fem4 <- as.numeric(sample_cmie$wave*sample_cmie$female==4)

df2 <- sample_cmie[myvars]
head(df2)
df2$expenditure_new <- 0
df2 <- df2[c(1,2,3,4,5,6,7,8,17,9,10,11,12,13,14,15,16)]
summary(df2)

df3 <- rbind(df1, df2)

df0 <- df3[rep(1:26172, each=1000), ]
p0 <- coef*df0
p0$p <-  GMCM:::inv.logit(rowSums(p0))

p0$wave <- sample_combined$wave[rep(1:26172, each=1000)]
summary(p0)

table0 <- p0  %>% group_by (wave) %>%
  summarize(mean = mean(p), sd = sd(p), n = n()/1000, lower2.5 = quantile(p, probs = 0.025), lower25 = quantile(p, probs = 0.25), mid = quantile(p, probs = 0.5) , upper75 = quantile(p, probs = 0.75), upper97.5 = quantile(p, 0.975))
table0

# observed outcome
table0 <- sample_combined  %>% group_by (wave) %>%
  summarize(mean = mean(fetime), sd = sd(fetime), n = n(), lower2.5 = quantile(fetime, probs = 0.025), lower25 = quantile(fetime, probs = 0.25), mid = quantile(fetime, probs = 0.5) , upper75 = quantile(fetime, probs = 0.75), upper97.5 = quantile(fetime, 0.975))
table0
