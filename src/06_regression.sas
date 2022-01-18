*Set basepath to the location of the folder acting as this project's directory;
%let basepath= C:/IndianaVax;
libname mydata "&basepath/output";

*Regreission stats;
proc reg data=mydata.merged;
model asian_diff = asian_pop_pct; *R-sq=.0059 p=.4686;
model black_diff = black_pop_pct; *R-s=.9279, p<.0001;
model white_diff = white_pop_pct;*R-sq=.2408, p<.0001;
model hispanic_diff = hispanic_pop_pct; *R-sq = .8791, p<.0001;
model non_hispanic_diff = non_hispanic_pop_pct; *R-sq = .1395, p < .001;
run;


*Regression plots;
ods pdf file="&basepath/output/regression.pdf";
proc sgplot data=mydata.merged;
reg x=white_pop_pct y=white_diff /datalabel=b_label cli clm legendlabel="Fit";
title "White population percentage and vaccine administration, by Indiana county";
run; title; quit;
proc sgplot data=mydata.merged;
reg x=black_pop_pct y=black_diff /datalabel=b_label cli clm legendlabel="Fit";
yaxis max=0 min=-12.5;
xaxis max=30 min=0;
title "Black population percentage and vaccine administration, by Indiana county";
title2 "Labeled: Top five Black population percentages";
run; title; title2; quit;
proc sgplot data=mydata.merged;
reg x=hispanic_pop_pct y=hispanic_diff /datalabel=h_label cli clm legendlabel="Fit";
yaxis max=0 min=-12.5;
xaxis max=20 min=0;
title "Hispanic population percentage and vaccine administration, by Indiana county";
title2 "Labeled: Top five Hispanic population percentages";
run; title; title2; quit;
proc sgplot data=mydata.merged;
reg x=non_hispanic_pop_pct y=non_hispanic_diff /datalabel=h_label cli clm legendlabel="Fit";
title "Non-Hispanic population percentage and vaccine administration, by Indiana county";
title2 "Labeled: Top five Hispanic population percentages";
run; title; title2; quit;
proc sgplot data=mydata.merged;
reg x=asian_pop_pct y=asian_diff /datalabel=a_label cli clm legendlabel="Fit";
title "Asian population percentage and vaccine administration, by Indiana county";
title2 "Labeled: Top five Asian population percentages";
run; title; title2; quit;
ods pdf close;

*Panel plots;
ods listing gpath="&basepath/output";
ods graphics / imagename="regpanel" imagefmt=png;
proc sgscatter data=mydata.merged;
plot asian_diff*asian_pop_pct
		black_diff*black_pop_pct
		hispanic_diff*hispanic_pop_pct
		white_diff*white_pop_pct
		non_hispanic_diff*non_hispanic_pop_pct /axisextent=data uniscale=y reg=(clm lineattrs=(pattern=34));
title "Relationship between VDIF and population proportion, by demographic group and Indiana county";
run; title; quit;
