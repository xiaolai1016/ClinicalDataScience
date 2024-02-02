--need to figure out questionnaire data and see if it null or not.
--also consider templateid is not null then we have the data, but some templateid is not null, cann't extract data.



-- BP health surveillance
--select count(distinct bp.id)
--from (
with bphs as(
select a1.id, 
STRING_AGG(formname, ', ') as formname,
STRING_AGG("type", ', ') as "type"
from (
select p1.id as packageid, p1."name" as packagename, f1."name" as formname, f1.typecode as "type"
from tpackage p1
left join tpackageform pf on pf.packageid = p1.id 
left join tform f1 on f1.id = pf.formid 
where f1.templateid in ('62a2fe049418a613f55db993', --id from wood data
'615c01412d429b43a9551651',
'62ac8cdc9418a613f55dbcb0',
'62bc53159418a613f55dc0c8',
'6311ea689418a613f55ddd0a',
'62cfe4fc9418a613f55dc633',
'64f73348025d4c1039c34637',
'64f87e3b025d4c1039c347a6',
'62bc2bcc9418a613f55dc0aa',
'616822152d429b43a95519a6',
'632c29f89418a613f55de592',
'63fcd491025d4c1039c2d767',
'64f88122025d4c1039c347be',
'63d8de5b025d4c1039c2c5c4',
'63d78ff0025d4c1039c2c4be',
'63fcb185025d4c1039c2d733'
/*'625940139418a613f55daac2', --questionaire
'63fc9f08025d4c1039c2d714', --questionaire
'63fcbffe025d4c1039c2d743', --questionaire
'64f87303025d4c1039c34779', --questionaire
'65043970025d4c1039c3503d' --questionaire*/
)) sd
LEFT join tappointmentpackage a2 on a2.packageid = sd.packageid
left join tappointment a1 on a1.id = a2.appointmentid
LEFT join tclient c1 on a1.bookingorganisationid = c1.id
LEFT join tclinic c2 on a1.clinicid = c2.id
where --a1.healthsurveillance  = '1' and 
a1.organisationid = '17b4b75b-5c32-4cf7-9d46-5149db2b215f' and a1."date" >= '2023-11-01' and a1."date" <= '2023-11-30'
and c1.id in ('f9cd64ba-7fdf-42ab-b3e4-14c616fb9151', --Schlumberger 
'b6445d2b-903b-48f6-b803-faef3b57ee08',
'b0a8fb6c-29d6-4f00-b89f-4ad574ab7670',
'b076aa1e-924f-4bcc-bbac-66565d9df22e',
'a2f2e111-6460-4565-ba17-616f15011276',
'8bc4e44f-635f-484b-9b18-58d93cf5005f',
'89934a13-9788-4f15-b46c-61b5704f067a',
'7117523d-b05b-4bb4-b430-36e5e566924c',
'6edca926-9eb7-4141-b481-df155a7534dd',
'6bab45e7-af24-4f64-ad36-df980f2e8d65',
'54646ceb-a1f7-4673-acda-5635afe3cbca',
'3c8bdd6b-8c4d-4f4f-939d-1804d4d1abd7',
'25b82b54-dbaa-42b0-b03b-7ee0dceb1199',
'02268d3d-874e-4329-9fb2-76307aaf712a'
)
group by a1.id
),
bpappointment as (select DISTINCT p1."name" as medical, a1.id, a1."date" as "start", 
--CONCAT_WS(' ', p2.firstname, p2.middlename, p2.surname) as patientname, p2.id as patientid,
p2.gender, a1.jobtittle as occupation, p2.department, p2.division,  Date_part('year', Age(a1."date", p2.dob)) as "age",
--p2.dob,
CASE
WHEN Date_part('year', Age(a1."date", p2.dob)) < 25 THEN '<25'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 25
AND Date_part('year', Age(a1."date", p2.dob)) < 35 THEN '25-34'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 35
AND Date_part('year', Age(a1."date", p2.dob)) < 45 THEN '35-44'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 45
AND Date_part('year', Age(a1."date", p2.dob)) < 55 THEN '45-54'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 55
AND Date_part('year', Age(a1."date", p2.dob)) < 65 THEN '55-64'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 65 THEN '>=65'
END AS agegroup,
c1.clientname as employer, 
c2.clinicname as sitename, c2.clinictype as appointmenttypename, a4.appointmentstatus as status, f1."name" as formname
from tappointment a1
LEFT join tpatient p2 on a1.patientid = p2.id
LEFT join tclient c1 on a1.bookingorganisationid = c1.id
LEFT join tclinic c2 on a1.clinicid = c2.id
LEFT join tappointmentpackage a2 on a1.id = a2.appointmentid
LEFT join tpackage p1 on a2.packageid = p1.id
left join tappointmenttime a4 on a1.id = a4.appointmentid
left join tsubmittedform s on a1.id = s.appointmentid
left join tform f1 on s.templateid = f1.templateid 
where --a1.healthsurveillance  = '0' and 
a1.organisationid = '17b4b75b-5c32-4cf7-9d46-5149db2b215f' and a1."date" >= '2023-11-01' and a1."date" <= '2023-11-30'
and c1.id in ('f9cd64ba-7fdf-42ab-b3e4-14c616fb9151',
'b6445d2b-903b-48f6-b803-faef3b57ee08',
'b0a8fb6c-29d6-4f00-b89f-4ad574ab7670',
'b076aa1e-924f-4bcc-bbac-66565d9df22e',
'a2f2e111-6460-4565-ba17-616f15011276',
'8bc4e44f-635f-484b-9b18-58d93cf5005f',
'89934a13-9788-4f15-b46c-61b5704f067a',
'7117523d-b05b-4bb4-b430-36e5e566924c',
'6edca926-9eb7-4141-b481-df155a7534dd',
'6bab45e7-af24-4f64-ad36-df980f2e8d65',
'54646ceb-a1f7-4673-acda-5635afe3cbca',
'3c8bdd6b-8c4d-4f4f-939d-1804d4d1abd7',
'25b82b54-dbaa-42b0-b03b-7ee0dceb1199',
'02268d3d-874e-4329-9fb2-76307aaf712a'
)
),
hs as(
select hs1.appointmentid,
hs1.audiooutcome, hs1.audiorecall, hs1.audiostatus, 
hs1.havssymptoms, hs1.havsoutcome, hs1.havsrecall,  
hs1.respiratoryoutcome, hs1.respiratoryrecall, 
hs1.skinoutcome, hs1.skinrecall, 
hs1.shiftworknoutcome, hs1.shiftworkrecall,
case when hs1.audiooutcome = 'No Extractable Data' then 'No Extractable Data'
when hs1.audiooutcome is null
and hs1.audiorecall is null
and hs1.audiostatus is null
and hs1.havssymptoms is null
and hs1.havsoutcome is null
and hs1.havsrecall is null
and hs1.respiratoryoutcome is null
and hs1.respiratoryrecall is null
and hs1.skinoutcome is null
and hs1.skinrecall is null
and hs1.shiftworknoutcome is null
and hs1.shiftworkrecall is null then 'No'
else 'Yes' end as havedata
from (
select s.appointmentid, s.templateid,
case when s.submission ->>'referredToOhpHealthSurveillanceOnly'='true' then 'Referred To OHP (HealthSurveillanceOnly)' end as audiooutcome,
case when s.submission->>'Month'='true' then '1 month'
when s.submission->>'month3'='true' then '3 months'
when s.submission->>'Months'='true' then '6 months'
when s.submission->>'Year'='true' then '1 year'
when s.submission->>'Years'='true' then '2 years'
when s.submission->>'year'='true' then '3 years or Next medical' end as audiorecall,
case when s.submission->> 'noPreviousRecordAvailab'='true' then 'Baseline'
when s.submission->> 'noChange'='true' then 'Unchanged'
when s.submission->> 'improvement'='true' then 'Improved'
when s.submission->> 'deteioration'='true' then 'Deteriorated' end as audiostatus,
--null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid = '62a2fe049418a613f55db993'
union
select s.appointmentid, s.templateid,
case when s.submission -> 'selectBoxes' ->> 'acceptableHearingCategory1'='true' then 'Acceptable Hearing Category1'
when s.submission -> 'selectBoxes' ->> 'mildHearingImpairmentCategory2'='true' then 'Mild Hearing Impairment Category2'
when s.submission -> 'selectBoxes' ->> 'poorHearingCategory3'='true' then 'Poor Hearing Category3'
when s.submission -> 'selectBoxes' ->> 'rapidHearingLossCategory4'='true' then 'Rapid Hearing Loss Category4'
when s.submission -> 'selectBoxes' ->> 'unilateralHearingLoss'='true' then 'Unilateral Hearing Loss' end as audiooutcome, 
case WHEN s.submission -> 'selectBoxes3' ->> '1Month' IS NOT NULL THEN '1 month'
when s.submission -> 'selectBoxes3' ->> '3Months' IS NOT NULL then '3 months'
when s.submission -> 'selectBoxes3' ->> '6Months' IS NOT NULL then '6 months'
when s.submission -> 'selectBoxes4' ->> '1Year' IS NOT NULL then '1 year'
when s.submission -> 'selectBoxes4' ->> '2Years' IS NOT NULL then '2 years'
when s.submission -> 'selectBoxes4' ->> '3YearsOrNextMedical' IS NOT NULL then '3 years or Next medical' end as audiorecall,
--null as audiooutcome, null as audiorecall, 
null as audiostatus, 
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('615c01412d429b43a9551651', '62ac8cdc9418a613f55dbcb0')
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
CASE
      WHEN s.submission ->> 'noSymptomsReported' = 'yes' THEN 'No Symptoms Reported'
      WHEN s.submission ->> 'noSymptomsReported' = 'no' THEN 'Symptoms Reported'
      WHEN s.submission ->> 'symptomsDeclaredWhichMayIndicateHavsRelatedSyndrome' = 'yes' THEN 'Symptoms Declared Which May Indicate Havs Related Syndrome'
      ELSE NULL END AS havssymptoms,
case when s.templateid = '6311ea689418a613f55ddd0a' then 'Not Fit' 
when s.submission ->> 'tier3FaceToFaceReviewIn12MonthsSoonerIfIndicationOfProgressionOfSymptoms' = 'true' then 'Tier 3 Face To Face Review In 12 Months, Sooner If Indication Of Progression Of Symptoms'
when s.submission ->> 'tier4FaceToFaceReviewWithAPhysician' = 'true' then 'Tier 4 Face To Face Review With A Physician'
when s.submission ->> 'other' = 'true' then 'Other'
WHEN s.submission ->> 'symptomsDeclaredWhichMayIndicateHavsRelatedSyndrome' = 'yes' THEN 'Symptoms Declared Which May Indicate Havs Related Syndrome'
end as havsoutcome, 
CASE
     when s.submission->>'Month'='true' then '3 months'
	 when s.submission->>'Months'='true' then '6 months'
	 when s.submission->>'Year'='true' then '1 year'
	 WHEN s.submission ->> 'recall' = '3Months' then'3 months'
	 WHEN s.submission ->> 'recall' = '6Months' then'6 months'
     WHEN s.submission ->> 'recall' = '1Year' then'1 year' ELSE NULL end as havsrecall,
--null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('6311ea689418a613f55ddd0a', '64f73348025d4c1039c34637', '62bc2bcc9418a613f55dc0aa', '64f87e3b025d4c1039c347a6') 
--need get more data after form redesign, including 62bc53159418a613f55dc0c8 and 62cfe4fc9418a613f55dc633
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall, 
case when s.submission->> 'result' = 'satisfactory' then 'Satisfactory'
when s.submission->>'result' = 'referToOccupationalHealthPhysician' then 'Refer To Occupational Health Physician'
when s.submission->> 'fit2' = 'yes' then 'Fit'
when s.submission->> 'referToMedicalAdvisor2' = 'yes' then 'Refer To Medical Advisor'
when s.submission->> 'result' = 'unsatisfactory' then 'Unsatisfactory'
else null end as respiratoryoutcome,
CASE
    WHEN s.submission->> 'reviewRequired' IS NOT NULL THEN s.submission->> 'reviewRequired'
    ELSE s.submission->> 'reviewPeriod'
END as respiratoryrecall,
--null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('64f88122025d4c1039c347be',
'63d8de5b025d4c1039c2c5c4',
'63d78ff0025d4c1039c2c4be')
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall, 
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
case when s.submission->> 'suitableToContinueNightWorking' = 'yes' then 'Suitable To Continue Night Working'
when s.submission->>'requiresOhaTelephoneReview' = 'yes' then 'Requires OHA Telephone Review'
when s.submission->>'requiresOhaNightWorkerHealthAssessment' = 'yes' then 'Requires OHA Night Worker Health Assessment' 
when s.submission ->> 'requiresOhpReferral'='yes' then 'Requires OHA Referral'
when s.submission->> 'fitForNightWork'='true' then 'Fit For Night Work'
when s.submission->> 'fitForNightWorkWithTheFollowingAdjustmentsRecommendations'='true' then 'Fit For Night Work With The Following Adjustments Recommendations'
when s.submission->> 'furtherMedicalInformationIsRequiredBeforeARecommendationCanBeMade'='true' then 'Further Medical Information Is Required Before A Recommendation Can Be Made'
when s.submission->> 'thereIsNoBarrierSpecificallyForNightWorkHoweverAnotherIssueInRelationToGeneralFitnessForWorkHasBeenHighlighted'='true' then 'There Is No Barrier Specifically For Night Work However Another Issue In Relation To General Fitness For Work Has Been Highlighted'
else null end as shiftworknoutcome,
s.submission->> 'radio2' as shiftworkrecall
--null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where  s.templateid in ('63fcd491025d4c1039c2d767', '632c29f89418a613f55de592')
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall,
case when s.submission ->> 'fit'='yes' then 'Fit'
when s.submission ->> 'referToMedicalAdvisor'='yes' then 'Refer To Medical Advisor' end as skinoutcome,
s.submission ->> 'reviewPeriod' as skinrecall, 
--null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where  s.templateid = '63fcb185025d4c1039c2d733' -- need add 616822152d429b43a95519a6
union
select s.appointmentid, s.templateid,
case when s.templateid in ('62bc53159418a613f55dc0c8',
'62cfe4fc9418a613f55dc633',
'616822152d429b43a95519a6'
) then 'No Extractable Data' end as audiooutcome, 
null as audiorecall, null as audiostatus, 
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('62bc53159418a613f55dc0c8',
'62cfe4fc9418a613f55dc633',
'616822152d429b43a95519a6'
)) hs1)
select bphs.id, "start", --bpappointment.patientname, bpappointment.patientid,
bpappointment.gender, bpappointment.occupation, bpappointment.department, bpappointment.division,
--bpappointment.dob,
bpappointment.agegroup,
bpappointment.employer, 
bpappointment.sitename, bpappointment.appointmenttypename, bpappointment.status, bphs.formname, bphs."type",
STRING_AGG(distinct bpappointment.medical, ', ') as medical,
STRING_AGG(distinct hs.audiooutcome, ', ') as audiooutcome, 
STRING_AGG(distinct hs.audiorecall, ', ') as audiorecall,
STRING_AGG(distinct hs.audiostatus, ', ') as audiostatus,
STRING_AGG(distinct hs.havssymptoms, ', ') as havssymptoms, 
STRING_AGG(distinct hs.havsoutcome, ', ') as havsoutcome, 
STRING_AGG(distinct hs.havsrecall, ', ') as havsrecall,  
STRING_AGG(distinct hs.respiratoryoutcome, ', ') as respiratoryoutcome, 
STRING_AGG(distinct hs.respiratoryrecall, ', ') as respiratoryrecall, 
STRING_AGG(distinct hs.skinoutcome, ', ') as skinoutcome, 
STRING_AGG(distinct hs.skinrecall, ', ') as skinrecall, 
STRING_AGG(distinct hs.shiftworknoutcome, ', ') as shiftworknoutcome, 
STRING_AGG(distinct hs.shiftworkrecall, ', ') as shiftworkrecall
from bphs
left join bpappointment on bpappointment.id = bphs.id
left join hs on hs.appointmentid = bphs.id
group by bphs.id, "start", --bpappointment.patientname, bpappointment.patientid,
bpappointment.gender, bpappointment.occupation, bpappointment.department, bpappointment.division,
--bpappointment.dob,
bpappointment.agegroup,
bpappointment.employer, 
bpappointment.sitename, bpappointment.appointmenttypename, bpappointment.status, bphs.formname, bphs."type"
--) bp;
;

rollback;
-- BP health surveillance, submitted or not, if submitted, if there is data
--select count(distinct bp.id)
--from (
with bphs as(
select a1.id, 
STRING_AGG(formname, ', ') as formname,
STRING_AGG("type", ', ') as "type",
STRING_AGG(havedata, ', ') as havedata2
from (
select p1.id as packageid, p1."name" as packagename, f1."name" as formname, f1.typecode as "type", 
case when f1.templateid in (
'62bc53159418a613f55dc0c8',
'62cfe4fc9418a613f55dc633',
'616822152d429b43a95519a6') then 'No Extractable Data' end as havedata
from tpackage p1
left join tpackageform pf on pf.packageid = p1.id 
left join tform f1 on f1.id = pf.formid 
where f1.templateid in ('62a2fe049418a613f55db993', --id from wood data
'615c01412d429b43a9551651',
'62ac8cdc9418a613f55dbcb0',
'62bc53159418a613f55dc0c8',
'6311ea689418a613f55ddd0a',
'62cfe4fc9418a613f55dc633',
'64f73348025d4c1039c34637',
'64f87e3b025d4c1039c347a6',
'62bc2bcc9418a613f55dc0aa',
'616822152d429b43a95519a6',
'632c29f89418a613f55de592',
'63fcd491025d4c1039c2d767',
'64f88122025d4c1039c347be',
'63d8de5b025d4c1039c2c5c4',
'63d78ff0025d4c1039c2c4be',
'63fcb185025d4c1039c2d733'
/*'625940139418a613f55daac2', --questionaire
'63fc9f08025d4c1039c2d714', --questionaire
'63fcbffe025d4c1039c2d743', --questionaire
'64f87303025d4c1039c34779', --questionaire
'65043970025d4c1039c3503d' --questionaire*/
)) sd
LEFT join tappointmentpackage a2 on a2.packageid = sd.packageid
left join tappointment a1 on a1.id = a2.appointmentid
LEFT join tclient c1 on a1.bookingorganisationid = c1.id
LEFT join tclinic c2 on a1.clinicid = c2.id
where --a1.healthsurveillance  = '1' and 
a1.organisationid = '17b4b75b-5c32-4cf7-9d46-5149db2b215f' and a1."date" >= '2023-10-01'
and c1.clientname like '%BP%'
group by a1.id
),
bpappointment as (select DISTINCT p1."name" as medical, a1.id, a1."date" as "start", 
CONCAT_WS(' ', p2.firstname, p2.middlename, p2.surname) as patientname, p2.id as patientid,
p2.gender, a1.jobtittle as occupation, p2.department, p2.division,
p2.dob,
CASE
WHEN Date_part('year', Age(a1."date", p2.dob)) < 25 THEN '<25'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 25
AND Date_part('year', Age(a1."date", p2.dob)) < 35 THEN '25-34'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 35
AND Date_part('year', Age(a1."date", p2.dob)) < 45 THEN '35-44'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 45
AND Date_part('year', Age(a1."date", p2.dob)) < 55 THEN '45-54'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 55
AND Date_part('year', Age(a1."date", p2.dob)) < 65 THEN '55-64'
WHEN Date_part('year', Age(a1."date", p2.dob)) >= 65 THEN '>=65'
END AS agegroup,
c1.clientname as employer, 
c2.clinicname as sitename, c2.clinictype as appointmenttypename, a4.appointmentstatus as status, f1."name" as formname
from tappointment a1
LEFT join tpatient p2 on a1.patientid = p2.id
LEFT join tclient c1 on a1.bookingorganisationid = c1.id
LEFT join tclinic c2 on a1.clinicid = c2.id
LEFT join tappointmentpackage a2 on a1.id = a2.appointmentid
LEFT join tpackage p1 on a2.packageid = p1.id
left join tappointmenttime a4 on a1.id = a4.appointmentid
left join tsubmittedform s on a1.id = s.appointmentid
left join tform f1 on s.templateid = f1.templateid 
where --a1.healthsurveillance  = '0' and 
a1.organisationid = '17b4b75b-5c32-4cf7-9d46-5149db2b215f' and a1."date" >= '2023-10-01'
and c1.clientname like '%BP%'
),
hs as(
select hs1.appointmentid,
hs1.audiooutcome, hs1.audiorecall, hs1.audiostatus, 
hs1.havssymptoms, hs1.havsoutcome, hs1.havsrecall,  
hs1.respiratoryoutcome, hs1.respiratoryrecall, 
hs1.skinoutcome, hs1.skinrecall, 
hs1.shiftworknoutcome, hs1.shiftworkrecall,
case when hs1.audiooutcome = 'No Extractable Data' then 'No Extractable Data'
when hs1.audiooutcome is null
and hs1.audiorecall is null
and hs1.audiostatus is null
and hs1.havssymptoms is null
and hs1.havsoutcome is null
and hs1.havsrecall is null
and hs1.respiratoryoutcome is null
and hs1.respiratoryrecall is null
and hs1.skinoutcome is null
and hs1.skinrecall is null
and hs1.shiftworknoutcome is null
and hs1.shiftworkrecall is null then 'No'
else 'Yes' end as havedata
from (
select s.appointmentid, s.templateid,
case when s.submission ->>'referredToOhpHealthSurveillanceOnly'='true' then 'Referred To OHP (HealthSurveillanceOnly)' end as audiooutcome,
case when s.submission->>'Month'='true' then '1 month'
when s.submission->>'month3'='true' then '3 months'
when s.submission->>'Months'='true' then '6 months'
when s.submission->>'Year'='true' then '1 year'
when s.submission->>'Years'='true' then '2 years'
when s.submission->>'year'='true' then '3 years or Next medical' end as audiorecall,
case when s.submission->> 'noPreviousRecordAvailab'='true' then 'Baseline'
when s.submission->> 'noChange'='true' then 'Unchanged'
when s.submission->> 'improvement'='true' then 'Improved'
when s.submission->> 'deteioration'='true' then 'Deteriorated' end as audiostatus,
--null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid = '62a2fe049418a613f55db993'
union
select s.appointmentid, s.templateid,
case when s.submission -> 'selectBoxes' ->> 'acceptableHearingCategory1'='true' then 'Acceptable Hearing Category1'
when s.submission -> 'selectBoxes' ->> 'mildHearingImpairmentCategory2'='true' then 'Mild Hearing Impairment Category2'
when s.submission -> 'selectBoxes' ->> 'poorHearingCategory3'='true' then 'Poor Hearing Category3'
when s.submission -> 'selectBoxes' ->> 'rapidHearingLossCategory4'='true' then 'Rapid Hearing Loss Category4'
when s.submission -> 'selectBoxes' ->> 'unilateralHearingLoss'='true' then 'Unilateral Hearing Loss' end as audiooutcome, 
case WHEN s.submission -> 'selectBoxes3' ->> '1Month' IS NOT NULL THEN '1 month'
when s.submission -> 'selectBoxes3' ->> '3Months' IS NOT NULL then '3 months'
when s.submission -> 'selectBoxes3' ->> '6Months' IS NOT NULL then '6 months'
when s.submission -> 'selectBoxes4' ->> '1Year' IS NOT NULL then '1 year'
when s.submission -> 'selectBoxes4' ->> '2Years' IS NOT NULL then '2 years'
when s.submission -> 'selectBoxes4' ->> '3YearsOrNextMedical' IS NOT NULL then '3 years or Next medical' end as audiorecall,
--null as audiooutcome, null as audiorecall, 
null as audiostatus, 
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('615c01412d429b43a9551651', '62ac8cdc9418a613f55dbcb0')
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
CASE
      WHEN s.submission ->> 'noSymptomsReported' = 'yes' THEN 'No Symptoms Reported'
      WHEN s.submission ->> 'noSymptomsReported' = 'no' THEN 'Symptoms Reported'
      WHEN s.submission ->> 'symptomsDeclaredWhichMayIndicateHavsRelatedSyndrome' = 'yes' THEN 'Symptoms Declared Which May Indicate Havs Related Syndrome'
      ELSE NULL END AS havssymptoms,
case when s.templateid = '6311ea689418a613f55ddd0a' then 'Not Fit' 
when s.submission ->> 'tier3FaceToFaceReviewIn12MonthsSoonerIfIndicationOfProgressionOfSymptoms' = 'true' then 'Tier 3 Face To Face Review In 12 Months, Sooner If Indication Of Progression Of Symptoms'
when s.submission ->> 'tier4FaceToFaceReviewWithAPhysician' = 'true' then 'Tier 4 Face To Face Review With A Physician'
when s.submission ->> 'other' = 'true' then 'Other'
WHEN s.submission ->> 'symptomsDeclaredWhichMayIndicateHavsRelatedSyndrome' = 'yes' THEN 'Symptoms Declared Which May Indicate Havs Related Syndrome'
end as havsoutcome, 
CASE
     when s.submission->>'Month'='true' then '3 months'
	 when s.submission->>'Months'='true' then '6 months'
	 when s.submission->>'Year'='true' then '1 year'
	 WHEN s.submission ->> 'recall' = '3Months' then'3 months'
	 WHEN s.submission ->> 'recall' = '6Months' then'6 months'
     WHEN s.submission ->> 'recall' = '1Year' then'1 year' ELSE NULL end as havsrecall,
--null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('6311ea689418a613f55ddd0a', '64f73348025d4c1039c34637', '62bc2bcc9418a613f55dc0aa', '64f87e3b025d4c1039c347a6') 
--need get more data after form redesign, including 62bc53159418a613f55dc0c8 and 62cfe4fc9418a613f55dc633
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall, 
case when s.submission->> 'result' = 'satisfactory' then 'Satisfactory'
when s.submission->>'result' = 'referToOccupationalHealthPhysician' then 'Refer To Occupational Health Physician'
when s.submission->> 'fit2' = 'yes' then 'Fit'
when s.submission->> 'referToMedicalAdvisor2' = 'yes' then 'Refer To Medical Advisor'
when s.submission->> 'result' = 'unsatisfactory' then 'Unsatisfactory'
else null end as respiratoryoutcome,
CASE
    WHEN s.submission->> 'reviewRequired' IS NOT NULL THEN s.submission->> 'reviewRequired'
    ELSE s.submission->> 'reviewPeriod'
END as respiratoryrecall,
--null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('64f88122025d4c1039c347be',
'63d8de5b025d4c1039c2c5c4',
'63d78ff0025d4c1039c2c4be')
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall, 
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
case when s.submission->> 'suitableToContinueNightWorking' = 'yes' then 'Suitable To Continue Night Working'
when s.submission->>'requiresOhaTelephoneReview' = 'yes' then 'Requires OHA Telephone Review'
when s.submission->>'requiresOhaNightWorkerHealthAssessment' = 'yes' then 'Requires OHA Night Worker Health Assessment' 
when s.submission ->> 'requiresOhpReferral'='yes' then 'Requires OHA Referral'
when s.submission->> 'fitForNightWork'='true' then 'Fit For Night Work'
when s.submission->> 'fitForNightWorkWithTheFollowingAdjustmentsRecommendations'='true' then 'Fit For Night Work With The Following Adjustments Recommendations'
when s.submission->> 'furtherMedicalInformationIsRequiredBeforeARecommendationCanBeMade'='true' then 'Further Medical Information Is Required Before A Recommendation Can Be Made'
when s.submission->> 'thereIsNoBarrierSpecificallyForNightWorkHoweverAnotherIssueInRelationToGeneralFitnessForWorkHasBeenHighlighted'='true' then 'There Is No Barrier Specifically For Night Work However Another Issue In Relation To General Fitness For Work Has Been Highlighted'
else null end as shiftworknoutcome,
s.submission->> 'radio2' as shiftworkrecall
--null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where  s.templateid in ('63fcd491025d4c1039c2d767', '632c29f89418a613f55de592')
union
select s.appointmentid, s.templateid,
null as audiooutcome, null as audiorecall, null as audiostatus,
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall,
case when s.submission ->> 'fit'='yes' then 'Fit'
when s.submission ->> 'referToMedicalAdvisor'='yes' then 'Refer To Medical Advisor' end as skinoutcome,
s.submission ->> 'reviewPeriod' as skinrecall, 
--null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where  s.templateid = '63fcb185025d4c1039c2d733' -- need add 616822152d429b43a95519a6
union
select s.appointmentid, s.templateid,
case when s.templateid in ('62bc53159418a613f55dc0c8',
'62cfe4fc9418a613f55dc633',
'616822152d429b43a95519a6'
) then 'No Extractable Data' end as audiooutcome, 
null as audiorecall, null as audiostatus, 
null as havssymptoms, null as havsoutcome, null as havsrecall,  
null as respiratoryoutcome, null as respiratoryrecall, 
null as skinoutcome, null as skinrecall, 
null as shiftworknoutcome, null as shiftworkrecall
from tsubmittedform s
where s.templateid in ('62bc53159418a613f55dc0c8',
'62cfe4fc9418a613f55dc633',
'616822152d429b43a95519a6'
)) hs1
)
select bphs.id, "start", bpappointment.patientname, bpappointment.patientid,
bpappointment.gender, bpappointment.occupation, bpappointment.department, bpappointment.division,
bpappointment.dob,
bpappointment.agegroup,
bpappointment.employer, 
bpappointment.sitename, bpappointment.appointmenttypename, bpappointment.status, bphs.formname, bphs."type",
STRING_AGG(bphs.havedata2, ', ') as havedata2,
STRING_AGG(case when hs.havedata = 'No Extractable Data' then 'No Extractable Data'
when hs.havedata = 'Yes' then 'Yes'
when hs.havedata = 'No' then 'No'
else 'No Submission' end, ', ') as havedata,
--STRING_AGG(bpappointment.medical, ', ') as medical,
STRING_AGG(hs.audiooutcome, ', ') as audiooutcome, 
STRING_AGG(hs.audiorecall, ', ') as audiorecall,
STRING_AGG(hs.audiostatus, ', ') as audiostatus, 
STRING_AGG(hs.havssymptoms, ', ') as havssymptoms, 
STRING_AGG(hs.havsoutcome, ', ') as havsoutcome, 
STRING_AGG(hs.havsrecall, ', ') as havsrecall,  
STRING_AGG(hs.respiratoryoutcome, ', ') as respiratoryoutcome, 
STRING_AGG(hs.respiratoryrecall, ', ') as respiratoryrecall, 
STRING_AGG(hs.skinoutcome, ', ') as skinoutcome, 
STRING_AGG(hs.skinrecall, ', ') as skinrecall, 
STRING_AGG(hs.shiftworknoutcome, ', ') as shiftworknoutcome, 
STRING_AGG(hs.shiftworkrecall, ', ') as shiftworkrecall
from bphs
left join bpappointment on bpappointment.id = bphs.id
left join hs on hs.appointmentid = bphs.id
group by bphs.id, "start", bpappointment.patientname, bpappointment.patientid,
bpappointment.gender, bpappointment.occupation, bpappointment.department, bpappointment.division,
bpappointment.dob,
bpappointment.agegroup,
bpappointment.employer, 
bpappointment.sitename, bpappointment.appointmenttypename, bpappointment.status, bphs.formname, bphs."type"
--) bp;
;

rollback;