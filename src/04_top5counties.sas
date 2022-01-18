*Set basepath to the location of the folder acting as this project's directory;
%let basepath= C:/IndianaVax;
libname mydata "&basepath/output";

*Top 5 county stats;
ods pdf file="&basepath/output/top5counties.pdf";

*Asian;
proc print data=mydata.merged(where=(asian_pop_pct>4.5));
var county asian_diff asian_pop_pct;
proc means mean std data=mydata.merged(where=(asian_pop_pct>4.5));
var asian_diff;
run;

*Black;
proc print data=mydata.merged(where=(black_pop_pct>10));
var county black_diff black_pop_pct;
proc means mean std data=mydata.merged(where=(black_pop_pct>10));
var black_diff;
run;

*White;
proc print data=mydata.merged(where=(white_pop_pct>97.7));
var county white_diff white_pop_pct;
proc means mean std data=mydata.merged(where=(white_pop_pct>97.7));
var white_diff;
run;

*Hispanic;
proc print data=mydata.merged(where=(hispanic_pop_pct>10.8));
var county hispanic_diff hispanic_pop_pct;
proc means mean std data=mydata.merged(where=(hispanic_pop_pct>10.8));
var hispanic_diff;
run;

*Non-Hispanic;
proc print data=mydata.merged(where=(non_hispanic_pop_pct>98.65));
var county non_hispanic_diff;
proc means mean std data=mydata.merged(where=(non_hispanic_pop_pct>98.65));
var non_hispanic_diff;
run;
ods pdf close;