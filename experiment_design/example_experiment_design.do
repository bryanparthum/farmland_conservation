** Written by: Bryan Parthum; bparthum@gmail.com ; December 2020

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
				4, /// *attribute_1: 		1) 0    2) 40  		3) 80  	4) 120  
				4, /// *attribute_2: 		1) 0    2) 40  		3) 80  	4) 120 
				4, /// *attribute_3:		1) 0    2) 2   		3) 6   	4) 12
				4, /// *attribute_4: 		1) 0    2) 2   	  	3) 6   	4) 12
				4, /// *attribute_5: 		1) none 2) picnic 	3) walk 4) both
				3 	  /*Distance (miles) 	1) 10   2) 20  		3) 40 			*/
genfact, levels(levels)
// list, separator(3)

*****************************************
*********************************  RENAME
*****************************************

rename (x1 x2 x3 x4 x5 x6 x7) ///
	   (cost ///
        attribute_1 ///
		attribute_2 ///
		attribute_3 ///
		attribute_4 ///
		attribute_5 ///
		distance)

*****************************************
*********************************  RECODE
*****************************************

recode cost     	  	(1=5)  (2=20)  (3=50)   (4=100)	(5=500)
recode attribute_1   	(1=0)  (2=40)  (3=80)   (4=120)
recode attribute_2 	  	(1=0)  (2=40)  (3=80)   (4=120)
recode attribute_3   	(1=0)  (2=2)   (3=6)    (4=12)
recode attribute_4 	  	(1=0)  (2=2)   (3=6)    (4=12)
recode attribute_5	  	(1=0)  (2=1)   (3=2)    (4=3)		(5=4)
recode distance 	  	(1=10) (2=20)  (3=40)

*****************************************
**********************  IMPOSE CONDITIONS
*****************************************

drop if (attribute_1==0 & attribute_3>0) | (attribute_2==0 & attribute_4>0)
drop if (attribute_1==0 & attribute_2==0)

*****************************************
**************************  IMPOSE PRIORS
*****************************************

matrix status_quo = 0,0,0,0,0,0,0
matrix betas = J(1,29,0)

*****************************************
********************  GENERATE EXPERIMENT
*****************************************

dcreate i.cost ///
		i.attribute_1 ///
		i.attribute_2 ///
		i.attribute_3 ///
		i.attribute_4 ///
		i.attribute_5 ///
		i.distance ///
		c.attribute_5#c.distance ///
		c.attribute_5#c.attribute_1 ///
		c.attribute_5#c.attribute_2 ///
		c.distance#c.attribute_1 ///
		c.distance#c.attribute_2 ///
		c.distance#c.attribute_3 ///
		c.distance#c.attribute_4, ///
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

** END OF SCRIPT. Have a great day!
