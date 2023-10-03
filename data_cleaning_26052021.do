clear

cd "C:\Users\jllov\Dropbox\timeuse 2019"

****Import txt. file using dct. file****
clear
infix using "level1.dct", using ("TUS106_L01.txt")
gen hhid= fsu + hh_no
gen weight = mlt /100 
tabstat weight, statistics( sum ) format(%14.0f)
sort fsu  hh_no  sl_no
gen state=substr(nss_region,1,2)
label define state 1 "Jammu & Kashmir" 2 "Himachal Pradesh" 3 "Punjab" 4 "Chandigarh" 5 "Uttarakhand" 6 "Haryana" 7 "Delhi" 8  "Rajasthan" 9 "Uttar Pradesh" 10 "Bihar" 11 "Sikkim" 12 "Arunachal Pradesh" 13 "Nagaland" 14 "Manipur" 15 "Mizoram" 16 "Tripura" 17 "Meghalaya" 18 "Assam" 19 "West Bengal" 20 "Jharkhand" 21 "Odisha" 22 "Chhattisgarh" 23 "Madhya Pradesh" 24 "Gujarat" 25 "Daman & Diu" 26 "D & N Haveli" 27 "Maharashtra" 28 "Andhra Pradesh" 29 "Karnataka" 30 "Goa" 31 "Lakshadweep" 32 "Kerala" 33 "Tamil Nadu" 34 "Puducherry" 35 "A & N Islands" 36 "Telangana"
destring state, replace
label value state state
save "level1.dta", replace

clear
infix using "level2.dct", using ("TUS106_L02.txt")
gen hhid= fsu + hh_no
gen psid = fsu + hh_no + sl_no
sort fsu  hh_no  sl_no
save "level2.dta", replace

clear
infix using "level3.dct", using ("TUS106_L03.txt")
gen hhid= fsu + hh_no
sort fsu  hh_no 
save "level3.dta", replace

clear
infix using "level4.dct", using ("TUS106_L04.txt")
gen hhid= fsu + hh_no
gen psid = fsu + hh_no + sl_no
sort fsu  hh_no  sl_no
save "level4.dta", replace

clear
infix using "level5.dct", using ("TUS106_L05.txt")
gen hhid= fsu + hh_no
gen psid = fsu + hh_no + sl_no
sort fsu  hh_no  sl_no
save "level5.dta", replace

*combine level1 to level 5
clear
use "level1.dta", clear
merge 1:1 hhid using "level3.dta"
drop _merge
save "household.dta", replace

clear
use "level2.dta", clear
merge m:1 hhid using "household.dta"
drop _merge
merge 1:1 psid using "level4.dta"
drop _merge
save "individual.dta", replace

clear
use "level5.dta", clear
merge m:1 psid using "individual.dta"
drop _merge


****Generate relative weight****

sort hhid psid time_from
egen meanWT=mean(weight)
gen fweight=weight/meanWT
gen fwt=round(fweight, 1)
recode fwt 0=1

****Calculate daily hours****

gen time_from2 = substr(time_from,1,2) + "." + substr(time_from,4,2)
replace time_from2=substr(time_from,1,2)+ "." + "50" if substr(time_from,4,2)== "30"

gen time_to2 = substr(time_to,1,2) + "." + substr(time_to,4,2)
replace time_to2=substr(time_to,1,2)+ "." + "50" if substr(time_to,4,2)== "30"

destring time_to2 time_from2, replace
gen time=time_to2 - time_from2
replace time=time+24 if time<0 & time!=.
drop if time==.
gen time_7days=time*7

tostring activity_code, replace
gen activity_1digit=substr(activity_code,1,1)
label define activity_1digit 1 "employment" 2 "production_goods" 3 "unpaid hh domestic services" 4 "unpaid hh caregiving services" 5 "other unpaid work" 6 "learning" 7 "socializing" 8 "leisure" 9 "selfcare"
destring activity_1digit, replace
label value activity_1digit activity_1digit
gen activity_2digits=substr(activity_code,1,2)

****Constructing Variables****

gen female=1 if gender==2
replace female=0 if female==.

save "timeuse.dta", replace
use "timeuse.dta", replace


****Conservative Measurement****
sort psid
by psid, sort: egen time1=sum(time) if (activity_1digit==1 & majoracitivity==1)
by psid, sort: egen time2=sum(time) if (activity_1digit==2 & majoracitivity==1)
by psid, sort: egen time3=sum(time) if (activity_1digit==3 & majoracitivity==1)
by psid, sort: egen time4=sum(time) if (activity_1digit==4 & majoracitivity==1)
by psid, sort: egen time5=sum(time) if (activity_1digit==5 & majoracitivity==1)
by psid, sort: egen time6=sum(time) if (activity_1digit==6 & majoracitivity==1)
by psid, sort: egen time7=sum(time) if (activity_1digit==7 & majoracitivity==1)
by psid, sort: egen time8=sum(time) if (activity_1digit==8 & majoracitivity==1)
by psid, sort: egen time9=sum(time) if (activity_1digit==9 & majoracitivity==1)
by psid, sort: egen time_employment = max(time1) 
by psid, sort: egen time_goods = max(time2) 
by psid, sort: egen time_domestic = max(time3) 
by psid, sort: egen time_caregiving = max(time4) 
by psid, sort: egen time_otherunpaid = max(time5) 
by psid, sort: egen time_learning = max(time6) 
by psid, sort: egen time_social = max(time7) 
by psid, sort: egen time_leisure = max(time8) 
by psid, sort: egen time_selfcare = max(time9) 

replace time_employment=0 if time_employment==.
replace time_goods=0 if time_goods==.
replace time_domestic=0 if time_domestic==.
replace time_caregiving=0 if time_caregiving==.
replace time_otherunpaid=0 if time_otherunpaid==.
replace time_learning=0 if time_learning==.
replace time_social=0 if time_social==.
replace time_leisure=0 if time_leisure==.
replace time_selfcare=0 if time_selfcare==.

by psid, sort: egen time_economic0=sum(time) if (activity_1digit==1|activity_1digit==2) & majoracitivity==1
by psid, sort: egen time_economic = max(time_economic0)
by psid, sort: egen time_unpaidservice0=sum(time) if (activity_1digit==3|activity_1digit==4|activity_1digit==5)  & majoracitivity==1
by psid, sort: egen time_unpaidservice = max(time_unpaidservice0) 
by psid, sort: egen time_anywork0=sum(time) if (activity_1digit==1|activity_1digit==2|activity_1digit==3|activity_1digit==4|activity_1digit==5)  & majoracitivity==1
by psid, sort: egen time_anywork= max(time_anywork0) 
by psid, sort: egen time_total0=sum(time)  if majoracitivity==1
by psid, sort: egen time_total= max(time_total0) 


replace time_economic=0 if time_economic==.
replace time_unpaidservice=0 if time_unpaidservice==.
replace time_anywork=0 if time_anywork==.
replace time_total=0 if time_total==.

*time by conservative measurment (all activities)
drop time_economic0 time_unpaidservice0 time_anywork0 time_total0
save "timeuse_conservative_all.dta", replace

*time by conservative measurment (each individual)
keep if activity_id==1 
save "timeuse_conservative.dta", replace
use "timeuse_conservative.dta", replace
sum time time_employment time_goods time_domestic time_caregiving time_otherunpaid time_learning time_social time_leisure time_selfcare time_economic time_unpaidservice time_anywork time_total

****Exhaustive Measurement****
use "timeuse.dta", replace

sort psid

gen simultaneous0=1 if simultaneousactivity==1
by psid time_from, sort: egen simultaneous = total(simultaneous0) 

gen multiple0=1 if multilpleactivity==1
by psid time_from, sort: egen multiple = total(multiple0) 

gen notsimultaneous0=1 if multiple ==1 & simultaneous!=1
by  psid time_from, sort: egen notsimultaneous = total(notsimultaneous0) 
replace  notsimultaneous=1 if notsimultaneous==0
gen time_new=time/notsimultaneous

by psid, sort: egen total = sum(time_new) 
by psid, sort: gen adjust=24/total
by psid, sort: gen time_new_adj = time_new*adjust 

sort psid
	by psid, sort: egen time1=sum(time_new_adj) if (activity_1digit==1) 
	by psid, sort: egen time2=sum(time_new_adj) if (activity_1digit==2)
	by psid, sort: egen time3=sum(time_new_adj) if (activity_1digit==3)
	by psid, sort: egen time4=sum(time_new_adj) if (activity_1digit==4)
	by psid, sort: egen time5=sum(time_new_adj) if (activity_1digit==5)
	by psid, sort: egen time6=sum(time_new_adj) if (activity_1digit==6)
	by psid, sort: egen time7=sum(time_new_adj) if (activity_1digit==7)
	by psid, sort: egen time8=sum(time_new_adj) if (activity_1digit==8)
	by psid, sort: egen time9=sum(time_new_adj) if (activity_1digit==9)
	by psid, sort: egen time_employment = max(time1) 
	by psid, sort: egen time_goods = max(time2) 
	by psid, sort: egen time_domestic = max(time3) 
	by psid, sort: egen time_caregiving = max(time4) 
	by psid, sort: egen time_otherunpaid = max(time5) 
	by psid, sort: egen time_learning = max(time6) 
	by psid, sort: egen time_social = max(time7) 
	by psid, sort: egen time_leisure = max(time8) 
	by psid, sort: egen time_selfcare = max(time9) 

	replace time_employment=0 if time_employment==.
	replace time_goods=0 if time_goods==.
	replace time_domestic=0 if time_domestic==.
	replace time_caregiving=0 if time_caregiving==.
	replace time_otherunpaid=0 if time_otherunpaid==.
	replace time_learning=0 if time_learning==.
	replace time_social=0 if time_social==.
	replace time_leisure=0 if time_leisure==.
	replace time_selfcare=0 if time_selfcare==.

by psid, sort: egen time_economic0=sum(time_new_adj) if (activity_1digit==1|activity_1digit==2)
by psid, sort: egen time_economic = max(time_economic0)
by psid, sort: egen time_unpaidservice0=sum(time_new_adj) if (activity_1digit==3|activity_1digit==4|activity_1digit==5)
by psid, sort: egen time_unpaidservice = max(time_unpaidservice0) 
by psid, sort: egen time_anywork0=sum(time_new_adj) if (activity_1digit==1|activity_1digit==2|activity_1digit==3|activity_1digit==4|activity_1digit==5) & simultaneous!=1
by psid, sort: egen time_anywork= max(time_anywork0) 
by psid, sort: egen time_total0=sum(time_new_adj) 
by psid, sort: egen time_total= max(time_total0) 

replace time_economic=0 if time_economic==.
replace time_unpaidservice=0 if time_unpaidservice==.
replace time_anywork=0 if time_anywork==.
replace time_total=0 if time_total==.

drop time_economic0 time_unpaidservice0 time_anywork0 time_total0
*time by exhaustive measurment (all activities)
save "timeuse_exhaustive_all.dta", replace
use "timeuse_exhaustive_all.dta", clear

*time by exhaustive measurment (each invididual)
keep if activity_id==1 
save "timeuse_exhaustive.dta", replace
use "timeuse_exhaustive.dta", replace
sum time_new time_employment time_goods time_domestic time_caregiving time_otherunpaid time_learning time_social time_leisure time_selfcare time_economic time_unpaidservice time_anywork time_total
