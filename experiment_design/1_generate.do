** Written by: Bryan Parthum; bparthum@gmail.com ; February 2022

********************************************************************************
********************   D-EFFICIENT EXPERIMENT DESIGN   *************************
********************************************************************************

clear all
set more off
set seed 42

// // ** INSTALL PACKAGE TO CREATE D-EFFICIENT DESIGN
// ssc install dcreate
 
*****************************************
********  CONSTRUCT FULL FACTORIAL MATRIX 
*****************************************

matrix levels = 5, /// *cost: 				1) 5    2) 20  		3) 50  	4) 100 5) 500
				4, /// *nature: 			1) 0    2) 40  		3) 80  	4) 120  
				4, /// *farmland: 			1) 0    2) 40  		3) 80  	4) 120 
				4, /// *meals nature:		1) 0    2) 2   		3) 6   	4) 12
				4, /// *meals farmland: 	1) 0    2) 2   	  	3) 6   	4) 12
				4, /// *access: 			1) none 2) picnic 	3) walk 4) both
				3 	  /*Distance (miles) 	1) 10   2) 20  		3) 40 			*/
genfact, levels(levels)
// list, separator(3)

*****************************************
*********************************  RENAME
*****************************************

rename (x1 x2 x3 x4 x5 x6 x7) ///
	   (cost ///
        nature ///
		farmland ///
		meals_nature ///
		meals_farmland ///
		access ///
		distance)

*****************************************
*********************************  RECODE
*****************************************

recode cost     	  (1=5)  (2=20)  (3=50)   (4=100)	(5=500)
recode nature   	  (1=0)  (2=40)  (3=80)   (4=120)
recode farmland 	  (1=0)  (2=40)  (3=80)   (4=120)
recode meals_nature   (1=0)  (2=2)   (3=6)    (4=12)
recode meals_farmland (1=0)  (2=2)   (3=6)    (4=12)
recode access 		  (1=0)  (2=1)   (3=2)    (4=3)		(5=4)
recode distance 	  (1=10) (2=20)  (3=40)

// replace meals_nature   = nature * meals_nature
// replace meals_farmland = farmland * meals_farmland

*****************************************
**********************  IMPOSE CONDITIONS
*****************************************

drop if (nature==0 & meals_nature>0) | (farmland==0 & meals_farmland>0)
drop if (nature==0 & farmland==0)

*****************************************
**************************  IMPOSE PRIORS
*****************************************

matrix status_quo = 0,0,0,0,0,0,0
matrix betas = J(1,29,0)

*****************************************
********************  GENERATE EXPERIMENT
*****************************************

dcreate i.cost ///
		i.nature ///
		i.farmland ///
		i.meals_nature ///
		i.meals_farmland ///
		i.access ///
		i.distance ///
		c.access#c.distance ///
		c.access#c.nature ///
		c.access#c.farmland ///
		c.distance#c.nature ///
		c.distance#c.farmland ///
		c.distance#c.meals_nature ///
		c.distance#c.meals_farmland, ///
		nalt(1) ///
		nset(30) ///
		bmat(betas) ///
		seed(36545458) ///
		fixedalt(status_quo) ///
		asc(2)
		
*****************************************
************************  GENERATE BLOCKS
*****************************************

blockdes block, nblock(5) neval(40) seed(42)

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

tostring access, replace
replace access = "No Recreation" if access=="0"
replace access = "Picnic Tables" if access=="1"
replace access = "Maintained Trails" if access=="2"
replace access = "Trails and Tables" if access=="3"

gen treatment = "miles"

order block card alt ///
      title ///
	  cost ///
	  nature ///
	  farmland ///
	  meals_nature ///
	  meals_farmland ///
	  access ///
	  distance ///
	  treatment ///
	  alt_id card_id card_dcreate

save store/design_matrix_miles, replace

recode distance (10=15) (20=30)  (40=60)
replace treatment = "minutes"
save store/design_matrix_minutes, replace


** END OF SCRIPT. Have a great day!
