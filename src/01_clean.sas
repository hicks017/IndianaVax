*Set basepath to the location of the folder acting as this project's directory;
%let basepath= C:/IndianaVax;
libname mydata "&basepath/output";

*Vaccinations by race;
Proc Import datafile="&basepath/data/county-vaccination-demographics.xlsx"
Dbms=XLSX Out=INvax replace; Getnames=yes; Run;

*Vaccinations by ethnicity;
Proc Import datafile="&basepath/data/county-vaccination-demographics2.xlsx"
Dbms=XLSX Out=Ethvax replace; Getnames=yes; Run;

*Population by race;
Proc Import datafile="&basepath/data/IndianaCountyRace2019.csv"
Out=race Dbms=csv replace; Run;

*Population by ethnicity;
Proc Import datafile="&basepath/data/IndianaCountyEthnic2019.csv"
Out=ethnic Dbms=csv replace; Run;

*Edit vaccinations by race data;
Data INvax2;
Retain county
		region
		fips
		race
		dose1
		dose2
		single_dose
		all_doses
		fully_vax
		new_dose1
		new_dose2
		new_single_dose
		new_all_doses
		new_fully_vax
		current_as_of
		i
		first_dose_administered
		second_dose_administered
		single_dose_administered
		all_doses_administered
		fully_vaccinated
		new_first_dose_administered
		new_second_dose_administered
		new_single_dose_administered
		new_all_doses_administered
		new_fully_vaccinated;
set INvax;
*Converting missing indicator to system missing;
array convert(10) first_dose_administered
					second_dose_administered
					single_dose_administered
					all_doses_administered
					fully_vaccinated
					new_first_dose_administered
					new_second_dose_administered
					new_single_dose_administered
					new_all_doses_administered
					new_fully_vaccinated;
Do i = 1 to 10;
If convert(i) = "Suppressed" then convert(i) = " ";
End;
*Converting text to numeric;
array char(10) first_dose_administered
				second_dose_administered
				single_dose_administered
				all_doses_administered
				fully_vaccinated
				new_first_dose_administered
				new_second_dose_administered
				new_single_dose_administered
				new_all_doses_administered
				new_fully_vaccinated;;
array num(10) dose1
				dose2
				single_dose
				all_doses
				fully_vax
				new_dose1
				new_dose2
				new_single_dose
				new_all_doses
				new_fully_vax;
Do i = 1 to 10;
num(i) = input(char(i), 8.);
end;
Drop first_dose_administered
	second_dose_administered
	single_dose_administered
	all_doses_administered
	fully_vaccinated
	new_first_dose_administered
	new_second_dose_administered
	new_single_dose_administered
	new_all_doses_administered
	new_fully_vaccinated
	i; Run;

*Edit vaccinations by ethnicity data;
Data Ethvax2;
Retain county
		region
		fips
		ethnicity
		dose1
		dose2
		single_dose
		all_doses
		fully_vax
		new_dose1
		new_dose2
		new_single_dose
		new_all_doses
		new_fully_vax
		current_as_of
		i
		first_dose_administered
		second_dose_administered
		single_dose_administered
		all_doses_administered
		fully_vaccinated
		new_first_dose_administered
		new_second_dose_administered
		new_single_dose_administered
		new_all_doses_administered
		new_fully_vaccinated;
set Ethvax;
*Converting missing indicator to system missing;
array convert(10) first_dose_administered
					second_dose_administered
					single_dose_administered
					all_doses_administered
					fully_vaccinated
					new_first_dose_administered
					new_second_dose_administered
					new_single_dose_administered
					new_all_doses_administered
					new_fully_vaccinated;
Do i = 1 to 10;
If convert(i) = "Suppressed" then convert(i) = " ";
End;
*Converting text to numeric;
array char(10) first_dose_administered
				second_dose_administered
				single_dose_administered
				all_doses_administered
				fully_vaccinated
				new_first_dose_administered
				new_second_dose_administered
				new_single_dose_administered
				new_all_doses_administered
				new_fully_vaccinated;;
array num(10) dose1
				dose2
				single_dose
				all_doses
				fully_vax
				new_dose1
				new_dose2
				new_single_dose
				new_all_doses
				new_fully_vax;
Do i = 1 to 10;
num(i) = input(char(i), 8.);
end;
Drop first_dose_administered
	second_dose_administered
	single_dose_administered
	all_doses_administered
	fully_vaccinated
	new_first_dose_administered
	new_second_dose_administered
	new_single_dose_administered
	new_all_doses_administered
	new_fully_vaccinated i; Run;

*Creating variables and organizing datasets;
Data race;
set race;
total = "White Alone"n +
		"Black Alone"n +
		"American Ind. or Alaskan Native"n +
		"Asian Alone"n +
		"Native Hawaiian and Other Pac."n +
		"Two or More Races"n;
county = substr(Geography, 1, length(Geography)-11);
run;
Data ethnic;
set ethnic;
rename "Total Population"n = total_eth;
rename "Hispanic or Latino (can be of a"n = Hispanic;
rename "Non-Hispanic or Latino"n = Non_Hispanic;
county = substr(Geography, 1, length(Geography)-11);
run;
Data race2;
length county $12;
retain county "White Alone"n
			"Black Alone"n
			"American Ind. or Alaskan Native"n
			"Asian Alone"n
			"Native Hawaiian and Other Pac."n
			"Two or More Races"n
			total;
set race;
drop Geography statefips countyfips year;
run;
Data ethnic2;
length county $12;
retain county Hispanic Non_Hispanic total_eth;
set ethnic;
drop Geography statefips countyfips year;
run;
Data INvax3;
set INvax2;
keep county race dose1;
rename dose1 = doses;
run;
Data Ethvax3;
set Ethvax2;
keep county ethnicity dose1;
rename dose1 = doses;
run;
Proc sort data=INvax3;
by county race;
run;
Proc sort data=Ethvax3;
by county ethnicity;
run;
Proc transpose data=INvax3 out=INvax3wide prefix=dose;
By county;
var doses;
copy _all_;
run;
Proc transpose data=Ethvax3 out=Ethvax3wide prefix=dose;
By county;
var doses;
copy _all_;
run;
Proc sort data=INvax3wide nodupkey; by county; run;
Proc sort data=Ethvax3wide nodupkey; by county; run;
Data INvax4;
set invax3wide;
drop _NAME_ race doses;
Total_dose = sum(dose1, dose2, dose3, dose4, dose5);
rename dose1 = dose_Asian;
rename dose2 = dose_Black;
rename dose3 = dose_Other;
rename dose4 = dose_Unknown;
rename dose5 = dose_White;
Run;
Data Ethvax4;
set Ethvax3wide;
drop _NAME_ ethnicity doses;
Total_dose_Eth = sum(dose1, dose2, dose3);
rename dose1 = dose_Hispanic;
rename dose2 = dose_Non_Hispanic;
rename dose3 = dose_UnknownEth;
Run;
Proc sort data=race2;
by county;
run;
Proc sort data=ethnic2;
by county;
run;

*Merging data to one set and calculating vaccine administration and race make-up percentages;
Data mydata.merged;
merge invax4 race2 ethnic2 ethvax4;
by county;
if county = "Unknown" then delete;
if county = "Out of State" then delete;
asian_dose_pct = (dose_Asian / Total_dose)*100;
black_dose_pct = (dose_Black / Total_dose)*100;
other_dose_pct = (dose_Other / Total_dose)*100;
unknown_dose_pct = (dose_Unknown / Total_dose)*100;
white_dose_pct = (dose_White / Total_dose)*100;
hispanic_dose_pct = (dose_Hispanic / Total_dose_Eth)*100;
non_hispanic_dose_pct = (dose_Non_Hispanic / Total_dose_Eth)*100;
unknown_eth_dose_pct = (dose_UnknownEth / Total_dose_Eth)*100;
hispanic_pop_pct = (Hispanic / total_eth)*100;
non_hispanic_pop_pct = (Non_Hispanic / total_eth)*100;
asian_pop_pct = ("Asian Alone"n / total)*100;
black_pop_pct = ("Black Alone"n / total)*100;
two_pop_pct = ("Two or More Races"n / total)*100;
island_pop_pct = ("Native Hawaiian and Other Pac."n / total)*100;
native_pop_pct = ("American Ind. or Alaskan Native"n / total)*100;
white_pop_pct = ("White Alone"n / total)*100;
asian_diff = asian_dose_pct - asian_pop_pct;
black_diff = black_dose_pct - black_pop_pct;
white_diff = white_dose_pct - white_pop_pct;
hispanic_diff = hispanic_dose_pct - hispanic_pop_pct;
non_hispanic_diff = non_hispanic_dose_pct - non_hispanic_pop_pct;
array _nums (5) asian_diff black_diff white_diff hispanic_diff non_hispanic_diff;
do i = 1 to 5;
  _nums{i} = round(_nums{i},.001);
end;
drop i;
b_label = county;
if county not in ("Marion", "Lake", "St. Joseph", "Allen", "La Porte") then b_label = " ";
a_label = county;
if county not in ("Tippecanoe", "Bartholomew", "Monroe", "Hamilton", "Allen") then a_label = " ";
h_label = county;
if county not in ("Lake", "Clinton", "Elkhart", "Cass", "Marion") then h_label = " ";
Label asian_diff = "Asian VDIF";
Label asian_pop_pct = "Asian population (%)";
Label black_diff = "Black VDIF";
Label black_pop_pct = "Black population (%)";
Label white_diff = "White VDIF";
Label white_pop_pct = "White population (%)";
Label hispanic_diff = "Hispanic VDIF";
Label hispanic_pop_pct = "Hispanic population (%)";
Label non_hispanic_diff = "Non-Hispanic VDIF";
Label non_hispanic_pop_pct = "Non-Hispanic population (%)";
run;