
/*---------------------------- §4: KM survival curve ----------------------------*/
proc lifetest data=df1 method=km conftype=loglog plots=survival(cl) 
outsurv=_04_estimated_survival_data NOTABLE;
time time*event(0);
run;
proc print data=_04_estimated_survival_data;
run;
/* By covariates */
%let variables = gender smoking diabetes bp anaemia age_gp ef_gp sodium_gp
                 creatinine_excess platelets_gp cpk_excess;
%let titles = Gender Smoking Diabetes Blood_pressure Anaemia Age_group
              Ejection_fraction Sodium Excess_creatinine Platelets Excess_CPK;
%macro survival_plots;
    %let n = %sysfunc(countw(&variables));
    %do i = 1 %to &n;
    	ods graphics on / width=8in height=6in;
		ods select SurvivalPlot;	
        %let var = %scan(&variables, &i);
        %let title = %scan(&titles, &i);
        title "&title";
        proc lifetest data=df1 plots=survival(cl);
            time time*event(0);
            strata &var;
        run;
    %end;
    title;
    ods select all;
    ods graphics off;
%mend survival_plots;
%survival_plots;




/*---------------------------- §5: Log rank test ----------------------------*/
%let variables = gender smoking diabetes bp anaemia age_gp ef_gp sodium_gp
                 creatinine_excess platelets_gp cpk_excess;
%let titles = Gender Smoking Diabetes Blood_pressure Anaemia Age_group
              Ejection_fraction Sodium Excess_creatinine Platelets Excess_CPK;
%macro logrank_tests;
    %let n = %sysfunc(countw(&variables));
    ods graphics off;
    %do i = 1 %to &n;
    
        %let var = %scan(&variables, &i);
        %let title = %scan(&titles, &i);
        
        title "Log-rank Test - &title";
        
        ods select HomTests;
        ods output HomTests=_temp_logrank;
        
        proc lifetest data=df1;
            time time*event(0);
            strata &var / test=logrank;
        run;
        ods output close;
        ods select all;
        
        data _temp_logrank;
            length Variable $32;
            set _temp_logrank;
            Variable = "&var";
        run;
		%if &i = 1 %then %do;
		    data _04_logrank_all;
		        set _temp_logrank;
		    run;
		%end;
		%else %do;
		    data _04_logrank_all;
		        set _04_logrank_all _temp_logrank;
		    run;
		%end;
    %end;
    title;
    proc datasets library=work nolist; delete _temp_logrank; quit;
%mend logrank_tests;
%logrank_tests;






