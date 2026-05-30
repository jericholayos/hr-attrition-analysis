set search_path to public;



-- both performance rating has an equal attrition rate
-- performance rating isn't enough to be considered as an driver for attrition
SELECT
	performance_rating,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1;


-- those who didnt do anything training has the highest attrition rate at 27%, 15 out of 54
-- those who trained 4 times has 21% attrition rate, 26 out of 123
-- those who trained 2-3 times has an attrition range of 14-17%
-- This shows that employees who attended more training are less likely to leave, 
-- but the data is inconsistent, it suggests that training alone isn't enough to make employees stay
SELECT
	training_times_last_year,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1 DESC;



-- the top 3 education field with the most attrition rate is hr technical degree and marketing.
-- this shows that those 3 are the 3 education fields that are most likely to leave 
-- which aligns with high attrition job roles such as 
-- Sales Representative, Human Resources, and Laboratory Technician
SELECT
	job_role,
	education_field,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1, 2
ORDER BY 5 DESC;



































