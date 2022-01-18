*Set basepath to the location of the folder acting as this project's directory;
%let basepath= C:/IndianaVax;
libname mydata "&basepath/output";

*Table 1 PDF;
ods pdf file="&basepath/output/table1.pdf";
proc means max mean std data=mydata.merged;
var asian_pop_pct
	black_pop_pct
	white_pop_pct
	hispanic_pop_pct
	non_hispanic_pop_pct
	two_pop_pct
	island_pop_pct
	native_pop_pct;

proc means mean std data=mydata.merged;
var asian_dose_pct
	black_dose_pct
	white_dose_pct
	hispanic_dose_pct
	non_hispanic_dose_pct
	unknown_dose_pct
	unknown_eth_dose_pct;
run;
ods pdf close;