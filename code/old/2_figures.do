** Written by: Bryan Parthum; bparthum@gmail.com ; June 2019

********************************************************************************
********************************    FIGURES    *********************************
********************************************************************************

clear all
set more off
set niceness 0

** SET WORKING DIRECTORY
cd "C:\Users\parthum2\Box\Sangamon\analysis\analyze"

** SET THEMES
*ssc install blindschemes, replace all
set scheme plotplain
grstyle init
grstyle linewidth major_grid vthin
grstyle linepattern major_grid shortdash

********************************************************************************
******************************   FIGURE 1 - WTP    *****************************
********************************************************************************
/*
est use estimates/rural_boot 
eststo rural_boot
est r rural_boot

est use estimates/urban_boot 
eststo urban_boot
est r urban_boot

est use estimates/pooled_boot 
eststo pooled_boot
est r pooled_boot
		 
coefplot (rural_boot, label(Rural) drop(asc fish_div) msymbol(S) msize(medium) ciopts(recast(rcap))) ///
		 (urban_boot, label(Urban) drop(asc fish_div) msymbol(T) msize(medium) ciopts(recast(rcap) lpattern(shortdash))) ///
		 (pooled_boot, label(Pooled) drop(asc fish_div) msymbol(O) msize(medium) ciopts(recast(rcap) lpattern(longdash))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("") ///
		 xlab(1 "Distance (mile)" 2 "Fish Population" 3 "Algal Blooms" 4 "Nutrient Target", labsize(small)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ylabel(-0.5(.1)0.55) ///
		 legend(pos(6) row(1) ring(1) bmargin(large) order(2 "Rural" 4 "Urban" 6 "Pooled")) /// 
		 name(wtp_sig, replace)
graph export plots/figure_1A.png, width(2500) replace 

coefplot (rural_boot, label(Rural) keep(asc) msymbol(S) msize(medium) ciopts(recast(rcap))) ///
		 (urban_boot, label(Urban) keep(asc) msymbol(T) msize(medium) ciopts(recast(rcap) lpattern(shortdash))) ///
		 (pooled_boot, label(Pooled) keep(asc) msymbol(O) msize(medium) ciopts(recast(rcap) lpattern(longdash))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("      ", angle(180)) ///
		 xlab(1 "Any Program (ASC)", labsize(medium)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ylabel(-10(5)40) ///
		 yline(-10 40, lwidth(vthin) lpat(shortdash)) ///
		 legend(pos(5) row(1) ring(0) bmargin(medium) order(2 "Rural" 4 "Urban" 6 "Pooled")) ///
		 name(asc, replace)
		 
coefplot (rural_boot, label(Rural) keep(fish_div) msymbol(S) msize(medium) ciopts(recast(rcap))) ///
		 (urban_boot, label(Urban) keep(fish_div) msymbol(T) msize(medium) ciopts(recast(rcap) lpattern(shortdash))) ///
		 (pooled_boot, label(Pooled) keep(fish_div) msymbol(O) msize(medium) ciopts(recast(rcap) lpattern(longdash))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("") ///
		 xlab(1 "Fish Species", labsize(medium)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ylabel(-2(1)8) ///
		 yline(8, lwidth(vthin) lpat(shortdash)) ///
		 name(fish, replace)	
		 
grc1leg2 asc fish, legendfrom(asc) name(figure_1B, replace) l1(" ")
*graph export plots/figure_1B.png, width(2500) replace 		

grc1leg2 wtp_sig figure_1B, ///
		 col(1) legendfrom(figure_1B) position(6) ring(1) l1(Dollars Per Year) b1title(Attribute) name(wtp, replace) imargin(-10)
graph display wtp, ysize(10) xsize(8)
graph export plots/figure_1.png, width(2500) replace 	

	 
** COLOR
set scheme plotplainblind
grstyle init
grstyle linewidth major_grid vthin
grstyle linepattern major_grid shortdash

coefplot (rural_boot, label(Rural) drop(asc fish_div) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, label(Urban) drop(asc fish_div) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, label(Pooled) drop(asc fish_div) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars Per Year") ///
		 xlab(1 "Distance (mile)" 2 "Fish Population" 3 "Algal Blooms" 4 "Nutrient Target", labsize(small)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ylabel(-0.5(.1)0.55) ///
		 legend(pos(6) row(1) ring(1) bmargin(large) order(2 "Rural" 4 "Urban" 6 "Pooled")) /// 
		 name(wtp_sig_color, replace)
graph export plots/figure_1A_color.png, width(2500) replace 

coefplot (rural_boot, label(Rural) keep(asc) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, label(Urban) keep(asc) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, label(Pooled) keep(asc) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars Per Year") ///
		 xlab(1 "Any Program (ASC)", labsize(medium)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ylabel(-10(5)40) ///
		 yline(-10 40, lwidth(vthin) lpat(shortdash)) ///
		 legend(pos(5) row(1) ring(0) bmargin(medium) order(2 "Rural" 4 "Urban" 6 "Pooled")) ///
		 name(asc_color, replace)
		 
coefplot (rural_boot, label(Rural) keep(fish_div) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, label(Urban) keep(fish_div) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, label(Pooled) keep(fish_div) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars Per Year") ///
		 xlab(1 "Fish Species", labsize(medium)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ylabel(-2(1)8) ///
		 yline(8, lwidth(vthin) lpat(shortdash)) ///
		 name(fish_color, replace)	
		 
grc1leg2 asc_color fish_color, legendfrom(asc_color) name(figure_1B_color, replace) l1(" ")
graph export plots/figure_1B_color.png, width(2500) replace 		

grc1leg2 wtp_sig_color figure_1B_color, ///
		 col(1) legendfrom(figure_1B_color) position(6) ring(1) l1(Dollars Per Year) b1title(Attribute) name(wtp, replace) imargin(-10)
graph display wtp, ysize(10) xsize(8)
graph export plots/figure_1_color.png, width(2500) replace 	
		 
		 
		 
		 
coefplot (rural_boot, label(Rural) drop(asc fish_div) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, label(Urban) drop(asc fish_div) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, label(Pooled) drop(asc fish_div) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars per Year") ///
		 xlab(1 "Distance (mile)" 2 "Fish Population" 3 "Algal Blooms" 4 "Nutrient Target") ///
		 yline(0, lwidth(vthin) lpat(solid) lcolor(red*0.3)) ylabel(-0.5(.1)0.55) ///
		 legend(pos(4) row(1) ring(0) bmargin(large) order(2 "Rural" 4 "Urban" 6 "Pooled"))
graph export plots/figure_2A_color.png, width(2500) replace 		 
		 
		 
coefplot (rural_boot, label(Rural) keep(asc) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, label(Urban) keep(asc) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, label(Pooled) keep(asc) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars per year") ///
		 xlab(1 "Any Program (move from status quo)") ///
		 yline(0, lwidth(vthin) lpat(solid) lcolor(red*0.3)) ylabel(-10(5)40) ///
		 yline(-10 40, lwidth(vthin) lpat(shortdash) lcolor(gray*0.6)) ///
		 legend(pos(5) row(1) ring(0) bmargin(medium) order(2 "Rural" 4 "Urban" 6 "Pooled")) ///
		 name(asc, replace)
		 
coefplot (rural_boot, label(Rural) keep(fish_div) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, label(Urban) keep(fish_div) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, label(Pooled) keep(fish_div) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("") ///
		 xlab(1 "Fish Species") ///
		 yline(0, lwidth(vthin) lpat(solid) lcolor(red*0.3)) ylabel(-2(1)8) ///
		 yline(8, lwidth(vthin) lpat(shortdash) lcolor(gray*0.6)) ///
		 name(fish, replace)	
		 
grc1leg2 asc fish, legendfrom(asc)
graph export plots/figure_2B_color.png, width(2500) replace 			 
*/	 
		 
/* 
** COMBINED ASC AND FISH SPECIES 		 
coefplot (rural_boot, offset(-0.2) drop(distance fish_div fish_pop algal_blooms nitro_target) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (urban_boot, offset(0) drop(distance fish_div fish_pop algal_blooms nitro_target) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (pooled_boot, offset(0.2) drop(distance fish_div fish_pop algal_blooms nitro_target) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))) ///
		 (rural_boot, offset(-0.3) drop(distance asc fish_pop algal_blooms nitro_target) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4)) axis(2)) ///
		 (urban_boot, offset(-0.1) drop(distance asc fish_pop algal_blooms nitro_target) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4)) axis(2)) ///
		 (pooled_boot, offset(0.1) drop(distance asc fish_pop algal_blooms nitro_target) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4)) axis(2)), ///
		 vertical ///
		 xtitle("") ///
		 xlab(1 "Any Program" 2 "Fish Species") ///
		 ytitle("Dollars per Year (Any Program)", axis(1)) ///
		 ytitle("Dollars per Year (Fish Species)", axis(2)) ///
		 ylabel(-10(5)40, axis(1)) ///
		 ylabel(-2(1)8, axis(2)) ///
		 yscale(range(0) axis(2)) ///
		 yline(0, lwidth(vthin) lpat(solid)) ///
		 legend(pos(7) row(1) ring(0) bmargin(medium) order(2 "Rural" 4 "Urban" 6 "Pooled"))
graph export plots/figure_1B.png, width(2500) replace 	 
		 
		 
*/	 
		 


/*
********************************************************************************
******************************   FIGURE 1 - WTP    *****************************
********************************************************************************

forv i = 1/3 {
est use estimates/tab_6_col_`i' 
eststo col_`i'
est r col_`i'
}
		 
coefplot (col_1, label(Urban) drop(asc fish_div) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (col_2, label(Rural) drop(asc fish_div) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (col_3, label(Pooled) drop(asc fish_div) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars per Year") ///
		 xlab(1 "Distance (per mile)" 2 "Fish Population" 3 "Algal Blooms" 4 "Nutrient Target") ///
		 yline(0,lwidth(vthin) lcolor(*.5)) ylabel(-1(.2)1) ///
		 legend(pos(4) row(3) ring(0) bmargin(large))
graph export plots/figure_1.png, width(2500) replace 

coefplot (col_1, label(Urban) drop(distance fish_pop algal_blooms nitro_target) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (col_2, label(Rural) drop(distance fish_pop algal_blooms nitro_target) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (col_3, label(Pooled) drop(distance fish_pop algal_blooms nitro_target) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Dollars per Year") ///
		 xlab(1 "Move From Status Quo" 2 "Fish Species") ///
		 yline(0,lwidth(vthin) lcolor(*.5)) ylabel(-10(5)60) ///
		 legend(pos(2) row(3) ring(0) bmargin(large))
graph export plots/figure_A1.png, width(2500) replace 


coefplot (col_1, offset(-0.2) drop(distance fish_div fish_pop algal_blooms nitro_target) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4))) ///
		 (col_2, offset(0) drop(distance fish_div fish_pop algal_blooms nitro_target) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4))) ///
		 (col_3, offset(0.2) drop(distance fish_div fish_pop algal_blooms nitro_target) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4))) ///
		 (col_1, offset(-0.3) drop(distance asc fish_pop algal_blooms nitro_target) msymbol(S) msize(medium)  mcolor(midgreen*.7) mfcolor(midgreen*.4) ciopts(recast(rcap) lcolor(midgreen*0.4)) axis(2)) ///
		 (col_2, offset(-0.1) drop(distance asc fish_pop algal_blooms nitro_target) msymbol(T) msize(medium)  mcolor(edkblue*.7) mfcolor(edkblue*.4) ciopts(recast(rcap) lpattern(shortdash) lcolor(edkblue*0.4)) axis(2)) ///
		 (col_3, offset(0.1) drop(distance asc fish_pop algal_blooms nitro_target) msymbol(O) msize(medium)  mcolor(purple*.7) mfcolor(purple*.4) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.4)) axis(2)), ///
		 vertical ///
		 xtitle("") ///
		 xlab(1 "Status Quo" 2 "Fish Species") ///
		 ytitle("Dollars per Year (Status Quo)", axis(1)) ///
		 ytitle("Dollars per Year (Fish Species)", axis(2)) ///
		 ylabel(-10(10)60, axis(1)) ///
		 ylabel(-2(2)16.8, axis(2)) ///
		 yscale(range(0) axis(2)) ///
		 yline(0,lwidth(vthin) lcolor(*.5)) ///
		 legend(pos(2) row(3) ring(0) bmargin(medium) order(2 "Urban" 4 "Rural" 6 "Pooled"))
graph export plots/figure_A1-2.png, width(2500) replace 
		 
		 
********************************************************************************
************************  FIGURE 2 Urban/Rural RATIO  **************************
********************************************************************************

**********************************
************************   Regress
**********************************	

** Load data
use ../data/pooled_money_time, clear

** Drop if wage is less than 8 or more than 500
drop if wage<8 | wage>500

** Generate negative term 
gen nmoney = -money	
*recode nmoney .=0
gen ntime = -time	
*recode ntime .=0
gen ncost = nmoney if time_survey==0
replace ncost = ntime if time_survey==1

** Generate alternative specific constant
gen asc = alt==3	

** Transform flood reduction from percent
replace fld_pctdec = fld_pctdec *100

** Generate interaction terms
gen asc_time = asc*time_survey
gen fld_pctdec_time = fld_pctdec*time_survey
gen hd_exc_time = hd_exc*time_survey
gen pld_swm_time = pld_swm*time_survey
gen ncost_time = ncost*time_survey

** Random variables for MMNL
global randvars "asc fld_pctdec hd_exc pld_swm asc_time fld_pctdec_time hd_exc_time pld_swm_time ncost_time ncost"

** Regress
mixlogit choice, rand($randvars) group(c_id) id(id) ln(1) nrep(500) corr
eststo tab_6
est save estimates/tab_6, replace

**********************************
******************  Transformation
**********************************
	
est use estimates/tab_6
eststo t
mixlcov, sd

sca sdm = (sqrt([l101]_b[_cons]*[l101]_b[_cons] + [l102]_b[_cons]*[l102]_b[_cons] + [l103]_b[_cons]*[l103]_b[_cons] + [l104]_b[_cons]*[l104]_b[_cons] + [l105]_b[_cons]*[l105]_b[_cons] + [l106]_b[_cons]*[l106]_b[_cons] + [l107]_b[_cons]*[l107]_b[_cons] + [l108]_b[_cons]*[l108]_b[_cons] + [l109]_b[_cons]*[l109]_b[_cons] + [l1010]_b[_cons]*[l1010]_b[_cons]))
sca sdt = (sqrt([l91]_b[_cons]*[l91]_b[_cons] + [l92]_b[_cons]*[l92]_b[_cons] + [l93]_b[_cons]*[l93]_b[_cons] + [l94]_b[_cons]*[l94]_b[_cons] + [l95]_b[_cons]*[l95]_b[_cons] + [l96]_b[_cons]*[l96]_b[_cons] + [l97]_b[_cons]*[l97]_b[_cons] + [l98]_b[_cons]*[l98]_b[_cons] + [l99]_b[_cons]*[l99]_b[_cons]))
 
nlcom (asc_mo:        ((_b[asc]       / exp(_b[ncost] + 0.5*sdm^2)))) ///
	  (fld_pctdec_mo: ((_b[fld_pctdec]/ exp(_b[ncost] + 0.5*sdm^2)))) ///
	  (hd_exc_mo:     ((_b[hd_exc]    / exp(_b[ncost] + 0.5*sdm^2)))) ///
	  (pld_swm_mo:    ((_b[pld_swm]   / exp(_b[ncost] + 0.5*sdm^2)))) ///
	  (asc_ti:        ((_b[asc]+_b[asc_time])               / ((exp(_b[ncost] + 0.5*sdm^2)+ exp(_b[ncost_time] + 0.5*sdt^2))))) ///
	  (fld_pctdec_ti: ((_b[fld_pctdec]+_b[fld_pctdec_time]) / ((exp(_b[ncost] + 0.5*sdm^2)+ exp(_b[ncost_time] + 0.5*sdt^2))))) ///
	  (hd_exc_ti:     ((_b[hd_exc]+_b[hd_exc_time])         / ((exp(_b[ncost] + 0.5*sdm^2)+ exp(_b[ncost_time] + 0.5*sdt^2))))) ///
	  (pld_swm_ti:    ((_b[pld_swm]+_b[pld_swm_time])       / ((exp(_b[ncost] + 0.5*sdm^2)+ exp(_b[ncost_time] + 0.5*sdt^2))))), post
eststo stage1
nlcom (asc:        (_b[asc_mo]/_b[asc_ti])*1.522) ///
	  (fld_pctdec: (_b[fld_pctdec_mo]/_b[fld_pctdec_ti])*1.157) ///
	  (hd_exc:     (_b[hd_exc_mo]/_b[hd_exc_ti])*1.6125) ///
	  (pld_swm:    (_b[pld_swm_mo]/_b[pld_swm_ti])*1.905), post
eststo tab_6_col_3
est save estimates/tab_6_col_3, replace

**********************************
********************  Plot Panel B
**********************************

est use estimates/tab_6_col_3
eststo tab_6_col_3
coefplot (tab_6_col_3, label(MWTP/MWTV) msymbol(O) msize(medium)  mcolor(purple*.6) mfcolor(purple*.3) mlabel mlabposition(12) mlabgap(*2) ciopts(recast(rcap) lpattern(longdash) lcolor(purple*0.3))), ///
		 vertical format(%9.3g) ///
		 xtitle("") ytitle("Ratio") ///
		 xlab(1 "Any Program" 2 "Flood Reduction (10%)" 3 "Habitat: Excellent" 4 "Water Quality: Swimmable") ///
		 yline(0,lwidth(vthin) lcolor(*.5)) ylabel(-2.5(2.5)23) ///
		 legend(pos(2) row(3) ring(0) bmargin(medium))
graph export plots/figure_2_panel_B.png, width(2500) replace 
*/

********************************************************************************
****************************  FIGURE 3 Frequency Plot **************************
********************************************************************************

**************************************
**************************  Histograms
**************************************
** Load data
use store\analyze, clear
drop if speeder == 1
*drop if consistent < 1
*drop if straightliner == 1
drop if protester == 1
drop if new_cost==0
duplicates drop group_id, force
*replace cost_chosen = -6 if cost_chosen==0
gen improved_chosen = 1-asc_chosen

label define asc_labs 0 "Status Quo" 1 "Improved Scenario"
label val improved_chosen asc_labs

**************************************
*******************  CHOSEN ATTRIBUTES
**************************************
sysdir set PLUS "C:\Users\bparthum\ado"
ssc install blindschemes, replace all
set scheme plotplain

splitvallabels asc_chosen
catplot urban_identify improved_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Status Quo, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(asc_chosen, replace)
graph export output/plots/asc_chosen.png, replace 

splitvallabels cost_chosen
catplot urban_identify cost_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Cost, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(cost_chosen, replace)
graph export output/plots/cost_chosen.png, replace 

splitvallabels div_chosen
catplot urban_identify div_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Fish Species, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(div_chosen, replace)
graph export output/plots/div_chosen.png, replace 

splitvallabels pop_chosen
catplot urban_identify pop_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Fish Population, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(pop_chosen, replace)
graph export output/plots/pop_chosen.png, replace 

splitvallabels algal_chosen
catplot urban_identify algal_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Algal Bloom Reduction, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(algal_chosen, replace)
graph export output/plots/algal_chosen.png, replace 

splitvallabels nitro_chosen
catplot urban_identify nitro_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Nutrient Target, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(nitro_chosen, replace)
graph export output/plots/nitro_chosen.png, replace 

splitvallabels loc_chosen
catplot urban_identify loc_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(River Section, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(vsmall)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(loc_chosen, replace)
graph export output/plots/loc_chosen.png, replace 

grc1leg2 cost_chosen asc_chosen div_chosen pop_chosen algal_chosen nitro_chosen, ///
		 col(2) legendfrom(asc_chosen) position(6) ring(10) l1(Number of Times Chosen) b1title(Attribute Level) name(chosen, replace)
graph display chosen, ysize(5.65) xsize(4.25)
graph export plots/Parthum_Figure_2.png, width(2550) replace 	


** COLOR 
set scheme plotplainblind

splitvallabels asc_chosen
catplot urban_identify improved_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Status Quo, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(asc_chosen_color, replace)
graph export output/plots/asc_chosen_color.png, replace 

splitvallabels cost_chosen
catplot urban_identify cost_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Cost, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(cost_chosen_color, replace)
graph export output/plots/cost_chosen_color.png, replace 

splitvallabels div_chosen
catplot urban_identify div_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Fish Species, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(div_chosen_color, replace)
graph export output/plots/div_chosen_color.png, replace 

splitvallabels pop_chosen
catplot urban_identify pop_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Fish Population, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(pop_chosen_color, replace)
graph export output/plots/pop_chosen_color.png, replace 

splitvallabels algal_chosen
catplot urban_identify algal_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Algal Bloom Reduction, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(algal_chosen_color, replace)
graph export output/plots/algal_chosen_color.png, replace 

splitvallabels nitro_chosen
catplot urban_identify nitro_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(Nutrient Target, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(nitro_chosen_color, replace)
graph export output/plots/nitro_chosen_color.png, replace 

splitvallabels loc_chosen
catplot urban_identify loc_chosen, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
	title(River Section, span size(large)) ///
	blabel(bar, position(outside) format(%3.0f) size(small)) ///
	ytitle("", size(medium)) ///
	ytick(#4) ylab(#4, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(loc_chosen_color, replace)
graph export output/plots/loc_chosen_color.png, replace 

grc1leg2 asc_chosen_color algal_chosen_color div_chosen_color cost_chosen_color nitro_chosen_color pop_chosen_color, ///
		 col(3) legendfrom(asc_chosen_color) position(6) ring(10) l1(Number of Times Chosen) b1title(Attribute Level) name(chosen_color, replace)
graph display chosen_color, ysize(5.5) xsize(8)
graph export plots/attribute_freq_wide.png, width(900) replace 	


**************************************
**************************  EXPERIENCE
**************************************

** Load data
use store\analyze, clear
drop if speeder == 1
*drop if consistent < 1
*drop if straightliner == 1
drop if protester == 1
drop if new_cost==0
duplicates drop ind_id, force

label define E_algal 0 "Never" 1 `" "Every couple" "of years" "' 2 `" "Once" "per year""' 3 `" "Several times" "per year" "' 4 `" "All the" "time" "' 
label val experience_algal E_algal

label define E_fish 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "5 <" 
label val experience_fish E_fish

label define E_rec 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "5 <" 
label val experience_rec E_rec

label define E_wq 0 "Not at all" 1 `" "Somewhat" "familiar" "' 2 "Familiar" 3 `" "Very" "familiar" "' 4 `" "Very and" "involved" "' 
label val experience_waterquality E_wq

set scheme plotplain

splitvallabels experience_rec
catplot urban_identify experience_rec, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Visits for hiking trails, span size(medium)) ///
	b1title("{bf:Panel A:} Responses about how often respondents visit the trails and river per year", size(small)) ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(medium)) ///
	ytick(#10) ylab(#10, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(medsmall) symxsize(medsmall) size(medsmall) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_rec, replace)
graph export output/plots/experience_rec.png, replace 

splitvallabels experience_fish
catplot urban_identify experience_fish, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Visits for fishing, span size(medium)) ///
	b1title("{bf:Panel B:} Responses about how often respondents fish in or near the river per year", size(small)) ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(medium)) ///
	ytick(#10) ylab(#10, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(medsmall) symxsize(medsmall) size(medsmall) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_fish, replace)
graph export output/plots/experience_fish.png, replace 

grc1leg2 experience_rec experience_fish, ///
		 col(1) legendfrom(experience_rec) position(6) ring(1) l1(Number of Times Chosen) name(experience_rec_fish, replace)
graph display experience_rec_fish, ysize(5.65) xsize(4.25)
graph export plots/figure_6.png, width(2550) replace 


splitvallabels experience_algal
catplot urban_identify experience_algal, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Frequency seeing algal blooms, span size(medium)) ///
	b1title("{bf:Panel A:} Reported times seeing algal blooms in the study area per year", size(small)) ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(medium)) ///
	ytick(#10) ylab(#10, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_algal, replace)
graph export output/plots/experience_algal.png, replace 

splitvallabels experience_waterquality
catplot urban_identify experience_waterquality, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Familiarity with water quality issues, span size(medium)) ///
	b1title("{bf:Panel B}: Reported familiarity with the water quality issues discussed", size(small)) ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(medium)) ///
	ytick(#10) ylab(#10, labsize(small)) ///
	asyvars ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_wq, replace)
graph export output/plots/experience_wq.png, replace 

grc1leg2 experience_algal experience_wq, ///
		 col(1) legendfrom(experience_algal) position(6) ring(1) l1(Number of Times Chosen) name(experience_algal_wq, replace)
graph display experience_algal_wq, ysize(5.65) xsize(4.25)
graph export plots/Parthum_Figure_3.png, width(2550) replace 


** COLOR
set scheme plotplainblind

splitvallabels experience_rec
catplot urban_identify experience_rec, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Visits for hiking trails, span size(medium)) ///
	b1title("{bf:Panel A:} Responses about how often respondents visit the trails and river per year", size(small)) ///
	/*title("Number of times respondents reported visiting the trails and river per year", size(medium)) */ ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(medium)) ///
	ytick(#10) ylab(#10, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(medium) symxsize(medium) size(medium) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_rec_color, replace)
graph export output/plots/experience_rec_color.png, replace 

splitvallabels experience_fish
catplot urban_identify experience_fish, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Visits for fishing, span size(medium)) ///
	b1title("{bf:Panel B:} Responses about how often respondents fish in or near the river per year", size(small)) ///
	/*title("Number of times respondents reported fishing in or near the river per year", size(medium)) */ ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(medium)) ///
	ytick(#10) ylab(#10, labsize(small)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(medium) symxsize(medium) size(medium) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_fish_color, replace)
graph export output/plots/experience_fish_color.png, replace 

grc1leg2 experience_rec_color experience_fish_color, ///
		 col(1) legendfrom(experience_rec_color) position(6) ring(1) l1(Number of Times Chosen) name(experience_rec_fish_color, replace)
graph display experience_rec_fish_color, ysize(10) xsize(8)
graph export plots/recreation.png, width(2500) replace 


splitvallabels experience_algal
catplot urban_identify experience_algal, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Frequency seeing algal blooms, span size(medium)) ///
	b1title("{bf:Panel A:} Responses about how often respondents see algal blooms in the study area per year", size(small)) ///
	/* title("Number of times respondents reported seeing algal blooms in the study area per year", size(medium)) */ /// 
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(small)) ///
	ytick(#10) ylab(#10, labsize(vsmall)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_algal_color, replace)
graph export output/plots/experience_algal_color.png, replace 

splitvallabels experience_waterquality
catplot urban_identify experience_waterquality, ///
	recast(bar) ///
	var1opts(label(labsize(small))) ///
	var2opts(label(labsize(small))) ///
	title(Familiarity with water quality issues, span size(medium)) ///
	b1title("{bf:Panel B}: Responses about how familiar respondents are with water quality issues discussed", size(small)) ///
	/*title("Responses about how familiar respondents are with water quality issues discussed", size(medium)) */ ///
	blabel(bar, position(outside) format(%3.0f)) ///
	ytitle("", size(small)) ///
	ytick(#10) ylab(#10, labsize(vsmall)) ///
	asyvars ///
	bar(1, color(purple%65)) ///
	bar(2, color(midgreen%25) lcolor(dkgreen%100)) ///
	legend(pos(6) cols(2) symysize(small) symxsize(small) size(small) ///
	order(1 "  Rural Respondents" 2 "  Urban Respondents") ///
	symplacement(center)) ///
	name(experience_wq_color, replace)
graph export output/plots/experience_wq_color.png, replace 

grc1leg2 experience_algal_color experience_wq_color, ///
		 col(1) legendfrom(experience_algal_color) position(6) ring(1) l1(Number of Times Chosen) name(experience_algal_wq_color, replace)
graph display experience_algal_wq_color, ysize(10) xsize(8)
graph export plots/WQ_awareness.png, width(2500) replace 

** END OF SCRIPT. Have a nice day! 
