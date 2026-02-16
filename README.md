# riskcalc
Risk calculator of chronic diseases based on age, BMI, etc

#------------------------------------------------------------------------------------------------------------------------------

Alzheimers
https://www.kaggle.com/datasets/rabieelkharoua/alzheimers-disease-dataset?resource=download
Sliders for: age, gender, ethnicity, BMI, smoking (0 - no, 1 - yes), alcohol consumption, physical activity, diet quality, 


#------------------------------------------------------------------------------------------------------------------------------

Chronic Kidney Disease
Sliders for: age, gender, ethnicity, BMI, smoking (0 - no, 1 - yes), alcohol consumption, physical activity, diet quality, 
family history of diabetes (0 - no, 1 - yes), cholesterol total, cholesterol(LDL), cholesterol(HDL), cholesterol(TAG), 


#------------------------------------------------------------------------------------------------------------------------------

Parkinson's
https://www.kaggle.com/code/fratzcan/parkinson-s-disease-prediction/input
Sliders for: age, gender, ethnicity, BMI, smoking (0 - no, 1 - yes), alcohol consumption, physical activity, diet quality, 


#-------------
Code: 
parkinsons <- read.csv("data/parkinsons_disease_data.csv")
head(parkinsons)

#------------------------------------------------------------------------------------------------------------------------------

Diabetes
Sliders for: age, gender, ethnicity, BMI, smoking (0 - no, 1 - yes), alcohol consumption, physical activity, diet quality, 


#------------------------------------------------------------------------------------------------------------------------------


Key for columns: 
- **PatientID**: A unique identifier assigned to each patient (1 to 1,659).
- **Age**: The age of the patients ranges from 20 to 90 years.
- **Gender**: Gender of the patients, where 0 represents Male and 1 represents Female.
- **Ethnicity**: The ethnicity of the patients, coded as follows:
  - 0: Caucasian
  - 1: African American
  - 2: Asian
  - 3: Other
- **SocioeconomicStatus**: The socioeconomic status of the patients
- **EducationLevel**: The education level of the patients, coded as follows:
  - 0: None
  - 1: High School
  - 2: Bachelor's
  - 3: Higher
- **BMI**: Body Mass Index of the patients, ranging from 15 to 40.
- **Smoking**: Smoking status, where 0 indicates No and 1 indicates Yes.
- **AlcoholConsumption**: Weekly alcohol consumption in units, ranging from 0 to 20.
- **PhysicalActivity**: Weekly physical activity in hours, ranging from 0 to 10.
- **DietQuality**: Diet quality score, ranging from 0 to 10.
- **SleepQuality**: Sleep quality score, ranging from 4 to 10.
- **FamilyHistoryKidneyDisease**: Family history of kidney disease, where 0 indicates No and 1 indicates Yes.
- **FamilyHistoryHypertension**: Family history of hypertension, where 0 indicates No and 1 indicates Yes.
- **FamilyHistoryDiabetes**: Family history of diabetes, where 0 indicates No and 1 indicates Yes.
- **PreviousAcuteKidneyInjury**: History of previous acute kidney injury, where 0 indicates No and 1 indicates Yes.
- **UrinaryTractInfections**: History of urinary tract infections, where 0 indicates No and 1 indicates Yes.
- **SystolicBP**: Systolic blood pressure, ranging from 90 to 180 mmHg.
- **DiastolicBP**: Diastolic blood pressure, ranging from 60 to 120 mmHg.
- **FastingBloodSugar**: Fasting blood sugar levels, ranging from 70 to 200 mg/dL.
- **HbA1c**: Hemoglobin A1c levels, ranging from 4.0% to 10.0%.
- **SerumCreatinine**: Serum creatinine levels, ranging from 0.5 to 5.0 mg/dL.
- **BUNLevels**: Blood Urea Nitrogen levels, ranging from 5 to 50 mg/dL.
- **GFR**: Glomerular Filtration Rate, ranging from 15 to 120 mL/min/1.73 m².
- **ProteinInUrine**: Protein levels in urine, ranging from 0 to 5 g/day.
- **ACR**: Albumin-to-Creatinine Ratio, ranging from 0 to 300 mg/g.
- **SerumElectrolytesSodium**: Serum sodium levels, ranging from 135 to 145 mEq/L.
- **SerumElectrolytesPotassium**: Serum potassium levels, ranging from 3.5 to 5.5 mEq/L.
- **SerumElectrolytesCalcium**: Serum calcium levels, ranging from 8.5 to 10.5 mg/dL.
- **SerumElectrolytesPhosphorus**: Serum phosphorus levels, ranging from 2.5 to 4.5 mg/dL.
- **HemoglobinLevels**: Hemoglobin levels, ranging from 10 to 18 g/dL.
- **CholesterolTotal**: Total cholesterol levels, ranging from 150 to 300 mg/dL.
- **CholesterolLDL**: Low-density lipoprotein cholesterol levels, ranging from 50 to 200 mg/dL.
- **CholesterolHDL**: High-density lipoprotein cholesterol levels, ranging from 20 to 100 mg/dL.
- **CholesterolTriglycerides**: Triglycerides levels, ranging from 50 to 400 mg/dL.
- **ACEInhibitors**: Use of ACE inhibitors, where 0 indicates No and 1 indicates Yes.
- **Diuretics**: Use of diuretics, where 0 indicates No and 1 indicates Yes.
- **NSAIDsUse**: Frequency of NSAIDs use, ranging from 0 to 10 times per week.
- **Statins**: Use of statins, where 0 indicates No and 1 indicates Yes.
- **AntidiabeticMedications**: Use of antidiabetic medications, where 0 indicates No and 1 indicates Yes.
- **Edema**: Presence of edema, where 0 indicates No and 1 indicates Yes.
- **FatigueLevels**: Fatigue levels, ranging from 0 to 10.
- **NauseaVomiting**: Frequency of nausea and vomiting, ranging from 0 to 7 times per week.
- **MuscleCramps**: Frequency of muscle cramps, ranging from 0 to 7 times per week.
- **Itching**: Itching severity, ranging from 0 to 10.
- **QualityOfLifeScore**: Quality of life score, ranging from 0 to 100.
- **HeavyMetalsExposure**: Exposure to heavy metals, where 0 indicates No and 1 indicates Yes.
