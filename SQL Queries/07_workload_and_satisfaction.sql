SET search_path TO public;


-- Level 1 has the highest attrition rate in Job Satisfaction Level at 22%, 
-- and as Satisfaction Level increases, attrition rate decreases.
-- Job Satisfaction Level 1 should be prioritized, as it's a significant driver for attrition
SELECT
	job_satisfaction,
	COUNT(*) AS employee_count,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1;

-- Level 1 Environment Satisfaction has the highest attrition rate at 25%
-- same as Satisfaction Level, as the Level increases, the attrition rate also decreases.
-- This shows that Environment Satisfaction is important for Employee Retention
SELECT
	environment_satisfaction,
	COUNT(*) AS employee_count,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1;



-- Level 1 has 31.25% as the highest attrition rate, 25 out of 80 but low sample size
-- work life balance is still a driver for attrition, especially levels 1-3 
-- but even having level 4 work life balance isn't enough for employees leaving.
SELECT
	work_life_balance,
	COUNT(*) AS employee_count,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1;


-- Overtime is a significant driver for attrition at 30.53%, 127 out of 416
-- compared to those who didn't, only at 10.4%, 110 out of 1054
SELECT
	overtime,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1;


-- Those who are highly involved, are less likely to leave at 9%
-- and those who aren't highly involved like Level 1 at 33% and 2 at 18%, are more likely to leave
-- and Level 3 has 14.4% attrition rate.
-- This also shows that Job Involvement is also an effective retention tool.
SELECT
	job_involvement,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 1;
















