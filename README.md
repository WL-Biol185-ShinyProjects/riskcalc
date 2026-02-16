# riskcalc
Risk calculator of chronic diseases based on age, BMI, etc

(Dias's Change)

Alzheimers

Dementia

Parkinson's

Huntington's

ALS


Here are datasets for 3 diseases - good balance for your timeline:
1. Alzheimer's Disease
OASIS (Open Access Series of Imaging Studies)
Link: https://www.oasis-brains.org/
Why: Completely open access, no lengthy applications
Data: MRI data, clinical assessments, CDR scores, age, education, MMSE
Size: ~400 subjects (OASIS-1), larger longitudinal cohorts available
Perfect for: Alzheimer's risk/progression
Alternative: ADNI (requires free registration but more comprehensive)
2. Parkinson's Disease
PPMI (Parkinson's Progression Markers Initiative)
Link: https://www.ppmi-info.org/access-data-specimens/download-data
Why: Specifically designed for Parkinson's research, free access
Data: Motor scores, biomarkers, imaging, genetics, age, family history
Size: 400+ Parkinson's patients + controls
Perfect for: Early Parkinson's risk factors
Alternative: mPower study data (more limited but easier)
3. Stroke (my recommendation for #3)
Why stroke instead of Huntington's/ALS:
More common (better for risk calculator utility)
Strong modifiable risk factors (BMI, BP, smoking)
Shares vascular dementia pathway with Alzheimer's
Better available data
Framingham Heart Study - Stroke Risk
Link: https://biolincc.nhlbi.nih.gov/studies/framcohort/
Why: Gold standard for cardiovascular/stroke risk, has public calculators
Data: Age, BP, diabetes, smoking, BMI, cholesterol
Or just implement their published stroke risk score equations
Alternative quick option: Use Kaggle:
"Stroke Prediction Dataset" (free, cleaned, ready to use)
"Brain Stroke Dataset"
Easiest Path Forward:
OASIS - download directly, CSV format
Kaggle Parkinson's datasets - search "Parkinson's disease" (several available)
Kaggle Stroke dataset - immediate access