*Set basepath to the location of the folder acting as this project's directory;
%let basepath= C:/IndianaVax;
libname mydata "&basepath/output";

*Mean VDIF by race/ethnicity;
%let a_mean = -0.0555495;
%let b_mean = -1.4533218;
%let w_mean = -2.725;
%let h_mean = -2.1535435;
%let nh_mean = -4.5864457;

*Black versus Asian;
ods listing gpath="&basepath/output";
ods graphics / imagename="BlackVsAsian" imagefmt=png;
proc sgplot data=mydata.merged;
scatter x=black_diff y=asian_diff /datalabel=b_label;
refline &a_mean /axis=y label="Asian(mean)";
refline &b_mean /axis=x label="Black(mean)";
yaxis max=15 min=-15;
xaxis max=15 min=-15;
title "Difference in percentage points of Receiving 1 Dose of COVID-19 Vaccine and Race Proportion of Population, by Indiana Counties";
title2 "Labeled: Top five Black population percentages";
run; title; title2; quit;

*Asian versus White;
ods listing gpath="&basepath/output";
ods graphics / imagename="AsianVsWhite" imagefmt=png;
proc sgplot data=mydata.merged;
scatter x=white_diff y=asian_diff /datalabel=a_label;
refline &w_mean /axis=x label="White(mean)";
refline &a_mean /axis=y label="Asian(mean)";
yaxis max=15 min=-15;
xaxis max=15 min=-15;
title "Difference in percentage points of Receiving 1 Dose of COVID-19 Vaccine and Race Proportion of Population, by Indiana counties";
title2 "Labeled: Top five Asian population percentages";
run; title; title2; quit;



*Hispanic versus Non-Hispanic;
ods listing gpath="&basepath/output";
ods graphics / imagename="HispanicVsNon" imagefmt=png;
proc sgplot data=mydata.merged;
scatter y=hispanic_diff x=non_hispanic_diff /datalabel=h_label;
refline &nh_mean /axis=x label="Non-Hispanic(mean)";
refline &h_mean /axis=y label="Hispanic(mean)";
yaxis max=15 min=-15;
xaxis max=15 min=-15;
title "Difference in percentage points of Receiving 1 Dose of COVID-19 Vaccine and Ethnic Proportion of Population, by Indiana counties";
title2 "Labeled: Top five Hispanic population percentages";
run; title; title2; quit;
proc print data=mydata.merged(where=(county in ("Lake", "Clinton", "Elkhart", "Cass", "Marion")));
var county hispanic_diff non_hispanic_diff;
run;

*Black versus White;
ods listing gpath="&basepath/output";
ods graphics / imagename="BlackVsWhite" imagefmt=png;
proc sgplot data=mydata.merged;
scatter y=black_diff x=white_diff /datalabel=b_label;
refline &w_mean /axis=x label="White(mean)";
refline &b_mean /axis=y label="Black(mean)";
yaxis max=15 min=-15;
xaxis max=15 min=-15;
title "Difference in percentage points of Receiving 1 Dose of COVID-19 Vaccine and Race Proportion of Population, by Indiana counties";
title2 "Labeled: Top five Black population percentages";
run; title; title2; quit;
proc print data=mydata.merged(where=(county in ("Marion", "Lake", "St. Joseph", "Allen", "La Porte")));
var county black_diff white_diff;
run;
