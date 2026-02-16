# riskcalc
Risk calculator of chronic diseases based on age, BMI, etc

#------------------------------------------------------------------------------------------------------------------------------

Alzheimers
https://www.kaggle.com/datasets/rabieelkharoua/alzheimers-disease-dataset?resource=download

Dementia

#------------------------------------------------------------------------------------------------------------------------------

Parkinson's
https://www.kaggle.com/datasets/vikasukani/parkinsons-disease-data-set?resource=download 

Attribute Information:

Matrix column entries (attributes):
name - ASCII subject name and recording number
MDVP:Fo(Hz) - Average vocal fundamental frequency
MDVP:Fhi(Hz) - Maximum vocal fundamental frequency
MDVP:Flo(Hz) - Minimum vocal fundamental frequency
MDVP:Jitter(%), MDVP:Jitter(Abs), MDVP:RAP, MDVP:PPQ, Jitter:DDP - Several measures of variation in fundamental frequency
MDVP:Shimmer,MDVP:Shimmer(dB),Shimmer:APQ3,Shimmer:APQ5,MDVP:APQ,Shimmer:DDA - Several measures of variation in amplitude
NHR, HNR - Two measures of the ratio of noise to tonal components in the voice
status - The health status of the subject (one) - Parkinson's, (zero) - healthy
RPDE, D2 - Two nonlinear dynamical complexity measures
DFA - Signal fractal scaling exponent
spread1,spread2,PPE - Three nonlinear measures of fundamental frequency variation

#---------------------
Code: 
#PARKINSONS
dir.create("data")
#move downloaded "parkinsons.data" file to data folder

<<<<<<< HEAD
parkinsons <- read.csv("data/parkinsons.data")
head(parkinsons)

#------------------------------------------------------------------------------------------------------------------------------

Huntington's
ALS

#------------------------------------------------------------------------------------------------------------------------------



