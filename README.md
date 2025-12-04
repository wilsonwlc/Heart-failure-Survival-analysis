# Heart failure - Survival analysis
## Aim
* Analyse survival among heart failure patients in Faisalabad, Pakistan, and identify key risk factors contributing to mortality using Cox regression modelling

## Data 
The dataset is downloaded from a research paper ["Survival analysis of heart failure patients: A case study"](https://journals.plos.org/plosone/article/file?id=10.1371/journal.pone.0181001&type=printable)
* `time`: Measured in days, from admission to either death or the end of the follow-up period (censored if the patient survived beyond the study period)
* `event`: Dead or censored (survived or lost to follow-up by the end of the study). 0 - censored; 1 - death
* `gender`: 0 - female; 1 - male
* `smoking`: Smoking status based on physician notes. 0 - No; 1 - Yes
* `diabetes`: The presence of diabetes mellitus. 0 - No; 1 - Yes
* `bp`: High blood pressure based on physician notes. 0 - No; 1 - Yes
* `anaemia`: A condition in which the body does not have enough healthy red blood cells. 0 - No; 1 - Yes
* `age`: Measured in years, representing the patient’s age at the time of admission
* `ejection.fraction`: [Ejection Fraction](https://my.clevelandclinic.org/health/articles/16950-ejection-fraction) measures how well the heart pumps blood. A healthy ejection fraction should range from 50% to 75%. A mid-range ejection fraction of 40% to 49% indicates the heart’s pumping ability is slightly below normal. The subject might not experience heart failure symptoms. An ejection fraction of 39% or less is considered heart failure with reduced ejection fraction (HFrEF). The lower the ejection fraction, the higher the risk of life-threatening complications. An ejection fraction of 75% or higher is rare and may indicate hypertrophic cardiomyopathy, a potentially dangerous condition. 
* `sodium`: [Sodium levels](https://www.ucsfhealth.org/medical-tests/sodium-blood-test) normally range from 135 to 145 mEq/L. [Hyponatremia](https://my.clevelandclinic.org/health/diseases/17762-hyponatremia) occurs when sodium levels fall below 135 mEq/L, with mild hyponatremia (130-135 mEq/L) linked to increased morbidity and moderate to severe hyponatremia (<130 mEq/L) strongly associated with higher mortality, particularly in patients with heart failure or left ventricular systolic dysfunction. [Hypernatremia](https://my.clevelandclinic.org/health/diagnostics/21790-electrolytes), defined as sodium levels above 145 mEq/L, is less common in heart disease patients but can occur in conditions such as dehydration or renal dysfunction.
* `creatinine`: A [creatinine](https://www.mayoclinic.org/tests-procedures/creatinine-test/about/pac-20384646) test is a measure of how well the kidneys are performing their job of filtering waste from the blood. For adult men, creatinine levels above 1.35 mg/dL are typically considered high, while for adult women, levels above 1.04 mg/dL are considered elevated
* `platelets`: [Platelets](https://my.clevelandclinic.org/health/diagnostics/21782-platelet-count) are small, colourless cell fragments in the blood that help form clots to stop or prevent bleeding. Normal platelet levels range from 150,000 to 450,000 per microlitre (μL) of blood. Thrombocytopenia occurs when platelet levels fall below 150,000/μL, while thrombocytosis refers to platelet counts higher than 450,000/μL 
* `cpk`: It stands for [creatine phosphokinase](https://www.webmd.com/a-to-z-guides/what-is-the-cpk-enzyme-test). High levels of CPK usually indicate some sort of stress or injury to your heart or other muscles. In the hospital, a person’s CK-MB level is often checked when they exhibit signs of heart attack. Its normal values should range from 10 to 120 micrograms per litre (mcg/L). High CPK can indicate heart attack

## File structure
- `data/S1Data.csv`: Dataset used for the analysis containing patient information including survival time, event status, and various clinical measurements.
- `research paper/paper - cox regression.pdf`: Research paper titled "Survival Analysis of Heart Failure Patients: A Case Study," authored by Ahmad T., Munir A., Bhatti S.H., Aftab M., and Raza M.A.
- `1 - Method/`: Contains documentation files explaining the statistical methods used in the analysis, including Kaplan-Meier estimator, log-rank test, and Cox regression.
- `2 - Result/`: Contains Jupyter notebooks implementing the analysis pipeline, from data preprocessing to final statistical analysis and visualization.

## Conclusion
* A one-unit increase in normalised age was associated with a more than eightfold increase in the hazard of the event (Hazard Ratio [HR] = 8.03, p < 0.001), indicating a strong positive association with risk.
* Participants with an ejection fraction of 40–49% exhibited a 60% reduction in hazard compared to the reference group (<40%) (HR = 0.40, p = 0.009).
* An ejection fraction of 50–74% was associated with a 51% lower hazard relative to the reference group (HR = 0.49, p = 0.017), supporting the protective effect of higher ejection fraction.
* Individuals in the elevated blood pressure group demonstrated a 62% higher hazard in comparison to the reference category (HR = 1.62, p = 0.022), suggesting increased cardiovascular risk.
* Each unit increase in the logarithm of serum creatinine was associated with a 169% increase in hazard (HR = 2.69, p < 0.001), highlighting impaired renal function as a significant risk factor.
