-- min age is 18
-- max age is 60
SELECT 
	ROUND(AVG(age), 2),
	MAX(age), 
	MIN(age)
FROM hr_attrition;

-- 18-24 Age Group has high attrition rate at 39.1% (38 out of 97 employees)
-- 25-34 Age Group has 20.22% rate (112 out of 554 employees)
SELECT 
	age_group,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;

-- high school graduates has high attrition rate at 18.24% (31 out of 170)
-- bachelors degree graduates has 17.31% attrition rate (99 out of 572)
-- associate degree and masters degree is near equal at 14.5% to 15.6% attrition rate
-- doctorate has the lowest attrition rate at 10.42% (5 out of 48)
SELECT 
	education,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;

-- high school graduates has high attrition rate at 18.24% (31 out of 170)
-- WHY? 18 left those who did overtime and 13 left those who didn't. 
-- overtime is a huge driver for attrition at 33.33%
SELECT
	overtime,
	COUNT(*) AS employee_count,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
WHERE education = 'High School'
GROUP BY 1;