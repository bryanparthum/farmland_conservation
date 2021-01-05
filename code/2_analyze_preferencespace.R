## Written by: Bryan Parthum; bparthum@gmail.com ; December 2020

###################################################################################
##########################   PREFERENCE-SPACE MODELS    ###########################
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
packages <- c("gmnl","mlogit","data.table",'here','readr','tidyverse','magrittr') ## you can add more packages here
lapply(packages, pkgTest)

####################################################
#####################   Load and generate dataframes
####################################################

## Set working directory
setwd(here())

## Read in files
data <- read_csv("store/cleaned_data.csv")

## drop protest. ask Klaus why does protNO==-999 in many cases? 
data %<>% dplyr::filter(protNO!=1)  

## keep only relevant columns
data %<>% dplyr::select(id, set, idset, # choice set variables
                        choice,sq,cov12,acc175,acc1100,acc275,acc2100,bid, # primary variables of interest
                        watercolor2018,respirr2018,watercolor2019,respirr2019,watercolor_1m,respirr_1m, # beach observations
                        income, # individual characteristics, any others?
                        cov12ec,acc175ec,acc1100ec,acc275ec,acc2100ec) # effects coding variables

## sort and generate unique id for each alternative
data %<>% group_by(idset) %>% mutate(alt = seq(n()))
data %<>% arrange(id,set,idset) 
data %<>% mutate(bid = as.numeric(bid))

## create interactions for heterogeneity 
data %<>% mutate(sq_income = sq * income,
                 sq_watercolor2018 = sq * watercolor2018,
                 sq_watercolor2019 = sq * watercolor2019,
                 sq_watercolor_1m = sq * watercolor_1m,
                 sq_respirr2018 = sq * respirr2018,
                 sq_respirr2019 = sq * respirr2019,
                 sq_respirr_1m = sq * respirr_1m)


## Create mlogit data
d <-  mlogit.data(data,
                  # shape='long', 
                  drop.index = TRUE,
                  id.var='id', ## unique to individual_id
                  chid.var = 'idset', ## unique to individual_id and card_id
                  choice='choice',
                  shape='long',
                  alt.var='alt') ## the number alternative on each card
                  # opposite=c('bid')) ## bid is already opposite in Klaus' cleaning


####################################################
#######################################  Null Models
####################################################

null_model <- mlogit(choice ~ sq | 0 , data=d)
summary(null_model)
saveRDS(null_model,file="output/estimates/null_model.rds")

####################################################
#############################################  BASIC
####################################################

## Klaus' basic MNL: clogit choice sq cov12 acc175 acc1100 acc275 acc2100 bid, group(idset), if protNO~=1 

pref_clogit <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid | 0 ,
                     data=d,
                     model='mnl')

summary(pref_clogit)
saveRDS(pref_clogit,file="output/estimates/pref_clogit.rds")

## WTP
pref_clogit_wtp <- wtp.gmnl(pref_clogit, wrt = "bid")
saveRDS(pref_clogit_wtp,file="output/estimates/pref_clogit_wtp.rds")

####################################################
#######################  INTRODUCE RANDOM PARAMETERS
####################################################

start <- proc.time()
pref_uncorr <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid | 0 ,
                    data=d,
                    ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                    model='mixl',
                    panel=TRUE,
                    correlation=FALSE,
                    seed=42)

summary(pref_uncorr)
saveRDS(pref_uncorr,file="output/estimates/pref_uncorr.rds")
proc.time() - start

## WTP
pref_uncorr_wtp <- wtp.gmnl(pref_uncorr, wrt = "bid")
saveRDS(pref_uncorr_wtp,file="output/estimates/pref_uncorr_wtp.rds")

####################################################
#################################  ASC HETEROGENEITY
####################################################

# start <- proc.time()
# het_income <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_income | 0 ,
#                     data=d,
#                     ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n',sq_income='n'),
#                     model='mixl',
#                     panel=TRUE,
#                     correlation=FALSE,
#                     seed=42,
#                     method = "bhhh",
#                     iterlim = 500,
#                     halton=NA)
# 
# summary(het_income)
# saveRDS(het_income,file="output/estimates/het_income.rds")
# proc.time() - start
# 
# ## WTP
# het_income_wtp <- wtp.gmnl(het_income, wrt = "bid")
# saveRDS(het_income_wtp,file="output/estimates/het_income_wtp.rds")

####################################################
#####################  CORRELLATED RANDOM PARAMETERS
####################################################

start <- proc.time()
pref <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid | 0 ,
                     data=d,
                     ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                     model='mixl',
                     panel=TRUE,
                     correlation=TRUE,
                     seed=42,
                     method = "bhhh",
                     iterlim = 500,
                     halton=NA)

summary(pref)
saveRDS(pref,file="output/estimates/pref.rds")
proc.time() - start
pref_wtp <- wtp.gmnl(pref, wrt = "bid")
saveRDS(pref_wtp,file="output/estimates/pref_wtp.rds")

####################################################
#################################  ASC HETEROGENEITY
####################################################

# start <- proc.time()
# het_water <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_watercolor2019 + sq_watercolor_1m | 0 ,
#                     data=d,
#                     ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n',sq_watercolor2019='n',sq_watercolor_1m='n'),
#                     model='mixl',
#                     panel=TRUE,
#                     correlation=FALSE,
#                     seed=42,
#                     method = "bhhh",
#                     iterlim = 500,
#                     halton=NA)
# 
# summary(het_water)
# saveRDS(het_water,file="output/estimates/het_water.rds")
# het_water_wtp <- wtp.gmnl(het_water, wrt = "bid")
# saveRDS(het_water_wtp,file="output/estimates/het_water_wtp.rds")
# proc.time() - start

####################################################
#######################################  WATER COLOR
####################################################

start <- proc.time()
pref_het_water <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_watercolor2019 + sq_watercolor_1m | 0 ,
                   data=d,
                   ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                   model='mixl',
                   panel=TRUE,
                   correlation=TRUE,
                   seed=42,
                   method = "bhhh",
                   iterlim = 500,
                   halton=NA)

summary(pref_het_water)
saveRDS(pref_het_water,file="output/estimates/pref_het_water.rds")
pref_het_water_wtp <- wtp.gmnl(pref_het_water, wrt = "bid")
saveRDS(pref_het_water_wtp,file="output/estimates/pref_het_water_wtp.rds")
proc.time() - start

####################################################
################################### WATER COLOR 2019 
####################################################

start <- proc.time()
pref_het_water_2019 <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_watercolor2019 | 0 ,
                        data=d,
                        ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                        model='mixl',
                        panel=TRUE,
                        correlation=TRUE,
                        seed=42,
                        method = "bhhh",
                        iterlim = 500,
                        halton=NA)

summary(pref_het_water_2019)
saveRDS(pref_het_water_2019,file="output/estimates/pref_het_water_2019.rds")
pref_het_water_2019_wtp <- wtp.gmnl(pref_het_water_2019, wrt = "bid")
saveRDS(pref_het_water_2019_wtp,file="output/estimates/pref_het_water_2019_wtp.rds")
proc.time() - start

####################################################
##############  WATER COLOR AND RESPIRATORY WARNINGS
####################################################

start <- proc.time()
pref_het_water_resp <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_watercolor2019 + sq_watercolor_1m + sq_respirr2019 + sq_respirr_1m | 0 ,
                        data=d,
                        ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                        model='mixl',
                        panel=TRUE,
                        correlation=TRUE,
                        seed=42,
                        method = "bhhh",
                        iterlim = 500,
                        halton=NA)

summary(pref_het_water_resp)
saveRDS(pref_het_water_resp,file="output/estimates/pref_het_water_resp.rds")
pref_het_water_resp_wtp <- wtp.gmnl(pref_het_water_resp, wrt = "bid")
saveRDS(pref_het_water_resp_wtp,file="output/estimates/pref_het_water_resp_wtp.rds")
proc.time() - start

####################################################
#########  WATER COLOR AND RESPIRATORY WARNINGS 2019
####################################################

start <- proc.time()
pref_het_water_resp_2019 <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_watercolor2019 + sq_respirr2019 | 0 ,
                             data=d,
                             ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                             model='mixl',
                             panel=TRUE,
                             correlation=TRUE,
                             seed=42,
                             method = "bhhh",
                             iterlim = 500,
                             halton=NA)

summary(pref_het_water_resp_2019)
saveRDS(pref_het_water_resp_2019,file="output/estimates/pref_het_water_resp_2019.rds")
pref_het_water_resp_2019_wtp <- wtp.gmnl(pref_het_water_resp_2019, wrt = "bid")
saveRDS(pref_het_water_resp_2019_wtp,file="output/estimates/pref_het_water_resp_2019_wtp.rds")
proc.time() - start

####################################################
######  WATER COLOR AND RESPIRATORY WARNINGS 1 MONTH
####################################################

start <- proc.time()
pref_het_water_resp_1m <-  gmnl(choice ~ sq + cov12 + acc175 + acc1100 + acc275 + acc2100 + bid + sq_watercolor_1m + sq_respirr_1m | 0 ,
                             data=d,
                             ranp=c(cov12='n',acc175='n',acc1100='n',acc275='n',acc2100='n'),
                             model='mixl',
                             panel=TRUE,
                             correlation=TRUE,
                             seed=42,
                             method = "bhhh",
                             iterlim = 500,
                             halton=NA)

summary(pref_het_water_resp_1m)
saveRDS(pref_het_water_resp_1m,file="output/estimates/pref_het_water_resp_1m.rds")
pref_het_water_resp_1m_wtp <- wtp.gmnl(pref_het_water_resp_1m, wrt = "bid")
saveRDS(pref_het_water_resp_1m_wtp,file="output/estimates/pref_het_water_resp_1m_wtp.rds")
proc.time() - start

####################################################
##### CORRELLATED RANDOM PARAMETERS - EFFECTS CODING
####################################################

start <- proc.time()
pref_effects_coding <-  gmnl(choice ~ sq + cov12ec + acc175ec + acc1100ec + acc275ec + acc2100ec + bid | 0 ,
              data=d,
              ranp=c(cov12ec='n',acc175ec='n',acc1100ec='n',acc275ec='n',acc2100ec='n'),
              model='mixl',
              panel=TRUE,
              correlation=TRUE,
              seed=42,
              method = "bhhh",
              iterlim = 500,
              halton=NA)

summary(pref_effects_coding)
saveRDS(pref_effects_coding,file="output/estimates/pref_effects_coding.rds")
proc.time() - start
pref_effects_coding_wtp <- wtp.gmnl(pref_effects_coding, wrt = "bid")
saveRDS(pref_effects_coding_wtp,file="output/estimates/pref_effects_coding_wtp.rds")

## END OF SCRIPT. Have a nice day! 