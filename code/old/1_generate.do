** Written by: Bryan Parthum; bparthum@gmail.com ; March 2018

********************************************************************************
**************   GENERATE CLEAN DATA FOR PILOT - QUALTRICS   *******************
********************************************************************************

clear all
set more off

** SET WORKING DIRECTORY
cd "C:\Users\parthum2\Box\Sangamon\analysis\analyze"

*import excel  "C:\Users\parthum2\Box Sync\Sangamon\sangamon_maps\store\cities_pilot.xlsx", sheet("experiments") firstrow clear
*replace city = subinstr(city,"_"," ",.)
*save store\pilot_qualtrics\experiments_lowcost, replace

*****************************************
**************  IMPORT RAW FROM QUALTRICS
*****************************************

import delimited store\pilot_qualtrics\pilot_qualtrics.csv, bindquote(strict)  maxquotedrows(unlimited) varnames(1)  clear

keep startdate durationinseconds recipientlastname locationlatitude locationlongitude ///
	 zip city p1-p16 gc

drop ex1

rename (durationinseconds recipientlastname locationlatitude locationlongitude gc) ///
	   (seconds reference_city lat lon qualtrics_complete)
	   
rename (p1 p2 p3) ///
	   (experience_algal experience_fish experience_rec)
	   
rename (q11 c11 q12 c12 q13 c13 q14 c14 q15 c15 q16 c16) ///
	   (card_choice11 conf11 card_choice21 conf21 ///
		card_choice31 conf31 card_choice41 conf41 ///
		card_choice51 conf51 card_choice61 conf61)

rename (q21 ch21 q22 ch22 q23 ch23 q24 ch24 q25 ch25 q26 ch26) ///
	   (card_choice12 conf12 card_choice22 conf22 ///
		card_choice32 conf32 card_choice42 conf42 ///
		card_choice52 conf52 card_choice62 conf62)

rename (q31 ch31 q32 ch32 q33 ch33 q34 ch34 q35 ch35 q36 c36) ///
	   (card_choice13 conf13 card_choice23 conf23 ///
		card_choice33 conf33 card_choice43 conf43 ///
		card_choice53 conf53 card_choice63 conf63)

rename (p4 p5 p6 p7 p8 p9 p10 p12 p14 p15 p16 p17 p18) ///
	   (rural_string income_string homeowner_string agriculture_string age_string sex_string race_string experience_waterquality check_fish check_rec comments education_string residency_string)		

drop if _n<3
 
gen ind_id = _n

reshape long card_choice1 card_choice2 card_choice3 card_choice4 card_choice5 card_choice6  ///
             conf1 conf2 conf3 conf4 conf5 conf6, ///
			 i(ind_id) j(block)
			 
forv i = 1/6{
gen choice`i' = card_choice`i'  
replace choice`i' = "Scenario A" if choice`i'=="80"
replace choice`i' = "Scenario B" if choice`i'=="Click to write Choice 2"			
} 

gen straightliner = choice1 == choice2 & choice1 == choice3 & choice1 == choice4 & choice1 == choice5 & choice1 == choice6
gen protester     = choice1 == "No Change" & choice1 == choice2 & choice1 == choice3 & choice1 == choice4 & choice1 == choice5 & choice1 == choice6

forv i = 1/6{
gen choice_certainty_1`i' = "No Change" if (choice`i' == "Scenario A" | choice`i' == "Scenario B") & (conf`i' == "0 - Not at all confident")  
replace choice_certainty_1`i' = choice`i' if choice_certainty_1`i' == ""

gen choice_certainty_2`i' = "No Change" if (choice`i' == "Scenario A" | choice`i' == "Scenario B") & (conf`i' == "0 - Not at all confident" | conf`i' == "1 - Somewhat confident")  
replace choice_certainty_2`i' = choice`i' if choice_certainty_2`i' == ""
}

reshape long choice choice_certainty_1 choice_certainty_2 conf, ///
			 i(ind_id block) j(card)			 

drop if choice == ""

replace experience_algal = substr(experience_algal,1,1)
replace experience_fish  = "5" if experience_fish == "More than 5" 
replace experience_rec   = "5" if experience_rec == "More than 5" 

replace experience_waterquality = substr(experience_algal,1,1)
replace check_fish = substr(check_fish,1,1)
replace check_rec  = substr(check_rec,1,1)

replace conf = substr(conf,1,1)

gen rural_identify = rural_string == "Yes"
gen agriculture    = agriculture_string == "Yes"
gen male           = sex == "Male"
gen white          = race_string == "White"
gen homeowner      = homeowner_string == "Yes"

*gen age     = 23.5 if age_string == "18-29 years old"
*replace age = 37   if age_string == "30-44 years old"
*replace age = 54.5 if age_string == "45-64 years old"
*replace age = 70   if age_string == "Over 65 years old"

encode age_string, generate(age)
tabulate age_string, gen(age__)

*gen income     = 20  if income_string == "Less than $25,000 per year"
*replace income = 30  if income_string == "$25,000 - $34,999 per year"
*replace income = 42.5  if income_string == "$35,000 - $49,999 per year"
*replace income = 62.5  if income_string == "$50,000 - $74,999 per year"
*replace income = 87.5  if income_string == "$75,000 - $99,999 per year"
*replace income = 125 if income_string == "$100,000 - $149,999 per year"
*replace income = 175 if income_string == "$150,000 - $199,999 per year"

encode income_string, generate(income)
tabulate income_string, gen(inc_)

encode education_string, generate(education)
tabulate education_string, gen(edu_)

*gen residency     = 1  if residency_string == "0 to 5 years"
*replace residency = 7.5 if residency_string == "5 to 10 years"
*replace residency = 15  if residency_string == "10 to 20 years"
*replace residency = 25  if residency_string == "20 to 30 years"
*replace residency = 40  if residency_string == "More than 30 years"

encode residency_string, generate(residency)
tabulate residency_string, gen(res_)

destring conf experience_algal experience_fish experience_rec experience_waterquality, force replace
destring check_fish check_rec, force replace
destring seconds lat lon zip, force replace

gen consistent = ((experience_fish  > 0 & check_fish > 0) | ///
				  (experience_fish == 0 & check_fish == 0)) & ///
				 ((experience_rec   > 0 & check_rec > 0) | ///
				  (experience_rec  == 0 & check_rec == 0))

replace startdate = substr(startdate,1,10)
gen date = date(startdate, "YMD")
format %td date
gen new_cost = date > td(14mar2019)

egen card_merge_id = group(new_cost city block card)
sort card_merge_id

save store\pilot_qualtrics\pilot_clean_qualtrics, replace
*use store\pilot_qualtrics\pilot_clean_qualtrics, clear
tempfile temp
save `temp' 

keep if new_cost==0
keep city card_merge_id block card
duplicates drop
merge 1:m city card block using store\pilot_qualtrics\experiments_highcost, nogen keep(3)
tempfile temp2
save `temp2'
 
use `temp', clear
keep if new_cost==1
keep city card_merge_id block card
duplicates drop
merge 1:m city card block using store\pilot_qualtrics\experiments_lowcost, nogen keep(3)
append using `temp2'

sort card_merge_id 

joinby card_merge_id using `temp'

order block ind_id card alt
sort block ind_id card alt 

rename (choice choice_certainty_1 choice_certainty_2) (card_choice card_choice_certainty_1 card_choice_certainty_2)

gen choice = card_choice == title
gen choice_certainty_1 = card_choice_certainty_1 == title
gen choice_certainty_2 = card_choice_certainty_2 == title

gen urban_identify = 1-rural_identify
gen asc = alt == 3 

egen group_id = group(ind_id card_id)

replace location = "A" if location == ""
gen loc_b = location == "B"
gen loc_c = location == "C"
gen loc_d = location == "D"

gen fish_div_2 = fish_div == 2
gen fish_div_3 = fish_div == 3
gen fish_div_5 = fish_div == 5

gen fish_pop_50 = fish_pop == 50
gen fish_pop_75 = fish_pop == 75
gen fish_pop_150 = fish_pop == 150

gen algal_25 = algal_blooms == 25
gen algal_50 = algal_blooms == 50
gen algal_75 = algal_blooms == 75

gen nitro_50  = nitro_target == 50
gen nitro_75  = nitro_target == 75
gen nitro_100 = nitro_target == 100

gen angler = experience_fish > 1
gen hiker = experience_rec > 1
gen algal = experience_algal > 1
gen water_knowledge = experience_waterquality > 1
gen recreator = experience_fish > 2 | experience_rec > 2

gen asc_rural   = asc * rural_identify
gen asc_male    = asc * male 
gen asc_agriculture  = asc * agriculture 
gen asc_angler = asc * angler
gen asc_hiker = asc * hiker
gen asc_recreator = asc * recreator
gen asc_algal = asc * algal
gen asc_water_knowledge = asc * water_knowledge

replace distance = A_DIST if location == "A"  
replace distance = ceil(distance)

gen minutes = seconds/60 
order minutes, after(seconds)

sum seconds, d
sum minutes, d
gen speeder = minutes<r(p10)

gen rural_asc = rural_identify * asc
gen rural_fish_div = rural_identify * fish_div
gen rural_fish_pop = rural_identify * fish_pop
gen rural_algal_blooms    = rural_identify * algal_blooms
gen rural_nitro_target    = rural_identify * nitro_target
gen rural_distance     = rural_identify * distance
gen rural_cost     = rural_identify * cost

gen rural_algal_25    = rural_identify * algal_25
gen rural_algal_50    = rural_identify * algal_50
gen rural_algal_75    = rural_identify * algal_75

gen rural_nitro_50    = rural_identify * nitro_50
gen rural_nitro_75    = rural_identify * nitro_75
gen rural_nitro_100   = rural_identify * nitro_100

gen ag_fish_div = agriculture * fish_div
gen ag_fish_pop = agriculture * fish_pop
gen ag_algal    = agriculture * algal_blooms
gen ag_nitro    = agriculture * nitro_target
gen ag_dist     = agriculture * distance
gen ag_cost     = agriculture * cost

gen ag_rural_fish_div = rural_identify * agriculture * fish_div
gen ag_rural_fish_pop = rural_identify * agriculture * fish_pop
gen ag_rural_algal    = rural_identify * agriculture * algal_blooms
gen ag_rural_nitro    = rural_identify * agriculture * nitro_target
gen ag_rural_dist     = rural_identify * agriculture * distance
gen ag_rural_cost     = rural_identify * agriculture * cost

rename city city_string
encode city_string, gen(city)

bys group_id: egen asc_chosen = max(asc*choice)
bys group_id: egen cost_chosen = max(cost*choice)
bys group_id: egen algal_chosen = max(algal_blooms*choice)
bys group_id: egen nitro_chosen = max(nitro_target*choice)
bys group_id: egen div_chosen = max(fish_div*choice)
bys group_id: egen pop_chosen = max(fish_pop*choice)
bys group_id: gen loc_chosen = location if choice == 1
bys group_id (loc_chosen): replace loc_chosen = loc_chosen[_N]

rename conf confidence

drop OID 

sort ind_id group_id alt
order ind_id group_id alt asc choice choice_certainty_1 choice_certainty_2 cost fish_div fish_pop algal_blooms nitro_target ///
      algal_25 algal_50 algal_75 nitro_50 nitro_75 nitro_100 ///
	  fish_div_2 fish_div_3 fish_div_5 fish_pop_50 fish_pop_75 fish_pop_150 ///
	  rural_algal_25 rural_algal_50 rural_algal_75 ///
	  rural_nitro_50 rural_nitro_75 rural_nitro_100 ///
	  rural_asc rural_fish_div rural_fish_pop rural_algal_blooms rural_nitro_target rural_distance rural_cost ///
	  experience_algal experience_fish experience_rec experience_waterquality ///
	  location distance loc_b loc_c loc_d ///
	  rural_identify agriculture income age male white homeowner ///
	  education edu_* residency zip city ///
	  confidence speeder consistent straightliner minutes new_cost

bys group_id: egen N_choice = sum(choice)
sum N_choice

destring qualtrics_complete, force replace
gen speeder_qualtrics = qualtrics_complete==4
table speeder speeder_qualtrics
replace qualtrics_complete = 0 if qualtrics_complete==4

lab var ind_id "Individual ID"
lab var group_id "Individual + Card ID"

lab var choice_certainty_1 "Choice recoded if - not very"
lab var choice_certainty_2 "Choice recoded if - not very, somewhat"

lab var asc "ASC"
lab var cost "Cost"
lab var fish_div "Fish Species"
lab var fish_pop "Fish Population"
lab var algal_blooms "Algal (reduction)"
lab var nitro_target "Nutrient Target"

lab var rural_fish_div "Rural x Species"
lab var rural_fish_pop "Rural x Population"
lab var rural_algal_blooms "Rural x Algal"
lab var rural_nitro_target "Rural x Nutrient"
lab var rural_distance  "Rural x Distance"
lab var rural_cost  "Rural x Cost"

lab var loc_b "Upper River"
lab var loc_c "Middle River"
lab var loc_d "Lower River"
lab var distance "Distance"

lab var algal_25 "25"
lab var algal_50 "50"
lab var algal_75 "75"

lab var rural_algal_25 "Rural x 25"
lab var rural_algal_50 "Rural x 50"
lab var rural_algal_75 "Rural x 75"

lab var nitro_50  "50"
lab var nitro_75  "75"
lab var nitro_100 "100"

lab var rural_nitro_50  "Rural x 50"
lab var rural_nitro_75  "Rural x 75"
lab var rural_nitro_100 "Rural x 100"

lab var fish_div_2  "Fish Species 2"
lab var fish_div_3  "Fish Species 3"
lab var fish_div_5  "Fish Species 5"

lab var fish_pop_50  "Fish Population 50"
lab var fish_pop_75  "Fish Population 75"
lab var fish_pop_150 "Fish Population 150"

lab var ag_fish_div "Agriculture x Species"
lab var ag_fish_pop "Agriculture x Population"
lab var ag_algal "Agriculture x Algal"
lab var ag_nitro "Agriculture x Nutrient"
lab var ag_dist  "Agriculture x Distance"
lab var ag_dist  "Agriculture x Cost"

lab var ag_rural_fish_div "Ag. x Rural x Species"
lab var ag_rural_fish_pop "Ag. x Rural x Population"
lab var ag_rural_algal "Ag. x Rural x Algal"
lab var ag_rural_nitro "Ag. x Rural x Nutrient"
lab var ag_rural_dist  "Ag. x Rural x Distance"
lab var ag_rural_dist  "Ag. x Rural x Cost"

lab var rural_identify "Rural"
lab var agriculture "Works in Agriculture"
lab var income "Income (k)"
lab var age "Age"
lab var white "White"
lab var male "Male"
lab var homeowner "Homeowner"
lab var experience_algal "Experience Algal Blooms"
lab var experience_fish "Experience Fisherman"
lab var experience_rec "Experience Recreationist"
lab var experience_waterquality "Experience Water Quality"
lab var education  "Education Level"
lab var residency  "Years of Residency"
lab var cost_chosen  "Price Chosen"
lab var minutes "Minutes to Complete"
lab var confidence  "Confident in Response"
lab var speeder  "Fast Responses"
lab var consistent  "Attention Check"
lab var straightliner  "Straightliner"
lab var protester  "Protester"
lab var new_cost  "Low-cost Sample"
lab var zip  "Zip Code"
lab var block  "Survey Block"

bys ind_id: gen count = _N

drop if protester == 1
drop if new_cost == 0
drop if speeder == 1
drop if count != 18

save store\analyze, replace

** END OF SCRIPT. Have a nice day! 
