** Written by: Bryan Parthum; bparthum@gmail.com ; September 2020

********************************************************************************
*****************   Transform experiments.csv to cards.csv   *******************
********************************************************************************

clear all
set more off

** IMPORT
use store/design_matrix_miles, clear
append using store/design_matrix_minutes
save store/design_matrix, replace
export excel using store/design_matrix.xlsx, firstrow(variables) replace

replace access = "Maintained Trails" if access=="Walking Trails"
replace access = "No Recreation" if access=="No Access"
replace access = "Trails and Tables" if access=="Tables and Trails"

** RESHAPE TO WIDE
drop alt_id 

reshape wide title cost nature farmland meals_nature meals_farmland access distance, j(alt) i(treatment block card card_id card_dcreate)
sort treatment block card

** GENERATE VARIABLES TO IDENTIFY IMAGE LOCATION WHEN GENERTAING CHOICE CARDS
gen image_nature   = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\nature_" + string(nature1) + ".png" 
gen image_farmland = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\farmland_" + string(farmland1) + ".png" 
gen image_meals_nature = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\meals_nature_" + string(meals_nature1) + ".png" 
gen image_meals_farmland = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\meals_farmland_" + string(meals_farmland1) + ".png" 
gen image_access = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\access_" + access1 + ".png" 
gen image_distance = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\miles_" + string(distance1) + ".png" if treatment == "miles"
replace image_dist = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\minutes_" + string(distance1) + ".png" if treatment == "minutes"
// gen image_cost = "C:\\Users\\bparthum\\Box\\farmland_conservation\\analyze\\farmland_git\\choice_cards\\images\\cost_" + string(cost1) + ".png" 

** GENERATE STATIC URL LINK FOR QUALTRICS
forv i=1/6 {
gen card_url_`i' = "https://bryanparthum.github.io/farmland_conservation/choice_cards/cards/" + treatment + "_block_" + string(block) + "_card_" + string(`i') + ".png"
}

** GENERATE STATIC URL LINK FOR QUALTRICS EXAMPLE CARD
gen card_url_example = "https://bryanparthum.github.io/farmland_conservation/choice_cards/cards/" + treatment + "_block_" + string(block) + "_card_6" + ".png"

** ORDER 
order treatment block card card_id title1 cost1 nature1 farmland1 meals_nature1 meals_farmland1 access1 distance1 ///
	  image_nature image_farmland image_meals_nature image_meals_farmland image_access image_distance ///
	  card_url_1 card_url_2 card_url_3 card_url_4 card_url_5 card_url_6 card_url_example ///
	  title2 cost2 nature2 farmland2 meals_nature2 meals_farmland2 access2 distance2

** SAVE FILE FOR MAILMERGE 
export excel using store\card_database.xlsx, firstrow(variables) replace
export excel using ..\choice_cards\card_database.xlsx, firstrow(variables) replace

** GENERATE CONTACT LIST FOR QUALTRICS CONTACTS/EMBEDDED DATA
keep treatment block card_url_example card_url_1 card_url_2 card_url_3 card_url_4 card_url_5 card_url_6
duplicates drop
gen Email = treatment + "_block_" + string(block) + "_conservation_survey@illinois.edu"

export delimited using ..\choice_cards\qualtrics_contacts.csv, replace

** END OF SCRIPT. Have a nice day!
