/*---------------------------- §6: Cox regression ----------------------------*/
/* Original model mentioned in the published paper */
proc phreg data=df_paper;
class ef_paper(ref='<=30%') platelets_paper(ref='Q1-Q3') / param=ref;
model time*event(0) =
    age
    gender
    ef_paper
    smoking
    diabetes
    bp
    creatinine_paper
    sodium
    log_cpk
    anaemia
    platelets_paper / ties=efron;

assess ph / resample;
run;
/* The Supremum Test for Proportionals Hazards Assumption from SAS is different from 
	the result from cox.zph(best_fit). 
	Reason: They use different statistical methods to 
	assess the proportional hazards (PH) assumption*/


/* Proposed model */
proc phreg data=df1;
class sodium_gp(ref="135-145mmol/L") platelets_gp(ref="Normal") / param=ref;
model time*event(0) =
      normalised_age
      gender
      normalised_ejection_fraction
      smoking
      diabetes
      bp
      log_creatinine
      sodium_gp
      log_cpk
      anaemia
      platelets_gp / selection=stepwise slentry=0.05 slstay=0.05;
assess ph / resample;
run;

/* Categorisation - including assessing PH assumption */
data df1_id;
set df1;
obs_id = _N_;
run;
proc phreg data=df1_id;
class ef_gp(ref="<40%") sodium_gp(ref="135-145mmol/L") platelets_gp(ref="Normal") / param=ref;
/* model time*event(0) = */
/*       normalised_age */
/*       gender */
/*       ef_gp */
/*       smoking */
/*       diabetes */
/*       bp */
/*       log_creatinine */
/*       sodium_gp */
/*       log_cpk */
/*       anaemia */
/*       platelets_gp / selection=stepwise slentry=0.05 slstay=0.05; */
model time*event(0) = normalised_age ef_gp bp log_creatinine anaemia;
hazardratio normalised_age;
hazardratio ef_gp;
hazardratio bp;
hazardratio log_creatinine;
hazardratio anaemia;
assess ph / resample;
output out=_05_influence_diag
dfbeta=_all_ ld=ld lmax=lmax resmart=martingale resdev=deviance;
run;


/* Identify obs that may have an unusually large influence on the overall model */
proc sort data=_05_influence_diag out=_05_influence_diag_ld;
by descending ld;
run;
proc print data=_05_influence_diag_ld(obs=20);
var obs_id time event ld lmax;
run;

proc sgplot data=_05_influence_diag_ld;
title "Likelihood Displacement versus Follow-up Time";
scatter x=time y=ld / datalabel=obs_id;
xaxis label="Follow-up time";
yaxis label="Likelihood displacement";
run;
title;

proc sgplot data=_05_influence_diag_ld;
title "Deviance Residuals versus Follow-up Time";
scatter x=time y=deviance / datalabel=obs_id;
refline 0 / axis=y;
xaxis label="Follow-up time";
yaxis label="Deviance residual";
run;
title;

/* Identify obs that disproportionately influence the estimated reg coeff for specific predictor */
proc sgplot data = _05_influence_diag;
title "Normalised Age";
scatter x=obs_id y=DFBETA_normalised_Age;
run;
title;

proc sgplot data = _05_influence_diag;
title "EF group - 40-49%";
scatter x=obs_id y="DFBETA_ef_gp40-49%"n;
run;
title;

proc sgplot data = _05_influence_diag;
title "EF group - 50-74%";
scatter x=obs_id y="DFBETA_ef_gp50-74%"n;
run;
title;

proc sgplot data = _05_influence_diag;
title "BP";
scatter x=obs_id y=DFBETA_BP;
run;
title;

proc sgplot data = _05_influence_diag;
title "Log creatinine";
scatter x=obs_id y=DFBETA_log_creatinine;
run;
title;

proc sgplot data = _05_influence_diag;
title "Anaemia";
scatter x=obs_id y=DFBETA_anaemia;
run;
title;