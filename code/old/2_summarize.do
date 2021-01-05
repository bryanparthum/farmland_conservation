** Written by: Bryan Parthum; bparthum@gmail.com ; March 2018

********************************************************************************
********************  SUMMARY STATS PILOT - QUALTRICS   ************************
********************************************************************************

clear all
set more off
set matsize 1000

** SET WORKING DIRECTORY
cd "C:\Users\bparthum\Box\Sangamon\analysis\analyze"

// ** SET THEMES
// ssc install blindschemes, replace all
// set scheme plotplainblind

**************************************
*********** LOAD DATA FROM GENERATE.DO
**************************************

** Load data
use store\analyze, clear
*drop if speeder == 1
*drop if consistent < 1
*drop if straightliner == 1
*drop if protester == 1
*drop if new_cost==0
duplicates drop ind_id, force

save store\summarydata, replace

**************************************
******************  Summary Statistics
**************************************

order rural_identify agriculture male white homeowner ///
			 age_* inc_* edu_* res_* ///
			 experience_fish experience_rec /// 
			 experience_waterquality experience_algal minutes
			 
outreg2 using output/tables/summarystats, word ///
		replace label sum(log) eqkeep(N mean min max) dec(2) ///
		keep(rural_identify agriculture male white homeowner ///
			 age_* inc_* edu_* res_* ///
			 experience_fish experience_rec /// 
			 experience_waterquality experience_algal minutes) ///
		title("Table 1: Summary Statistics")
		
/*
** Export summary statistics
sutex experience_algal experience_fish experience_rec experience_waterquality ///
	  rural_identify agriculture income age race male white homeowner speeder ///
	  consistent minutes, replace ///
		key(RCT Low) ///
		file(output/tables/summarystats.rtf) ///
		title(Summary Statistics) ///
		minmax nobs par labels digits(2) long

sum2docx rural_identify agriculture income age white male white homeowner speeder ///
		 experience_algal experience_fish experience_rec experience_waterquality ///
	     consistent minutes ///
	     using output/tables/summarystats.docx, replace ///
		 obs mean(%9.2f) sd min(%9.0g) median(%9.0g) max(%9.0g) ///
		 title(Summary Statistics)
*/

**************************************
****************************  Comments
**************************************

tempfile sumdata
save `sumdata'

drop if comments==""
tab comments
replace comments=trim(itrim(comments))
drop if comments=="I have no comments."
drop if comments=="I wish you all the best!"
drop if comments=="N/a"
drop if comments=="NONE"
drop if comments=="Nice survey"
drop if comments=="None"
drop if comments=="Nothing"
drop if comments=="Nothing to say"
drop if comments=="Thank you."
drop if comments=="Thanks"
drop if comments=="Thanks."
drop if comments=="What you do?"
drop if comments=="n/a"
drop if comments=="no"
drop if comments=="none"
drop if comments=="none really."
drop if comments=="thank you"
drop if comments=="thank you so much"
drop if comments=="thanks"
drop if comments=="Thank you"
drop if strpos(comments,"No comment")>0
drop if strpos(comments,"Been fishing")>0
drop if strpos(comments,"none really")>0
tab comments
replace comments = "\item " + comments
keep comments
outfile using store\comments.txt, replace noq


**************************************
*********************  Rural vs. Urban
**************************************

balancetable urban_identify agriculture male white homeowner ///
			 age__* inc_* edu_* res_* ///
			 experience_fish experience_rec /// 
			 experience_waterquality experience_algal minutes ///
			 using output/tables/balance_rural_urban.xlsx, ///
			 varla replace wide format(%9.2f) ///
			 ctitles("Rural" "Urban" "Difference")  

**************************************
******************************  Census
**************************************
** Load data
use store\census_balance, clear

gen zip = GEOID10
reshape long white_ ag_ male_ homeowner_ edu_1_ edu_2_ edu_3_ edu_4_ edu_5_ edu_6_ age1_ age2_ age3_ age4_ inc_1_ inc_2_ inc_3_ inc_4_ inc_5_ inc_6_ inc_7_ inc_8_, i(zip) j(sample "sample" "region")
rename (white_ ag_ male_ homeowner_ edu_1_ edu_2_ edu_3_ edu_4_ edu_5_ edu_6_ age1_ age2_ age3_ age4_ inc_1_ inc_2_ inc_3_ inc_4_ inc_5_ inc_6_ inc_7_ inc_8_) ///
	   (white ag male homeowner edu_1 edu_2 edu_3 edu_4 edu_5 edu_6 age_1 age_2 age_3 age_4 inc_1 inc_2 inc_3 inc_4 inc_5 inc_6 inc_7 inc_8)
gen census = sample=="region"

balancetable census ag male white homeowner ///
			 age_1 age_2 age_3 age_4 ///
			 inc_1 inc_2 inc_3 inc_4 inc_5 inc_6 inc_7 inc_8 ///
		     edu_1 edu_2 edu_3 edu_4 edu_5 edu_6 ///
			 using output/tables/balance_census.xlsx, ///
			 varla replace wide format(%9.2f) ///
			 ctitles("Sample" "" "Census" "" "Difference")  

** END OF SCRIPT. Have a nice day! 
