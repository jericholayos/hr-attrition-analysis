set search_path to public;

select *
from hr_attrition
limit 10;


-- Tenure & Experience
SELECT
	years_at_company,
	COUNT(*)
FROM hr_attrition
GROUP BY 1
ORDER BY 1;

ALTER TABLE hr_attrition
ADD COLUMN tenure_bucket VARCHAR;

UPDATE hr_attrition
SET tenure_bucket = 
	CASE
		WHEN years_at_company <= 1 THEN '0-1'
		WHEN years_at_company <= 3 THEN '2-3'
		WHEN years_at_company <= 5 THEN '4-5'
		WHEN years_at_company <= 10 THEN '6-10'
		WHEN years_at_company <= 20 THEN '11-20'
		WHEN years_at_company <= 40 THEN '21-40'
		ELSE '40+'
	END;



-- Tenure 0-1 has a high attrition rate of 34.8%, 75 out of 215
-- Tenure 2-3 is the second highest at 18.43%, 47 out of 255
-- Tenure 4-5, 6,10, and 21-40 is at 12-13% attrition rate
-- Tenure 11-20 is the lowest at 6.67%, 12 out of 180.
-- This shows that most of the attrition is happening at year 0-1 and 2-3
-- The HR should focus on finding ways how to retain employees at the 0-1 tenures
SELECT
	tenure_bucket,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;

-- The YSLP 0 has the highest attrition count of 110 out of 581
-- but YSLP 9 has the highest attrition rate at 23.53, 4 out of 17
-- This suggests that Entry Level Employees (Job Level 1), Tenure 0-1, and YSLP 0 are the most at-risk group
SELECT
	years_since_last_promotion,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 3 DESC;


-- Employees with more previous companies worked at (1, 5, 6, 7, 9) have higher attrition rates, 
-- suggesting job hopping behavior. However, the highest attrition count is at 1 previous company, 
-- likely because they are in their early careers stage
SELECT
	num_companies_worked,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;


-- Average Tenure of Leavers is 5
-- Average Tenure of Stayers is 7
-- This shows that Leavers averages 5 years at the company, 2 years less than those who Stayed.
SELECT
	attrition,
	ROUND(AVG(years_at_company), 2) AS avg_tenure
FROM hr_attrition
GROUP BY 1;


-- Employees with 0 years with current manager has an high attrition rate and should be investigated upon.
-- Also, attrition rate drops significantly after 1 year with the same manager.
SELECT
	years_with_curr_manager,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1;











