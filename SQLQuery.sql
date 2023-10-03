USE NHS;
GO

SELECT p.subject_id FROM Patients p
INNER JOIN Admission a ON p.subject_id = a.subject_id;

SELECT d.subject_id FROM Diagnosis d
INNER JOIN Admission a ON d.subject_id = a.subject_id;

SELECT gender, dob, admission_type, ethnicity FROM Patients
INNER JOIN Admission ON Patients.subject_id = Admission.subject_id
WHERE gender = 'f';

--Retrieve all female patients with their date of birth and date of death. The date formate like this: MM/DD/YYYY
SELECT 
    subject_id, 
    FORMAT(CONVERT(datetime, dob, 103), 'MM/dd/yyyy') AS dob, 
    FORMAT(CONVERT(datetime, dod, 103), 'MM/dd/yyyy') AS dod
FROM 
    patients 
WHERE 
    gender = 'F';

--Retrieve all female patients with their date of birth and date of death. The date formate like this: MM-DD-YYYY
SELECT 
    PatientName, 
    FORMAT(DateOfBirth, 'MM-dd-yyyy') AS FormattedDOB,
    FORMAT(DateOfDeath, 'MM-dd-yyyy') AS FormattedDOD
FROM 
    Patients
WHERE 
    Gender = 'Female' 
    AND DateOfBirth IS NOT NULL
    AND DateOfDeath IS NOT NULL;


--Find Patients who were first admitted when they were over 20 years old. list the first admission time in this format: mm/dd YYYY
SELECT 
    p.patient_id, 
    FORMAT(MIN(a.admission_time), 'MM/dd yyyy') as first_admission_date
FROM 
    patients p
JOIN 
    admissions a ON p.patient_id = a.patient_id
WHERE 
    DATEDIFF(YEAR, p.dob, MIN(a.admission_time)) > 20
GROUP BY 
    p.patient_id;

SELECT gender, dob, admission_type, ethnicity, dischtime FROM Patients
INNER JOIN Admission ON Patients.subject_id = Admission.subject_id
WHERE  dischtime BETWEEN '2124-01-01 00:00:00' AND '2186-12-31 23:59:59';

SELECT gender, dob, admission_type, ethnicity, dischtime FROM Patients
INNER JOIN Admission ON Patients.subject_id = Admission.subject_id
WHERE  dischtime >= '2124-01-01 00:00:00';

SELECT gender, dob, admission_type, ethnicity, dischtime FROM Patients
INNER JOIN Admission ON Patients.subject_id = Admission.subject_id
WHERE  dischtime BETWEEN '2124-01-01 00:00:00' AND '2186-12-31 23:59:59'
AND ethnicity = 'WHITE' OR ethnicity = 'BLACK/AFRICAN AMERICAN';

--Retrieve all female patients with their date of birth and date of death.
SELECT gender, dob, dod FROM Patients
WHERE gender = 'F';

--Find the count of patients for each gender.
SELECT  gender, COUNT(gender) AS gender_count FROM Patients
GROUP BY gender;

--List all unique admission types from the Admission table.
SELECT DISTINCT admission_type FROM Admission;

--Find the total number of patients who have expire_flag set to 1 and were admitted through the "EMERGENCY" admission_type.
SELECT COUNT(*) FROM Patients
INNER JOIN Admission ON Patients.subject_id = Admission.subject_id
WHERE expire_flag = '1' AND admission_type = 'EMERGENCY';

--Retrieve the subject_id and diagnosis of patients who were admitted after the year 2000 and were discharged before the year 2010.
SELECT a.subject_id, d.icd9_code FROM Admission a
INNER JOIN Diagnosis d ON a.subject_id = d.subject_id
WHERE YEAR(a.admittime) >= 2130 AND YEAR(a.dischtime) <= 2190;

--List the subject_id of patients who have more than 3 diagnoses in the Diagnosis table.
SELECT d.subject_id, COUNT(d.row_id) AS NoOfDiagnoses FROM Diagnosis d
GROUP BY d.subject_id
HAVING COUNT(d.row_id)  > 3;

--Retrieve the subject_id, dob and admittime for patients who were admitted on their birthday.
SELECT a.subject_id, p.dob, a.admittime FROM Patients p
INNER JOIN Admission a ON p.subject_id = a.subject_id
WHERE CAST(a.admittime AS DATE) != CAST(p.dob AS DATE);

--Find the average age of patients at the time of their first admission.
WITH FirstAdmission AS (
    SELECT p.subject_id, 
           p.dob, 
           MIN(a.admittime) AS first_admittime
    FROM Patients p
    JOIN Admission a ON p.subject_id = a.subject_id
    GROUP BY p.subject_id, p.dob
)

SELECT AVG(DATEDIFF(YEAR, dob, first_admittime) - 
           CASE 
               WHEN MONTH(dob) > MONTH(first_admittime) 
                   OR (MONTH(dob) = MONTH(first_admittime) AND DAY(dob) > DAY(first_admittime)) 
               THEN 1 
               ELSE 0 
           END) AS avg_age_at_first_admission
FROM FirstAdmission;


--For each admission_type, find the average, minimum, and maximum duration of stay (difference between admittime and dischtime).
SELECT admission_type, MAX(DATEDIFF(day, admittime, dischtime)) AS MaxDayDiff, 
MIN(DATEDIFF(day, admittime, dischtime)) AS MinDayDiff, 
AVG(DATEDIFF(day, admittime, dischtime)) AS AvgDayDiff 
FROM Admission
GROUP BY admission_type;


--Identify patients who have both "SEPSIS" and "STROKE/TIA" as diagnoses during any of their hospital visits.
SELECT DISTINCT p.subject_id
FROM [NHS].[dbo].[Patients] p
WHERE 
    EXISTS (
        SELECT 1
        FROM [NHS].[dbo].[Admission] a
        INNER JOIN [NHS].[dbo].[Diagnosis] d ON a.hadm_id = d.hadm_id
        WHERE a.subject_id = p.subject_id
        AND d.icd9_code = '40391' 
    )
    AND
    EXISTS (
        SELECT 1
        FROM [NHS].[dbo].[Admission] a
        INNER JOIN [NHS].[dbo].[Diagnosis] d ON a.hadm_id = d.hadm_id
        WHERE a.subject_id = p.subject_id
        AND d.icd9_code = '99662'
    );

--List the top 5 most common diagnoses (icd9_code) and their respective counts.
SELECT icd9_code, COUNT(*) AS diaCount FROM Diagnosis
GROUP BY icd9_code
ORDER BY diaCount DESC;

--Find the month which had the highest number of admissions in the year 2015.
SELECT COUNT(*) AS MonCOUNT FROM Admission
WHERE YEAR(admittime) = 2171
GROUP BY MONTH(admittime)
ORDER BY MonCOUNT DESC;

--Retrieve patients who were admitted more than once in a span of 30 days.
WITH RepeatedAdmissions AS (
    SELECT a1.subject_id, a1.admittime AS FirstAdmission, a2.admittime AS SecondAdmission
    FROM [NHS].[dbo].[Admission] a1
    INNER JOIN [NHS].[dbo].[Admission] a2 ON a1.subject_id = a2.subject_id
    WHERE 
        a2.admittime > a1.admittime
        AND DATEDIFF(DAY, a1.admittime, a2.admittime) BETWEEN 1 AND 30
)

SELECT DISTINCT subject_id, FirstAdmission, SecondAdmission
FROM RepeatedAdmissions;

--Identify the subject_id of patients who have never been readmitted.
SELECT subject_id
FROM [NHS].[dbo].[Admission]
GROUP BY subject_id
HAVING COUNT(hadm_id) = 1;

--For each insurance type, find the percentage of patients who expired (hospital_expire_flag set to 1) during their hospital stay.


--Determine the mortality rate (ratio of patients with expire_flag set to 1 versus total patients) for each ethnicity.
SELECT 
    ethnicity,
    SUM(CASE WHEN hospital_expire_flag = 1 THEN 1 ELSE 0 END) AS expired_count,
    COUNT(*) AS total_count,
    CAST(SUM(CASE WHEN hospital_expire_flag = 1 THEN 1 ELSE 0 END) AS FLOAT) / CAST(COUNT(*) AS FLOAT) * 100 AS mortality_rate_percentage
FROM 
    [NHS].[dbo].[Admission]
GROUP BY 
    ethnicity;

--Identify any potential data inconsistencies, such as patients with a deathtime in the Admission table but having expire_flag set to 0 in the Patients table.

--Based on the Diagnosis table, find comorbidity patterns (pairs of icd9_code that appear together frequently) for patients.

--Analyze the admission_location and discharge_location fields to determine the most common patient flow pattern during hospital stays (e.g., from "EMERGENCY ROOM ADMIT" to "HOME HEALTH CARE").

--Calculate the readmission rate for each admission_type within a 30-day window, i.e., the percentage of admissions of that type where the patient was readmitted within 30 days of discharge.


