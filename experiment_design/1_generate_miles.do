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

matrix levels = 4, /// *Cost: 			1) 2   2) 20  3) 50 4) 100
				4, /// *Land: 			1) 160 2) 120 3) 80 4) 40 
				2, /// *Local Food:		1) None 2) Yes
				3 	  /*Distance (mi) 	1) 5 	2) 15 	3) 40 	*/
genfact, levels(levels)
// list, separator(3)

*****************************************
*********************************  RENAME
*****************************************

rename (x1 x2 x3 x4) ///
	   (cost ///
        land ///
		food ///
		dist)

*****************************************
*********************************  RECODE
*****************************************

recode cost  (1=5) (2=20) (3=50) (4=100)
recode land  (1=160) (2=120) (3=80) (4=40)
recode food  (1=0)  (2=1)
recode dist  (1=5)  (2=15) (3=40)

*****************************************
**************************  IMPOSE PRIORS
*****************************************

matrix status_quo = 0,0,0,0
matrix betas = J(1,18,0)

*****************************************
********************  GENERATE EXPERIMENT
*****************************************

dcreate i.cost ///
		i.dist##i.land ///
		i.dist##i.food, ///
		nalt(1) ///
		nset(24) ///
		bmat(betas) ///
		seed(125612434) ///
		fixedalt(status_quo) ///
		asc(2)

*****************************************
************************  GENERATE BLOCKS
*****************************************

blockdes block, nblock(3) neval(40) seed(42)

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

rename land nature
gen farmland = 160-nature
replace farmland = 0 if alt == 2

gen fruit = food * 1000 * nature/40
gen veggies = food * (4000-fruit)

gen meals = "0"
replace meals = "4,000" if food==1

gen treatment = "miles"

order block card alt ///
      title ///
	  cost ///
	  nature ///
	  farmland ///
	  meals ///
	  fruit ///
	  veggies ///
	  dist ///
	  treatment ///
	  food ///
	  alt_id card_id card_dcreate

save store/design_matrix_miles, replace

** END OF SCRIPT. Have a great day!
