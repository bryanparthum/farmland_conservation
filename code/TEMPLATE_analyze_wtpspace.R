## Written by: Bryan Parthum; bparthum@gmail.com ; February 2019

###################################################################################
###############################    WTP-SPACE MODELS    ############################
###################################################################################

####################################################
########   Check for and load Packages   ###########
####################################################

## Clear worksace
rm(list = ls())
gc()

## This function will check if a package is installed, and if not, install it
pkgTest <- function(x) {
  if (!require(x, character.only = TRUE))
  {
    install.packages(x, dep = TRUE)
    if(!require(x, character.only = TRUE)) stop("Package not found")
  }
}

## These lines load the required packages
packages <- c("gmnl","mlogit","data.table",'haven') ## you can add more packages here
lapply(packages, pkgTest)

####################################################
#####################   Load and generate dataframes
####################################################

## Set working directory
setwd("C:/Users/bparthum/Box/Sangamon/analysis/analyze")

## Read in files
data <- as.data.table(read_dta("store/analyze.dta"))

## Clean
data[, cost := as.numeric(cost)]

## Setkey and order
setkeyv(data,c('rural_identify','ind_id','group_id','alt'))

## Create mlogit data
d <-  mlogit.data(data,
                  id.var='ind_id',
                  chid.var = 'group_id',
                  choice='choice',
                  shape='long',
                  alt.var='alt',
                  opposite=c('cost'))

####################################################
############################################  POOLED
####################################################

## SET RANDOM PARAMETERS AND STARTING MATRIX
ranp_n <- 7
start <- c(1,rep(0,7),rep(0,.5*ranp_n*(ranp_n+1)),0,0)

wtp.pooled <-  gmnl(choice ~ cost + asc + distance + fish_div + fish_pop + algal_blooms + nitro_target | 0 | 0 | 0 | 1,
                    data=d,
                    ranp=c(cost='ln',asc='n',distance='n',fish_div='n',fish_pop='n',algal_blooms='n',nitro_target='n'),
                    R=500,
                    model='gmnl',
                    halton=NA,
                    panel=T,
                    correlation=T,
                    seed=42,
                    fixed = c(T,rep(F,36),T),
                    start = start,
                    method = "bhhh",
                    iterlim = 500)

summary(wtp_pooled)
saveRDS(wtp.pooled,file="estimates/wtp_pooled.rds")
-exp(coef(wtp.pooled)["het.(Intercept)"])
# library("msm")
# se <- deltamethod(~ -exp(x7), coef(wtp_pooled), vcov(wtp_pooled), ses = TRUE)
# se

####################################################
#################################  ASC HETEROGENEITY
####################################################

## SET RANDOM PARAMETERS AND STARTING MATRIX
ranp_asc <- 8
start_asc <- c(1,rep(0,9),rep(0,.5*ranp_asc*(ranp_asc+1)),0,0)

wtp.asc <-  gmnl(choice ~ cost + asc + asc_rural + asc_water_knowledge + distance + fish_div + fish_pop + algal_blooms + nitro_target | 0 | 0 | 0 | 1,
                 data=d,
                 ranp=c(asc='n',asc_rural='n',asc_water_knowledge='n',distance='n',fish_div='n',fish_pop='n',algal_blooms='n',nitro_target='n'),
                 R=500,
                 model='gmnl',
                 halton=NA,
                 panel=T,
                 correlation=T,
                 seed=42,
                 fixed = c(T,rep(F,46),T),
                 start = start_asc,
                 method = "bhhh",
                 iterlim = 500)

summary(wtp.asc)
saveRDS(wtp.asc,file="estimates/wtp_asc.rds")
-exp(coef(wtp.asc)["het.(Intercept)"])

####################################################
#############################################  RURAL
####################################################

## SET RANDOM PARAMETERS AND STARTING MATRIX
ranp_n <- 7
start <- c(1,rep(0,7),rep(0,.5*ranp_n*(ranp_n+1)),0,0)

wtp.rural <-  gmnl(choice ~ cost + asc + distance + fish_div + fish_pop + algal_blooms + nitro_target | 0 | 0 | 0 | 1,
                   data=d[d$rural_identify==1],
                   ranp=c(cost='ln',asc='n',distance='n',fish_div='n',fish_pop='n',algal_blooms='n',nitro_target='n'),
                   R=500,
                   model='gmnl',
                   halton=NA,
                   panel=T,
                   correlation=T,
                   seed=42,
                   fixed = c(T,rep(F,36),T),
                   start = start,
                   method = "bhhh",
                   iterlim = 500)

summary(wtp.rural)
saveRDS(wtp.rural,file="estimates/wtp_rural.rds")
-exp(coef(wtp.rural)["het.(Intercept)"])

####################################################
#############################################  URBAN
####################################################

## SET RANDOM PARAMETERS AND STARTING MATRIX
ranp_n <- 7
start <- c(1,rep(0,7),rep(0,.5*ranp_n*(ranp_n+1)),0,0)

wtp.urban <-  gmnl(choice ~ cost + asc + distance + fish_div + fish_pop + algal_blooms + nitro_target | 0 | 0 | 0 | 1,
                    data=d[d$rural_identify==0],
                    ranp=c(cost='ln',asc='n',distance='n',fish_div='n',fish_pop='n',algal_blooms='n',nitro_target='n'),
                    R=500,
                    model='gmnl',
                    halton=NA,
                    panel=T,
                    correlation=T,
                    seed=42,
                    fixed = c(T,rep(F,36),T),
                    start = start,
                    method = "bhhh",
                   iterlim = 500)

summary(wtp.urban)
saveRDS(wtp.urban,file="estimates/wtp_urban.rds")
-exp(coef(wtp.urban)["het.(Intercept)"])

####################################################
#######################################  Null Models
####################################################

rural.null  <-   mlogit(choice ~ 1 , data=d[d$rural_identify==1])
urban.null  <-   mlogit(choice ~ 1 , data=d[d$rural_identify==0])
pooled.null <-   mlogit(choice ~ 1 , data=d)

summary(rural.null)
summary(urban.null)
summary(pooled.null)

saveRDS(rural.null,file="estimates/null_rural.rds")
saveRDS(urban.null,file="estimates/null_urban.rds")
saveRDS(pooled.null,file="estimates/null_pooled.rds")

####################################################
######################################  SAVE AS DATA
####################################################

rural.coefs <- tidy(getSummary.gmnl(wtp_rural)$coef)
rural.coefs$rural <- 1
urban.coefs <- tidy(getSummary.gmnl(wtp_urban)$coef)
urban.coefs$rural <- 0
coefs <- as.data.table(rbind(rural.coefs,urban.coefs))
setnames(coefs,'.rownames','attribute')
write_dta(coefs,'estimates/coefs.dta',version = 14) 

## END OF SCRIPT. Have a nice day! 