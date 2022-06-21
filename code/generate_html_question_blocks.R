## package shop ----

# remotes::install_github('sumtxt/qsf', build_vignettes=TRUE)
# vignette("using-qsf")

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

packages <- c('tidyverse','magrittr',
              'jsonlite', 'tidyjson')
lapply(packages, pkgTest)


## data ----
q = read_json('survey/NIFA_Conservation.qsf')

## find function 
find <- function(obj, string)
{
  lapply(obj, function(x) {
    if(is.list(x))
      find(x, string)
    else grepl(string, x, fixed=TRUE)
  })
}

## search json
# jsonlite::toJSON(find(q, "miles_b1_q1"), auto_unbox=TRUE, pretty=TRUE)
cards = q$SurveyElements[[26]]

cards$Payload$QuestionText = paste0("<img src=\"https://conservationsurvey.s3.us-east-2.amazonaws.com/block1_card_1.png\" width=\"1100\" height=\"1700\">")

## iterate through 5 blocks and 6 questions and 2 treatments
t = cards %>% mutate(Payload$Payload$QuestionText)
