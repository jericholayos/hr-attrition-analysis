SET search_path TO public;

SELECT *
FROM hr_attrition
LIMIT 10;

-- Attrition Rate is 16.12% (237 employees)
SELECT
	attrition,
	COUNT(*) AS total_employees,
	ROUND((100.0 * COUNT(*)) / SUM(COUNT(*)) OVER(), 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1;