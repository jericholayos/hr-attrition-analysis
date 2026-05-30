-- those who travel frequently has a high attrition rate at 24.9% (69 out of 277)
-- travel rarely has 14.96% attrition rate (156 out of 1043)
-- and non-travel has 8% (12 out of 150)
SELECT
	business_travel,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;

-- sales rep. has the highest attrition at 39.76%
-- research director has the lowest at 2.5% (2 out of 80)
-- lab tech. (23.9%) and sales exec. (17.4%) has high attrition count despite having 
	-- less attrition rate compared to sales rep.
SELECT
	job_role,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;

-- sales department has 20.63% attrition rate (92 out of 446)
-- hr department has 19% attrition rate (12 out of 63)
-- and r&d has 13.84% attrition rate (133 out of 961)
SELECT
	department,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 4 DESC;

-- manager in sales has 17k avg income
-- sales rep has 2.6k avg income
-- and sales exec has 7k income
SELECT
	job_role,
	ROUND(AVG(monthly_income), 2) AS avg_income
FROM hr_attrition
WHERE department = 'Sales'
GROUP BY 1;