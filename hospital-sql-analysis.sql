use project;
select * from patients limit 10;
select * from services_weekly limit 10;
select * from staff limit 10;
select * from staff_schedule limit 10;

select count(*) from patients;

select distinct(service) from patients;

select avg(age) as avg_age from patients;

select * from patients
where
departure_date < arrival_date;

select name, age from patients where age = 0;

select name,age,
case
when age <= 0 then "new born"
when age <= 18 then "child"
when age >= 18 then "adult"
when age >= 65 then "mid age"
else
"aged"
end as age_group from patients;

select patient_id,count(*) as cnt 
from patients group by patient_id having cnt < 1;

select satisfaction from patients where satisfaction is null;
select * from patients where name is null,
patient_id is null,
name is null,
service is null;

select service,count(patient_id) as patient_id from patients
group by service ;


/Average satisfaction per service
select service,avg(satisfaction) as avg_sat from patients
group by service;

/Longest stay patient
select patient_id,name,datediff(departure_date,arrival_date)as long_stay from patients
order by long_stay desc limit 1;

/Total requests per service
select service,sum(patients_request) as total_req from services_weekly
group by service order by total_req desc;

/Admission rate per service
select service ,sum(patients_admitted)/sum(patients_request) as rate from services_weekly
group by service order by rate;

/Refusal rate per service
select service,sum(patients_refused)/sum(patients_request) as reful_rate from services_weekly
group by service order by reful_rate;

/Staff count per service
select service,count(distinct staff_id) as totl_staff from staff
group by service order by totl_staff;

/Avg staff presence
select distinct staff_id,avg(present) as avg_present from staff_schedule
group by staff_id order by avg_present;

/Lowest attendance staff
select staff_id,sum(present) as lowest_present from staff_schedule
group by staff_id order by lowest_present desc limit 1;

/Busiest service each week
select week,patients_request,service,
row_number() over (partition by week
 order by patients_request) as rn from services_weekly  ;
 
 
 select * from (select week,patients_request,service,
row_number() over (partition by week
 order by patients_request) as rn from services_weekly ) as t1 where rn = 1;
 
 /Week with highest demand
 select week,sum(patients_request) as high_demand from services_weekly
 group by week order by high_demand desc limit 1;

/Staff vs satisfaction relation
SELECT 
sw.service,
AVG(ss.present) as avg_staff,
AVG(sw.patient_satisfaction) as avg_satisfaction
FROM services_weekly sw
JOIN staff_schedule ss
ON sw.week = ss.week 
AND sw.service = ss.service
GROUP BY sw.service;

/Does refusal ↑ decrease satisfaction
select service,avg(patients_refused)as avger_ref,
avg(patient_satisfaction) as avg_st
from services_weekly group by service order by avger_ref desc;

/Top 2 services per week
select service,week,patients_request,
row_number() over (partition by week order by service)as rn 
from services_weekly;

select * from (select service,week,patients_request,
row_number() over (partition by week order by patients_request desc )as rn 
from services_weekly) as t1 where rn <=2 order by week ,rn;

/Which service needs more resources
select service,sum(patients_request)-sum(patients_admitted) as demand from services_weekly 
group by service order by demand desc limit 1;

/Which service has the highest unmet demand
select service,sum(patients_request)-sum(patients_admitted) as demand from services_weekly
group by service order by demand desc limit 1;

/Which service has the highest refusal rate
select service,sum(patients_refused)/sum(patients_request) as higrefu from services_weekly
group by service order by higrefu  desc limit 1;

//Which week had the highest patient demand overall
select week,service,sum(patients_request)as demand,
row_number() over (partition by week order by sum(patients_request) desc ) as rn 
from services_weekly group by week,service;

select * from 
(select week,service,sum(patients_request)as demand,
row_number() over (partition by week order by sum(patients_request) desc )
 as rn 
from services_weekly group by week,service) as t1 where rn = 1 order by week ;

/Which service has the lowest satisfaction score
select service,avg(patient_satisfaction) as satisfaction from services_weekly 
group by service order by satisfaction asc limit 1;

select  service,avg(present) as avilability from services_weekly 
group by service order by avilability asc;



 
 
 















