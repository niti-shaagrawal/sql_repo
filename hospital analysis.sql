select * 
from `cleaned patients dataset`;
select distinct ethnicity from `cleaned patients dataset`;

-- to count the total no of patients died and the total mortality rate
select count(case when hospital_death=1 then 1 end) as total_hospital_deaths,
round(count(case when hospital_death=1 then 1 end)*100/count(*), 2) as mortlity_rate
from `cleaned patients dataset`;

-- to calculate the death couut of each ethinicity 
select ethnicity, count(case when hospital_death =1 then 1 end) as no_of_deaths
from `cleaned patients dataset`
group by ethnicity;

-- to calculate death count bby each gender
select gender,count(case when hospital_death=1 then 1 end) as no_of_deaths
from `cleaned patients dataset`
group by gender;

-- comparison of average and maximum age of poeple who died and did not die in hospital
select round(avg(age),2) as avg_age,
max(age) as max_age,
hospital_death
from `cleaned patients dataset`
where hospital_death=1
group by hospital_death
union
select round(avg(age),2) as avg_age,
max(age) as max_age,
hospital_death
from `cleaned patients dataset`
where hospital_death=0
group by hospital_death;

-- comparing the patients who died and survived by each age
select
age,
count(case when hospital_death=1 then 1 end) as no_of_deaths,
count(case when hospital_death=0 then 0 end) as no_of_survivals
from `cleaned patients dataset`
group by age
order by age;

-- patient count according to 10 year age intervals
select 
concat(floor(age/10)*10 ,'-', floor(age/10)*10+9) as age_interval,
count(case when hospital_death=1 then 1 end) as no_of_deaths,
count(*) as patient_count
from `cleaned patients dataset`
group by age_interval
order by age_interval;

-- amount of patients above 65 who died vs amount of patients between 50-65 who died
select 
count(case when age>65 and hospital_death=0 then 1 end) as survived_65,
count(case when age between 50 and 65 and hospital_death=0 then 1 end) as survived_50_65,
count(case when age>65 and hospital_death=1 then 1 end) as dead_65,
count(case when age between 50 and 65 and hospital_death=1 then 1 end) as dead_50_65
from `cleaned patients dataset`;

select max(age) from `cleaned patients dataset`;
select min(age) from `cleaned patients dataset`;

-- calculating the average probability of deaths for pople of different age-groups 
select 
case
when age<40 then 'under 40'
when age between 40 and 60 then '40-60'
when age between 60 and 80 then '60-80'
else 'above 80'
end as age_group,
round(avg(apache_4a_hospital_death_prob),3) as avg_death_prob
from `cleaned patients dataset`
group by age_group
order by age_group;

-- whcih admit source of the icu did the most patients die and get admitted to?
select 
count(*) as no_of_patients,
icu_admit_source,
count(case when hospital_death=1 then 1 end) as no_of_deaths,
count(case when hospital_death=0 then 1 end) as no_of_survived
from `cleaned patients dataset`
where icu_stay_type='admit' 
group by icu_admit_source;

-- average age of people in each type of icu and amount that died
  select 
  icu_type,
  round(avg(age),2) as avg_age,
  count(case when hospital_death=1 then 1 end) as no_of_deaths,
  count(case when hospital_death=0 then 1 end) as no_of_survived
  from `cleaned patients dataset`
  group by icu_type;
  
  -- average weight, bmi and max heartrate of people who died
  select 
  round(avg(weight),3) as avg_weight,
  round(avg(bmi),3) as avg_bmi,
  max(heart_rate_apache) as max_heartrate
  from `cleaned patients dataset`
  where hospital_death=1;
  
  -- what were the top 5 ethnicities with the highest bmi?
  select
  round(avg(bmi),2) as avg_bmi,
  ethnicity
  from `cleaned patients dataset`
  group by ethnicity
  order by avg_bmi desc
  limit 5;
  
  -- how many patients as suffereing from each commorbidty
  select
  sum(aids) as people_with_aids,
  sum(cirrhosis) as people_with_cirrosis,
  sum(diabetes_mellitus) as people_with_diabetes,
  sum(hepatic_failure) as peole_with_hp,
  sum(immunosuppression)as people_with_immunesupression,
  sum(leukemia) as people_with_leukemia,
  sum(lymphoma) as poeple_with_lymphoma,
  sum(solid_tumor_with_metastasis) as people_with_tumor
  from `cleaned patients dataset`;
  
  -- what was the percentage of poeple with each commorbidity who died?
  select
  round(sum(case when aids=1 then 1 end)*100/count(*),3) as percent_of_aids,
  round(sum(case when cirrhosis=1 then 1 end)*100/count(*),3) as percent_of_cirrhosis,
  round(sum(case when diabetes_mellitus=1 then 1 end)*100/count(*),3) as percent_of_diabetes,
  round(sum(case when hepatic_failure=1 then 1 end)*100/count(*),3) as percent_of_hp,
  round(sum(case when immunosuppression=1 then 1 end)*100/count(*),3) as percent_of_immuneosuppression,
  round(sum(case when leukemia=1 then 1 end)*100/count(*),3) as percent_of_leukemia,
  round(sum(case when lymphoma=1 then 1 end)*100/count(*),3) as percent_of_lymphomia,
  round(sum(case when solid_tumor_with_metastasis=1 then 1 end)*100/count(*),3) as percent_of_tumor
  from `cleaned patients dataset`
  where hospital_death=1;
  
  -- what is the mortality rate in percentage?
  select round(count(case when hospital_death=1 then 1 end)*100/count(*),3) as mortality_rate
  from `cleaned patients dataset`;
  
  -- what is the percentage of patients who underwent elective surgery?
  select round(count(case when elective_surgery=1 then 1 end)*100/count(*),3) as elective_ssurgery
  from `cleaned patients dataset`;
  
  -- what is the average weight and height of male and female who underwent elective surgery
  select 
  gender,
  round(avg(weight),2) as avg_weight,
  round(avg(height),2) as avg_height
  from `cleaned patients dataset`
  where elective_surgery=1
  group by gender;
  
-- what were the top 10 icus which the highest hospital death probability?
select 
round(avg(apache_4a_hospital_death_prob),3) as avg_hospital_death_prob,
icu_id
from `cleaned patients dataset`
group by icu_id
order by avg_hospital_death_prob desc
limit 10 ;

-- what was the average length of stay at each icu for patients for those who survived and those who didnt?
select 
icu_type,
round(avg(case when hospital_death=1 then pre_icu_los_days end),3) as sl_dead,
round(avg(case when hospital_death=0 then pre_icu_los_days end),3) as sl_survived
from `cleaned patients dataset`
group by icu_type
order by icu_type;

-- what was the averge bmi of patients that died based on ethnicity(excluding null)?
select 
round(avg(bmi),3) as avg_bmi,
ethnicity
from `cleaned patients dataset`
where bmi is not null
group by ethnicity;

-- what is the death percentage for each ethnicity?
select 
ethnicity,
round(count(case when hospital_death=1 then 1 end)*100/count(*),3) as precentage
from `cleaned patients dataset`
group by ethnicity;

-- how many patients are there in each bmi category based on thier bmi value?
select 
    CASE
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
count(*) as no_of_people
from `cleaned patients dataset`
group by bmi_category
order by bmi_category;

-- hospital death probabilities where the icu type is sicu and bmi is above 30
select 
patient_id,
apache_4a_hospital_death_prob as death_prob
from `cleaned patients dataset`
where icu_type='SICU'and bmi>30
order by death_prob desc