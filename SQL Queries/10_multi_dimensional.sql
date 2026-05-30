set search_path to public;


-- overtime is a significant driver for attrition across all departments.
-- however Sales still has high attrition even without overtime,
-- likely because of low income in roles like Sales Representative in Sales Department.
SELECT
	department,
	overtime,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1, 2
ORDER BY 5 DESC;



-- This shows that Sales Rep. are the high cause of attrition across all satisfaction levels, 
-- suggesting income is a stronger driver than satisfaction for the sales rep role.
WITH CTE AS (
SELECT
	job_role,
	department,
	job_satisfaction,
	COUNT(*) AS total_employees,
	COUNT(*) FILTER(WHERE attrition = 'Yes') AS attrition_count,
	ROUND(AVG(CASE WHEN attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100.0, 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1, 2, 3
),
cte2 AS (
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY attrition_rate DESC) AS rn
FROM cte
)
SELECT
	job_role,
	job_satisfaction,
	total_employees,
	attrition_count,
	attrition_rate
FROM cte2
WHERE rn <= 5
ORDER BY 5 DESC













