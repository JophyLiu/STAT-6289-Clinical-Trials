data scores;
   input Treatment $ Response value;
   datalines;
Placebo 1 16
Test 1 40
Placebo 0 48
Test 0 20
;
proc freq data=scores;
table treatment*Response / chisq;
exact pchi or;;
weight value;
run;

proc freq data=scores;
table Response*Nonresponse/chisq;
run;


proc summary data=final print;
var HbA1c_level;
class Visit_number Control_treatment;
run;

/*1.1*/
proc means data=final MEAN STDERR;
var HbA1c_level;
class Visit_number Control_treatment;
run;

/*1.2*/
proc ttest data=final;
class Control_treatment;
var HbA1c_level;
run;

proc ttest data=final;
class Visit_number Control_treatment;
var HbA1c_level;
run;

/*1.3*/
proc npar1way data=final wilcoxon;
class Control_treatment;
var HbA1c_level;
run;


/*1.4*/
proc multtest data=final permutation;
class Control_treatment;
test mean(HbA1c_level);
run;


/*2*/
proc sql;
create table final2 as
select PATID,Visit_number,HBA1C_level as baseline
from final
where Visit_number=1
group by PATID;


proc sql;
create table final3 as 
select a.*,b.baseline
FROM final as a, final2 as b 
WHERE a.PATID=b.PATID;

data final3;
set final3;
different=HBA1C_level-baseline;
run;

data final3;
set final3;
if Visit_number=1 then delete;
run;


/*2.1*/
proc means data=final3 MEAN STDERR;
var different;
class Visit_number Control_treatment;
run;

/*2.2*/
proc ttest data=final3;
class Control_treatment;
var different;
run;

/*2.3*/
proc npar1way data=final3 wilcoxon;
class Control_treatment;
var different;
run;


/*2.4*/
proc multtest data=final3 permutation;
class Control_treatment;
test mean(different);
run;

/*3*/

proc mixed data=final3;
class Visit_number Control_treatment;
model different=Visit_number Control_Treatment Visit_number*Control_treatment;
run;




