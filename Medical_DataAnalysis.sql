SHOW DATABASES;
USE project_medical_data_history;
-- show the whole table patients
select * from patients;

-- 1. Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name ,last_name ,gender FROM patients where gender = "M" ;

-- 2. Show first name and last name of patients who do not have allergies.
select first_name,last_name from patients where allergies is null ;

-- 3. Show first name of patients that start with the letter 'C'
select first_name from patients where first_name like 'C%' ;

-- 4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name , last_name  from patients where weight  between 100 and 120;

-- 5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
SELECT  patient_id, first_name, COALESCE(allergies, 'NKA') AS allergies FROM patients where allergies is null;

-- 6. Show first name and last name concatenated into one column to show their full name.
select concat(first_name," ",last_name) as full_name from patients;

-- 7. Show first name, last name, and the full province name of each patient.
select first_name , last_name , province_name  from patients p  left join province_names  pn on p.province_id = pn.province_id ; 

-- 8. Show how many patients have a birth_date with 2010 as the birth year.
select count(*) as patients_countin_2010 from patients where extract(year from birth_date) = 2010 ;

-- 9. Show the first_name, last_name, and height of the patient with the greatest height.
select first_name, last_name ,height from patients where height = (select max(height) from patients);

-- 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select * from patients where patient_id in (1,45,534,879,1000) ; 

-- 11. Show the total number of admissions
select count(*) as total_numberof_admissions from admissions;

select * from admissions;

-- 12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
select * from admissions where admission_date = discharge_date;

-- 13. Show the total number of admissions for patient_id 579.
select count(*) as total_noof_admissions  from admissions where patient_id = 579;

-- 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct(city) from patients where province_id ='NS'; 

-- 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name,last_name,birth_date from patients where height > 160 and weight > 70;

-- 16. Show unique birth years from patients and order them by ascending.
select distinct(extract(year from birth_date)) as birth_years  from patients order by birth_years asc ;

-- 17. Show unique first names from the patients table which only occurs once in the list.
select distinct(first_name) from patients group by first_name having count(first_name) = 1;

-- 18. Show patient_id and first_name from patients where their first_name starts and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name FROM patients WHERE first_name LIKE '%S__S%' AND LENGTH(first_name) >= 6;

-- 19. Show patient_id, first_name, last_name from patients whose diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
select p.patient_id ,first_name,last_name from patients p join admissions a on p.patient_id = a.patient_id where diagnosis = "Dementia";

-- 20. Display every patient's first_name. Order the list by the length of each name and then by alphabetically.
select first_name from patients order by length(first_name) , first_name asc ;  

-- 21. Show the total number of male patients and the total number of female patients in the patients table. Display the two results in the same row.
select sum(case when gender = 'M' then 1 else 0  end) as total_noof_malepatients , sum(case when gender = 'F' then 1 else 0  end) as total_noof_femalepatients from patients;

-- 22. Show the total number of male patients and the total number of female patients in the patients table. Display the two results in the same row.
-- same as the above one 

-- 23. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id ,diagnosis from admissions group by diagnosis ,patient_id  having COUNT(patient_id) > 1;

-- 24. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select city ,count(patient_id) as total_number  from patients group by city order by total_number desc , city asc ;

-- 25. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
select first_name , last_name ,'patient' as role  from patients
union 
select first_name , last_name , 'doctor' as role from doctors;

-- 26. Show all allergies ordered by popularity. Remove NULL values from the query.
-- option 1 with tan as (select allergies , count(allergies) as cnt from  patients where allergies is not NULL group by allergies) select allergies from tan order by cnt desc; 
select allergies  from (select allergies , count(allergies) as cnt from patients where allergies is not null group by allergies  order by cnt  desc) as al;

-- 27. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name,last_name,birth_date from patients where extract(year from birth_date) = 1970 order by birth_date asc;

-- 28. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the
-- list by the first_name in descending order EX: SMITH,jane
select concat(upper(last_name) , ',', lower(first_name)) as name from patients order by first_name desc;

-- 29. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select p.province_id as pateints_provinceid , pn.province_id ,sum(height) as height_customers from patients p join province_names pn on p.province_id = pn.province_id group by p.province_id having sum(height) >= 7000;

-- 30. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight) as largest_weight, min(weight) as smallest_weight from patients where last_name = 'Maroni';

-- 31. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least
-- admissions.
select extract(day from admission_date) as day ,count(admission_date) as no_of_admissions from admissions group by day order by no_of_admissions asc;

-- 32. Show all of the patients grouped into weight groups. Show the total number of patients in each weight group. 
-- Order the list by the weight group descending. e.g.
--  if they weigh 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
select 
case 
when weight between 0 and 50 then " under 50 weight group"
when weight between 50 and 100 then " 50-100 weight group"
when weight between 100 and 109 then"100 weight group"
when weight between 110 and 119 then "110 weight group"
else "other weight group"
end  AS weightgroup
from patients;

-- 33. Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m).
-- --  Weight is in units kg. Height is in units cm.
select patient_id,weight,height,
case 
when round(weight/height ,1) between 0 and 0.5  then  0
when round(weight/height,1) between 0.5 and 1   then  1
end as isObese
from patients ;

-- 34. Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first
-- name is 'Lisa'. Check patients, admissions, and doctors tables for required
-- information.
select p.patient_id,p.first_name,p.last_name,d.specialty from patients p join admissions a on a.patient_id = p.patient_id  join doctors d on a.attending_doctor_id = d.doctor_id where diagnosis = 'Epilepsy' and d.first_name = 'Lisa' ; 

-- 35. All patients who have gone through admissions, can see their medical
-- documents on our site. Those patients are given a temporary password after
-- their first admission. Show the patient_id and temp_password.
-- The password must be the following, in order:
-- - patient_id
-- - the numerical length of patient's last_name
-- - year of patient's birth_date
select patient_id, concat(patient_id,length(last_name),extract(year from birth_date)) as temp_password from patients ;