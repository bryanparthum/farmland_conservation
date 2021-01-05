# Written by: Bryan Parthum; bparthum@gmail.com ; December 2020

###################################################################################
##########################     1) Table 1  - Preference Space           ###########
##########################     2) Table 2  - WTP from Preference Space  ###########
###################################################################################

####################################################
#####################################   PACKAGE SHOP
####################################################

# install.packages('data.table')
# install.packages('stargazer')

####################################################
########   Check for and load Packages   ###########
####################################################

## Clear worksace
rm(list = ls())
gc()

## This function will check if a package is installed, and if not, install it
pkgTest <- function(x) {
  if (!require(x, character.only = T))
  {
    install.packages(x, dep = T)
    if(!require(x, character.only = T)) stop("Package not found")
  }
}

## These lines load the required packages
packages <- c("data.table","stargazer",'memisc','gmnl','here','tidyverse','magrittr') ## you can add more packages here
lapply(packages, pkgTest)

####################################################
#####################   Load and generate dataframes    
####################################################

## Set working directory
setwd(here())

## LOAD NULL MODEL
null_model <- readRDS("output/estimates/null_model.rds")

## LOAD PREFERENCE SPACE MODELS
pref_clogit         <- readRDS("output/estimates/pref_clogit.rds")
pref_uncorr         <- readRDS("output/estimates/pref_uncorr.rds")
pref                <- readRDS("output/estimates/pref.rds")
pref_het_water      <- readRDS("output/estimates/pref_het_water.rds")
pref_het_water_resp <- readRDS("output/estimates/pref_het_water_resp.rds")
pref_het_water_resp_1m <- readRDS("output/estimates/pref_het_water_resp_1m.rds")
pref_het_water_resp_2019 <- readRDS("output/estimates/pref_het_water_resp_2019.rds")

## LOAD PREFERENCE SPACE WTP 
pref_clogit_wtp         <- readRDS("output/estimates/pref_clogit_wtp.rds")
pref_uncorr_wtp         <- readRDS("output/estimates/pref_uncorr_wtp.rds")
pref_wtp                <- readRDS("output/estimates/pref_wtp.rds")
pref_het_water_wtp      <- readRDS("output/estimates/pref_het_water_wtp.rds")
pref_het_water_resp_wtp <- readRDS("output/estimates/pref_het_water_resp_wtp.rds")
pref_het_water_resp_1m_wtp <- readRDS("output/estimates/pref_het_water_resp_1m_wtp.rds")
pref_het_water_resp_2019_wtp <- readRDS("output/estimates/pref_het_water_resp_2019_wtp.rds")

# ## LOAD WTP-SPACE MODELS
# wtp_pooled  <- readRDS(file="estimates/wtp_pooled.rds")
# wtp_asc     <- readRDS(file="estimates/wtp_asc.rds")
# wtp_rural   <- readRDS(file="estimates/wtp_rural.rds")
# wtp_urban   <- readRDS(file="estimates/wtp_urban.rds")
# 
# ## LOAD CERTAINTY ADJUSTMENT MODELS
# wtp_cert1   <- readRDS(file="estimates/wtp_certainty_1.rds")
# wtp_cert2   <- readRDS(file="estimates/wtp_certainty_2.rds")

####################################################
##################################  PREFERENCE SPACE
####################################################

mcfad_r2 <- function(x,y) {round(1-(as.numeric(logLik(x))/as.numeric(logLik(y))),2)}
pref_clogit$sumstat$McFadden  <- mcfad_r2(pref_clogit,null_model)
pref_uncorr$sumstat$McFadden  <- mcfad_r2(pref_uncorr,null_model)
pref$sumstat$McFadden         <- mcfad_r2(pref,null_model)

## Export
getSummary <- getSummary.gmnl

pref_space <- mtable("C-logit"=pref_clogit,"MXL Uncorrelated"=pref_uncorr,"MXL Correlated"=pref,
                    digits=3,
                    summary.stats = c("N","Log-likelihood",'McFadden',"AIC",'BIC')) %>% 
  relabel(pref_space,
        sq = "Status-Quo",
        cov12 = "Coverage: 12 Miles",
        acc175 = "Accuracy 1: 75%",
        acc1100 = "Accuracy 1: 100%",
        acc275 = "Accuracy 2: 75%",
        acc2100 = "Accuracy 2: 100%",
        bid = 'Cost')
# write.mtable(pref_space, file="output/tables/pref_space.tex", format="LaTeX")

####################################################
############################  PREFERENCE SPACE - WTP
####################################################

pref_space_wtp <- capture.output(stargazer(pref_pooled_wtp,pref_asc_wtp,pref_rural_wtp,pref_urban_wtp,
                                 title=c("Empirical Distributions of MWTP from Preference-space Models"),
                                 keep.stat=c("n","lr","aic",'bic','ll'),
                                 digits=2,digits.extra=0,no.space=T,align=F,notes.append=T,object.names=F,model.names=F,model.numbers=T,
                                 column.labels = c("Pooled",'ASC Heterogeneity','Rural',"Urban"),
                                 add.lines = list(c('AIC',round(AIC(pref_pooled),2),round(AIC(pref_asc),2),round(AIC(pref_rural),2),round(AIC(pref_urban),2)),
                                                  c('McF R2',pref_mcf_pooled,pref_mcf_asc,pref_mcf_rural,pref_mcf_urban),
                                                  c('LRT','pref_lrt','','','')),
                                 type='text',
                                 out="output/tables/pref_space_wtp.doc"))

####################################################
###############################  STANDARD DEVIATIONS
####################################################

vcov(wtp_pooled, what = "ranp", type = "sd", se = "true")
vcov(wtp_asc, what = "ranp", type = "sd", se = "true")
vcov(wtp_rural, what = "ranp", type = "sd", se = "true")
vcov(wtp_urban, what = "ranp", type = "sd", se = "true")

vcov(pref_pooled, what = "ranp", type = "sd", se = "true")
vcov(pref_asc, what = "ranp", type = "sd", se = "true")
vcov(pref_rural, what = "ranp", type = "sd", se = "true")
vcov(pref_urban, what = "ranp", type = "sd", se = "true")

####################################################
################################  CORELLATION MATRIX
####################################################

vcov(wtp_pooled, what = "ranp", type = "cor")
vcov(wtp_rural, what = "ranp", type = "cor")
vcov(wtp_urban, what = "ranp", type = "cor")

## END OF SCRIPT. Have a great day!