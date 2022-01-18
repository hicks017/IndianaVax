*Set basepath to the location of the folder acting as this project's directory;
%let basepath= C:/IndianaVax;
libname mydata "&basepath/output";

*VDIF PDF;
ods pdf file="&basepath/output/output/vdif.pdf";
proc means min mean median max std data=mydata.merged;
var asian_diff
	black_diff
	white_diff
	hispanic_diff
	non_hispanic_diff;
run;

*Histograms;
proc univariate data=mydata.merged;
var asian_diff
	black_diff
	white_diff
	hispanic_diff
	non_hispanic_diff;
histogram asian_diff
		black_diff
		white_diff
		hispanic_diff
		non_hispanic_diff /normal;
run;
ods pdf close;