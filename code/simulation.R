## Written by: Bryan Parthum; bparthum@gmail.com ; January 2021

###################################################################################
###################   Discrete Choice Experiment: A Simulation   ##################
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
packages <- c('readxl',"gmnl","mlogit","data.table",'here','readr','tidyverse','magrittr') ## you can add more packages here
lapply(packages, pkgTest)

####################################################
#####################   Load and generate dataframes
####################################################

## Set working directory
setwd(here())

## Read experiment design from generated design
data <- read_excel('experiment_design/store/design_matrix.xlsx')

## Repeat for arbitrary number of respondents, assume one respondent per block-treatment pair 
## Three blocks of eight cards with two alternatives and two treatments in initial design
data <- bind_rows(replicate(100, data, simplify = FALSE))

## Number of individuals in sample
nrow(data)/16

## Generate unique individual identifiers
data %<>% mutate(ind_id = ceiling(row_number()/16))

## This includes both treatments. Create a unique card identifier for a pooled (both treatments) dataset
data %<>% group_by(treatment,block,card) %>%
          mutate(pooled_card_id = cur_group_id())

## Generate unique individual-card identifier (unique choice occasions)
data %<>% group_by(ind_id,pooled_card_id) %>%
          mutate(ind_card_id = cur_group_id())

## Generate random choices
set.seed(42)
data %<>% group_by(ind_card_id) %>%
          mutate(choice = sample(c(0,1), replace=FALSE, size=2)) 

## Generate alternative specific constant
data %<>% mutate(asc = ifelse(alt==2,1,0))

## Generate interactions
data %<>% mutate(distance_nature = distance * nature)
data %<>% mutate(distance_meals_nature = distance * meals_nature)

## Write to CSV 
write_csv(data,'store/simulation_data.csv')

## Create mlogit data
d <-  mlogit.data(data,
                  # shape='long', 
                  drop.index = TRUE,
                  id.var='ind_id', ## unique to individual_id
                  chid.var = 'ind_card_id', ## unique to individual_id and card_id
                  choice='choice',
                  shape='long',
                  alt.var='alt') ## the number alternative on each card
                  # opposite=c('bid')) ## if changing distribution of cost coefficient to log-normal

####################################################
#######################################  Null Models
####################################################

null_model <- mlogit(choice ~ asc | 0 , data=d)
summary(null_model)

####################################################
#############################################  BASIC
####################################################

pref_clogit <-  gmnl(choice ~ asc + cost + farmland + meals_nature + distance | 0 ,
                     data=d,
                     model='mnl')

summary(pref_clogit)

## WTP
pref_clogit_wtp <- wtp.gmnl(pref_clogit, wrt = "cost")

####################################################
######################################  INTERACTIONS
####################################################

pref_clogit <-  gmnl(choice ~ asc + cost + nature + farmland + meals_nature + meals_farmland + distance + distance_nature + distance_meals_nature | 0 ,
                     data=d,
                     model='mnl')

summary(pref_clogit)

## WTP
pref_clogit_wtp <- wtp.gmnl(pref_clogit, wrt = "cost")

# ####################################################
# #######################  INTRODUCE RANDOM PARAMETERS
# ####################################################
# 
# pref_uncorr <-  gmnl(choice ~ asc + cost + nature + farmland + meals_nature + meals_farmland + distance | 0 ,
#                     data=d,
#                     ranp=c(cost='n',nature='n',farmland='n',meals_nature='n',meals_farmland='n',distance='n'),
#                     model='mixl',
#                     panel=TRUE,
#                     correlation=FALSE,
#                     seed=42)
# 
# summary(pref_uncorr)
# 
# ## WTP
# pref_uncorr_wtp <- wtp.gmnl(pref_uncorr, wrt = "bid")

####################################################
#################################  ASC HETEROGENEITY
####################################################

####################################################
#####################  CORRELLATED RANDOM PARAMETERS
####################################################

## END OF SCRIPT. Have a nice day! 