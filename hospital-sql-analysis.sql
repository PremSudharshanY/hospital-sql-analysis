USE project;

SELECT * FROM patients LIMIT 10;
SELECT * FROM services_weekly LIMIT 10;
SELECT * FROM staff LIMIT 10;
SELECT * FROM staff_schedule LIMIT 10;

SELECT COUNT(*) 
FROM patients;

SELECT DISTINCT(service) 
FROM patients;

SELECT AVG(age) AS avg_age 
FROM patients;

SELECT * 
FROM patients
WHERE departure_date < arrival_date;

SELECT name, age 
FROM patients 
WHERE age = 0;

SELECT 
    name, 
    age,
    CASE
        WHEN age <= 0 THEN "new born"
        WHEN age <= 18 THEN "child"
        WHEN age >= 18 THEN "adult"
        WHEN age >= 65 THEN "mid age"
        ELSE "aged"
    END AS age_group 
FROM patients;

SELECT 
    patient_id,
    COUNT(*) AS cnt 
FROM patients 
GROUP BY patient_id 
HAVING cnt < 1;

SELECT satisfaction 
FROM patients 
WHERE satisfaction IS NULL;

SELECT * 
FROM patients 
WHERE name IS NULL,
      patient_id IS NULL,
      name IS NULL,
      service IS NULL;

SELECT 
    service,
    COUNT(patient_id) AS patient_id 
FROM patients
GROUP BY service;

/* Average satisfaction per service */
SELECT 
    service,
    AVG(satisfaction) AS avg_sat 
FROM patients
GROUP BY service;

/* Longest stay patient */
SELECT 
    patient_id,
    name,
    DATEDIFF(departure_date, arrival_date) AS long_stay 
FROM patients
ORDER BY long_stay DESC 
LIMIT 1;

/* Total requests per service */
SELECT 
    service,
    SUM(patients_request) AS total_req 
FROM services_weekly
GROUP BY service 
ORDER BY total_req DESC;

/* Admission rate per service */
SELECT 
    service,
    SUM(patients_admitted) / SUM(patients_request) AS rate 
FROM services_weekly
GROUP BY service 
ORDER BY rate;

/* Refusal rate per service */
SELECT 
    service,
    SUM(patients_refused) / SUM(patients_request) AS reful_rate 
FROM services_weekly
GROUP BY service 
ORDER BY reful_rate;

/* Staff count per service */
SELECT 
    service,
    COUNT(DISTINCT staff_id) AS totl_staff 
FROM staff
GROUP BY service 
ORDER BY totl_staff;

/* Avg staff presence */
SELECT 
    staff_id,
    AVG(present) AS avg_present 
FROM staff_schedule
GROUP BY staff_id 
ORDER BY avg_present;

/* Lowest attendance staff */
SELECT 
    staff_id,
    SUM(present) AS lowest_present 
FROM staff_schedule
GROUP BY staff_id 
ORDER BY lowest_present DESC 
LIMIT 1;

/* Busiest service each week */
SELECT 
    week,
    patients_request,
    service,
    ROW_NUMBER() OVER (
        PARTITION BY week
        ORDER BY patients_request
    ) AS rn 
FROM services_weekly;

SELECT * 
FROM (
    SELECT 
        week,
        patients_request,
        service,
        ROW_NUMBER() OVER (
            PARTITION BY week
            ORDER BY patients_request
        ) AS rn 
    FROM services_weekly
) AS t1 
WHERE rn = 1;

/* Week with highest demand */
SELECT 
    week,
    SUM(patients_request) AS high_demand 
FROM services_weekly
GROUP BY week 
ORDER BY high_demand DESC 
LIMIT 1;

/* Staff vs satisfaction relation */
SELECT 
    sw.service,
    AVG(ss.present) AS avg_staff,
    AVG(sw.patient_satisfaction) AS avg_satisfaction
FROM services_weekly sw
JOIN staff_schedule ss
    ON sw.week = ss.week 
    AND sw.service = ss.service
GROUP BY sw.service;

/* Does refusal ↑ decrease satisfaction */
SELECT 
    service,
    AVG(patients_refused) AS avger_ref,
    AVG(patient_satisfaction) AS avg_st
FROM services_weekly 
GROUP BY service 
ORDER BY avger_ref DESC;

/* Top 2 services per week */
SELECT 
    service,
    week,
    patients_request,
    ROW_NUMBER() OVER (
        PARTITION BY week 
        ORDER BY service
    ) AS rn 
FROM services_weekly;

SELECT * 
FROM (
    SELECT 
        service,
        week,
        patients_request,
        ROW_NUMBER() OVER (
            PARTITION BY week 
            ORDER BY patients_request DESC
        ) AS rn 
    FROM services_weekly
) AS t1 
WHERE rn <= 2 
ORDER BY week, rn;

/* Which service needs more resources */
SELECT 
    service,
    SUM(patients_request) - SUM(patients_admitted) AS demand 
FROM services_weekly 
GROUP BY service 
ORDER BY demand DESC 
LIMIT 1;

/* Which service has the highest unmet demand */
SELECT 
    service,
    SUM(patients_request) - SUM(patients_admitted) AS demand 
FROM services_weekly
GROUP BY service 
ORDER BY demand DESC 
LIMIT 1;

/* Which service has the highest refusal rate */
SELECT 
    service,
    SUM(patients_refused) / SUM(patients_request) AS higrefu 
FROM services_weekly
GROUP BY service 
ORDER BY higrefu DESC 
LIMIT 1;

/* Which week had the highest patient demand overall */
SELECT 
    week,
    service,
    SUM(patients_request) AS demand,
    ROW_NUMBER() OVER (
        PARTITION BY week 
        ORDER BY SUM(patients_request) DESC
    ) AS rn 
FROM services_weekly 
GROUP BY week, service;

SELECT * 
FROM (
    SELECT 
        week,
        service,
        SUM(patients_request) AS demand,
        ROW_NUMBER() OVER (
            PARTITION BY week 
            ORDER BY SUM(patients_request) DESC
        ) AS rn 
    FROM services_weekly 
    GROUP BY week, service
) AS t1 
WHERE rn = 1 
ORDER BY week;

/* Which service has the lowest satisfaction score */
SELECT 
    service,
    AVG(patient_satisfaction) AS satisfaction 
FROM services_weekly 
GROUP BY service 
ORDER BY satisfaction ASC 
LIMIT 1;

SELECT  
    service,
    AVG(present) AS avilability 
FROM services_weekly 
GROUP BY service 
ORDER BY avilability ASC;


 
 
 















