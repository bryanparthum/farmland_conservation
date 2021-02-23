** Written by: Bryan Parthum; bparthum@gmail.com ; December 2020

********************************************************************************
********************   D-EFFICIENT EXPERIMENT DESIGN   *************************
********************************************************************************

clear all
set more off

// ** INSTALL PACKAGE TO CREATE D-EFFICIENT DESIGN
// sysdir set PLUS "C:\Users\bparthum\OneDrive - Environmental Protection Agency (EPA)\software\stata\ado\plus"
// sysdir set PERSONAL "C:\Users\bparthum\OneDrive - Environmental Protection Agency (EPA)\software\stata\ado\personal"
// sysdir set OLDPLACE "C:\Users\bparthum\OneDrive - Environmental Protection Agency (EPA)\software\stata\ado"
// ssc install dcreate

// use N_dominated, clear
// while N_dominated > 0 { 
// qui{
//
// clear all
// set more off

// local rand = runiformint(0,20000) 
// set seed `rand' 
// display c(seed) 
set seed 42

*****************************************
********  CONSTRUCT FULL FACTORIAL MATRIX 
*****************************************

matrix levels = 4, /// *cost: 				1) 5   2) 20  3) 50 4) 100
				4, /// *nature: 			1) 120 2) 80  3) 40  4) 0  
				4, /// *farmland: 			1) 120 2) 80  3) 40  4) 0 
				3, /// *meals nature:		1) 0   2)500  3) 1000
				3, /// *meals farmland: 	1) 0   2)500  3) 1000
				3 	  /*Distance (miles) 	1) 5   2) 15  3) 40 	*/
genfact, levels(levels)
// list, separator(3)

*****************************************
*********************************  RENAME
*****************************************

rename (x1 x2 x3 x4 x5 x6) ///
	   (cost ///
        nature ///
		farmland ///
		meals_nature ///
		meals_farmland ///
		distance)

*****************************************
*********************************  RECODE
*****************************************

recode cost     	  (1=5) (2=20)  (3=50)   (4=100)
recode nature   	  (1=0) (2=40)  (3=80)   (4=120)
recode farmland 	  (1=0) (2=40)  (3=80)   (4=120)
recode meals_nature   (1=0) (2=500) (3=1000)
recode meals_farmland (1=0) (2=500) (3=1000)
recode distance 	  (1=5) (2=15)  (3=40)

// replace meals_nature   = nature * meals_nature
// replace meals_farmland = farmland * meals_farmland

*****************************************
**********************  IMPOSE CONDITIONS
*****************************************

drop if nature + farmland > 120

*****************************************
**************************  IMPOSE PRIORS
*****************************************

matrix status_quo = 0,0,0,0,0,0
matrix betas = J(1,26,0)

*****************************************
********************  GENERATE EXPERIMENT
*****************************************

dcreate i.cost ///
		i.nature ///
		i.meals_nature ///
		i.distance##i.farmland ///
		i.distance##i.meals_farmland, ///
		nalt(1) ///
		nset(48) ///
		bmat(betas) ///
		seed(125612434) ///
		fixedalt(status_quo) ///
		asc(2)

*****************************************
************************  GENERATE BLOCKS
*****************************************

blockdes block, nblock(6) neval(40) seed(42)

*****************************************
*****************  SORT, ORDER, AND CLEAN
*****************************************

rename 	choice_set card_dcreate
sort 	block card_dcreate alt
gen 	alt_id = _n
egen 	card_id = group(block card_dcreate)
sort 	block alt alt_id
by 		block alt: gen card = _n
sort 	block card alt

gen 	title = "No Project"  if alt == 2
replace title = "Project" if alt == 1 

gen treatment = "miles"

order block card alt ///
      title ///
	  cost ///
	  nature ///
	  farmland ///
	  meals_nature ///
	  meals_farmland ///
	  distance ///
	  treatment ///
	  alt_id card_id card_dcreate

save store/design_matrix_miles, replace

recode distance (5=15) (15=30)  (40=60)
replace treatment = "time"
save store/design_matrix_minutes, replace


** END OF SCRIPT. Have a great day!
