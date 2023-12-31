#SELECT count(distinct FIRST_CAREUNIT) FROM `mimic3_demo.ICUSTAYS`

#SELECT LABEL FROM `mimic3_demo.D_ITEMS`
#  WHERE lower(LABEL) like "%weight%"
#  GROUP BY LABEL

#SELECT count(ICUSTAY_ID) FROM `mimic3_demo.ICUSTAYS`

#SELECT min(INTIME) FROM `mimic3_demo.ICUSTAYS`

#SELECT max(OUTTIME) FROM `mimic3_demo.ICUSTAYS`

#SELECT count(distinct SUBJECT_ID) as SUBJECT_COUNT FROM `mimic3_demo.ICUSTAYS`

#SELECT count(distinct HADM_ID) as SUBJECT_COUNT FROM `mimic3_demo.ICUSTAYS` GROUP BY SUBJECT_ID ORDER BY SUBJECT_COUNT desc

#SELECT HADM_ID, count(distinct ICUSTAY_ID) AS count_ICU 
#  FROM mimic3_demo.ICUSTAYS 
#  GROUP BY HADM_ID 
#  ORDER BY count_ICU DESC

#SELECT * FROM `mimic3_demo.DIAGNOSES_ICD` a INNER JOIN `mimic3_demo.D_ICD_DIAGNOSES` b using(ICD9_CODE)

#SELECT LABEL FROM `mimic3_demo.D_ITEMS`
#  WHERE lower(LABEL) like "%weight%"
#  GROUP BY LABEL

#SELECT count(ICD9_CODE) FROM `mimic3_demo.DIAGNOSES_ICD`
#  WHERE ICD9_CODE in 
#        (SELECT ICD9_CODE FROM `mimic3_demo.D_ICD_DIAGNOSES` WHERE lower(LONG_TITLE) like "%hypertension%")

#SELECT * FROM mimic3_demo.PATIENTS 
#  WHERE SUBJECT_ID in 
#    (SELECT SUBJECT_ID FROM mimic3_demo.INPUTEVENTS_MV 
#        GROUP BY SUBJECT_ID)

SELECT count(HADM_ID) FROM `mimic3_demo.ADMISSIONS` WHERE ADMISSION_LOCATION = 'EMERGENCY ROOM ADMIT'

#SELECT count(HADM_ID) FROM mimic3_demo.PATIENTS INNER JOIN mimic3_demo.MICROBIOLOGYEVENTS using(SUBJECT_ID)

#SELECT SUBJECT_ID, count(HADM_ID) as count FROM `mimic3_demo.PRESCRIPTIONS` GROUP BY SUBJECT_ID ORDER BY count desc

