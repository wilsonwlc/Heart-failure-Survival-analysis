/*------------------------------- §1: Checking -------------------------------*/
/* Import raw data */
proc import datafile="/home/u46099885/data/S1Data.csv" 
dbms=csv out=work.df0 replace; 
getnames=yes;
datarow=2;
run;

/* Rename columns */
data df0;
set df0;
rename pletelets=platelets 'Ejection.Fraction'n=Ejection_fraction;
run;


/* Check Data type */
ods select Position;
proc contents data=df0 out=_01_check_data_type(keep=name type) varnum;
run;
ods select all;


/* Check dimension */
proc sql;
create table _01_check_dimension as
select memname, nobs, nvar
from dictionary.tables
where libname = "WORK" and memname = upcase('df0');
quit;
/* Number of rows: 299 */
/* Number of columns: 13 */


/* Check missing values */
/* Caution: The following code only works for numerical variables. In this analysis, only numerical variables */
proc means data=df0 n nmiss;
output out=_01_check_missing;
run;


/* Check outliers */
ods graphics / width=3in height=2in;
ods layout gridded columns=3 rows=2 advance=bygroup;
%macro boxplot(var=, title=);
	ods region;
	proc sgplot data=df0;
	vbox &var;
	title "&title";
	yaxis grid;
	run;
title;
%mend;

%boxplot(var=Age, title=Age);
%boxplot(var=Sodium, title=Sodium);
%boxplot(var=Ejection_fraction, title=Ejection fraction);
%boxplot(var=Creatinine, title=Creatinine);
%boxplot(var=Platelets, title=Platelets);
%boxplot(var=CPK, title=CPK);

ods layout end;
ods graphics / reset=width reset=height;


/*------------------------ §2: Data exploration analysis ------------------------*/
/* Tabulate frequencies */
%macro get_freq(var);
	proc freq data=df0 noprint;
	tables &var*event / nocol nopercent nocum out=temp_&var;
	run;

	data temp_&var;
	retain variable;
	set temp_&var;
	length variable $32;
	variable = "&var";
	rename &var = level;
	run;
%mend get_freq;
%get_freq(gender);
%get_freq(smoking);
%get_freq(diabetes);
%get_freq(bp);
%get_freq(anaemia);
data _02_EDA_freq;
set temp_gender temp_smoking temp_diabetes temp_bp temp_anaemia;      
run;
proc datasets library=work nolist; delete temp_:; quit;
proc print data=_02_EDA_freq;


/* Calculate summary statistics */
proc means data=df0 min q1 median mean q3 max maxdec=2;
var time creatinine sodium cpk age platelets ejection_fraction;
run;


/*------------------------------- §3: Data preparation -------------------------------*/
/* Perform log transformation */
data df1;
set df0;
log_cpk = log(cpk);
log_creatinine = log(creatinine);
run;

/* Perform standarisation */
proc stdize data=df1 out=df1 method=std outstat=_03_std_stat
oprefix=original_ sprefix=standardised_;
var platelets sodium;
run;
data df1;
set df1;
rename original_platelets = platelets original_sodium = sodium;
run;

/* Perform normalisation */
proc stdize data=df1 out=df1 method=range outstat=_03_range_stat
oprefix=original_ sprefix=normalised_;
var age ejection_fraction;
run;
data df1;
set df1;
rename original_age = age original_ejection_fraction = ejection_fraction;
run;


/* Categorisation */
proc univariate data=df1 noprint;
var platelets;
output out=_03_platelet_quartiles pctlpts = 25 75 pctlpre = p_;
run;
data _null_;
set _03_platelet_quartiles;
call symputx('q1', P_25);
call symputx('q3', P_75);
run;

%put The macro is &q1.;
%put The macro is &q3.;


data df1;
set df1;
length age_gp $12 
	   ef_gp $12 ef_paper $12 
	   sodium_gp $20
       platelets_gp $20 platelets_paper $10;
/* Age groups */
if age < 55 then age_gp = '<55 years';
else if age < 65 then age_gp = '55-64 years';
else if age < 75 then age_gp = '65-74 years';
else if age ne . then age_gp = '>=75 years';

/* Ejection fraction groups */
if ejection_fraction < 40 then ef_gp = '<40%';
else if ejection_fraction < 50 then ef_gp = '40-49%';
else if ejection_fraction < 75 then ef_gp = '50-74%';
else if ejection_fraction ne . then ef_gp = '>=75%';

/* Ejection fraction paper groups */
if ejection_fraction <= 30 then ef_paper = '<=30%';
else if ejection_fraction <= 45 then ef_paper = '31-45%';
else if ejection_fraction > 45 then ef_paper = '>45%';

/* Sodium groups */
if sodium < 135 then sodium_gp = '<135mmol/L';
else if sodium < 146 then sodium_gp = '135-145mmol/L';
else if sodium ne . then sodium_gp = '>145mmol/L';

/* Creatinine excess by gender */
if (gender = 0 and creatinine > 1.04) or (gender = 1 and creatinine > 1.35) 
then creatinine_excess = 1;
else if gender ne . and creatinine ne . then creatinine_excess = 0;

/* Paper creatinine threshold */
if creatinine > 1.5 then creatinine_paper = 1;
else if creatinine ne . then creatinine_paper = 0;

/* Platelet groups */
if platelets < 150000 then platelets_gp = 'Thrombocytopenia';
else if platelets < 450001 then platelets_gp = 'Normal';
else if platelets ne . then platelets_gp = 'Thrombocytosis';

/* Paper platelet groups*/
if platelets <= &q1. then platelets_paper = '<=Q1';
else if platelets < &q3. then platelets_paper = 'Q1-Q3';
else if platelets >= &q3. then platelets_paper = '>=Q3';

/* CPK excess */
if cpk > 120 then cpk_excess = 1;
else if cpk ne . then cpk_excess = 0;
run;

proc freq data=df1;
table age_gp ef_gp ef_paper sodium_gp 
creatinine_excess creatinine_paper platelets_gp platelets_paper cpk_excess;
run;

data df_paper;
set df1;
run;

/* Clipping */
data df1;
set df1;
where ef_gp ne ">=75%";
run;













