## packages
library(tidyverse)
library(readxl)

## data
zip = read_excel('C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\store\\Final Zip Codes for UIUC-URI survey 10 cities.xlsx')

## make sure leading zeros are included
zip = zip %>% 
  rename(state = State, 
         city = City, 
         zip = `Zip code`) %>% 
  mutate(zip   = as.character(zip),
         zip   = case_when(nchar(zip)<5 ~ paste0('0',zip), T ~ zip),
         city  = sub(" ", "_", city),
         email = paste0(city, '_', state, '_', zip, '@illinois.edu'))

## order for qualtrics
zip = zip %>% relocate(email, zip, city, state)

##export
zip %>% write_csv('C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\store\\zipcodes_qualtrics.csv')

## long to wide to paste into qualtrics
zip2 = zip %>% select(zip, city, state) %>% 
  group_by(city) %>% 
  mutate(col= seq(n())) %>% 
  pivot_wider(names_from = col,
              values_from = zip) %>% 
  ungroup() %>% 
  mutate(regex = apply(zip2 %>% select(-city), 1, function(x) paste(x[!is.na(x)], collapse = "|"))) %>% 
  select(city, state, regex)

## print fill regex to consol, just cycle through as needed
zip2[10,3][[1]]

# ## get list of zips for each city
# cities = zip %>% select(city) %>% distinct()
# 
# ## loop over for easy extraction
# zips = list()
# for (i in 1:nrow(cities)){
# zips[[i]] <- zip %>% filter(city %in% cities[i,]) %>% select(zip, city)
# }
# 
# ## view
# list(zips[[1]][1])
