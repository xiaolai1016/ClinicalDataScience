#SELECT * FROM `mimic3_demo.PATIENTS` a INNER JOIN `mimic3_demo.ADMISSIONS` b on a.SUBJECT_ID = b. SUBJECT_ID

# SELECT * except(ROW_ID) FROM `mimic3_demo.PATIENTS` a INNER JOIN `mimic3_demo.ADMISSIONS` b on a.SUBJECT_ID = b. SUBJECT_ID

#SELECT * except(ROW_ID) FROM `mimic3_demo.PATIENTS` a INNER JOIN `mimic3_demo.ADMISSIONS` b using(SUBJECT_ID)

#SELECT a.SUBJECT_ID, a.GENDER, b.HADM_ID, b.ADMITTIME, b.DISCHTIME FROM mimic3_demo.PATIENTS a
#    INNER JOIN mimic3_demo.ADMISSIONS b using(SUBJECT_ID)

#SELECT a. ROW_ID, b.ROW_ID, a.SUBJECT_ID, a.GENDER, b.HADM_ID, b.ADMITTIME, b.DISCHTIME FROM mimic3_demo.PATIENTS a
#    INNER JOIN mimic3_demo.ADMISSIONS b using(SUBJECT_ID)

#SELECT a, b FROM mimic3_demo.PATIENTS a
#    INNER JOIN mimic3_demo.ADMISSIONS b using(SUBJECT_ID)

SELECT * FROM mimic3_demo.PATIENTS 
  WHERE SUBJECT_ID in 
        (SELECT SUBJECT_ID FROM mimic3_demo.INPUTEVENTS_CV GROUP BY SUBJECT_ID)





