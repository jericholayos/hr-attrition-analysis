SET search_path TO public;


SELECT *
FROM hr_attrition;

-- null checking
SELECT 
	COUNT(*) AS total_rows,
	COUNT(attrition)
FROM hr_attrition;

-- identifying which columns need to be excluded
-- these 3 have all one values
SELECT 
	COUNT(DISTINCT over18),
	COUNT(DISTINCT standardhours),
	COUNT(DISTINCT employeecount)
FROM hr_attrition;


-- counting all employees on what they achieved
SELECT 
	CASE
		WHEN education = 1 THEN 'Below College'
		WHEN education = 2 THEN 'College'
		WHEN education = 3 THEN 'Bachelor'
		WHEN education = 4 THEN 'Master'
		WHEN education = 5 THEN 'Doctor'
	END AS education_label,
	COUNT(*) AS total
FROM hr_attrition
GROUP BY 1;


------------------
/* EDA */
------------------
-- total employees is 1470
-- employees who left is 237
-- attrition rate is 16.12%
SELECT
	COUNT(*) AS total_employees,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM hr_attrition;


-- research & dev dept. has 961 employees
-- sales dept. has 446 employees
-- human resources has 63 employees
SELECT 
	department,
	COUNT(*) AS total_employees
FROM hr_attrition
GROUP BY 1
ORDER BY 2 DESC;

-- sales executive has the highest total at 326 total employees or 22.18% in percentage
-- lowest is human resources with 3.54% or 52 total employees
SELECT 
	COUNT(*) AS total_count,
	jobrole,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM hr_attrition
GROUP BY 2
ORDER BY 3 DESC;


-- min salary is $1,009
-- max salary is $19,999
-- average salary is $6,502
-- and the median is $4919
SELECT 
	MIN(monthlyincome) AS min_income,
	MAX(monthlyincome) AS max_income,
	ROUND(AVG(monthlyincome),2) AS avg_income,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY monthlyincome) AS median_income
FROM hr_attrition;


-- 30–39: 622 employees (42.31%) – largest group
-- 40–49: 349 employees (23.74%)
-- Under 30: 326 employees (22.18%)
-- 50+: 173 employees (11.77%) – smallest group

SELECT 
	CASE
		WHEN age < 30 THEN 'Under 30'
		WHEN age < 40 THEN '30-39'
		WHEN age < 50 THEN '40-49'
		ELSE '50+'
	END AS age_bands,
	COUNT(*) AS head_count,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM hr_attrition
GROUP BY 1
ORDER BY 3 DESC;


-- 416 (28.30%) of all employees work overtime
-- 1054 (71.70%) of all employees didn't do overtimes
SELECT 
	overtime,
	COUNT(*) AS total_employees,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM hr_attrition
GROUP BY 1;


-- job level 5 has the highest average ($19,191.83)
-- job level 1 has the lowest average ($2786.92)
SELECT
	joblevel,
	ROUND(AVG(monthlyincome), 2) AS avg_income
FROM hr_attrition
GROUP BY 1
ORDER BY 1;

------------------------------
/* DEEP ATTRITION ANALYSIS */
-- yes attrition means they left -- 
-- no attrition means they stayed -- 
-----------------------------

-- sales has the highest attrition rate with 20.63% (92 employees left) with 446 total employees
-- r&d has the lowest with 13.84% (133 employees) with 961 total employees
-- HR has 19.05% attrition rate (12 employees) with 63 total employees
-- even though r&d has high count of attrition, its percentage is lower because it has a larger department
WITH CTE AS (
SELECT 
	department,
	COUNT(*) AS total_headcount,
	SUM(
		CASE
			WHEN attrition = 'Yes' THEN 1
			ELSE 0
		END) AS employee_left
FROM hr_attrition
GROUP BY 1
)
SELECT 
	department,
	total_headcount,
	employee_left,
	ROUND(employee_left * 100.0 / total_headcount, 2) AS attrition_rate
FROM cte
ORDER BY 4 DESC;


-- Sales Rep highest attrition (39.76%, 33/83)
-- Research Director lowest (2.50%, 2/80)
-- Sales Exec. has most employees (326) with 17.48% attrition
WITH CTE AS (
SELECT 
	jobrole,
	COUNT(*) AS total_headcount,
	SUM(
		CASE
			WHEN attrition = 'Yes' THEN 1
			ELSE 0
		END) AS employee_left
FROM hr_attrition
GROUP BY 1
)
SELECT 
	jobrole,
	total_headcount,
	employee_left,
	ROUND(employee_left * 100.0 / total_headcount, 2) AS attrition_rate
FROM cte
ORDER BY 4 DESC;


-- employees who work overtime show significantly higher attrition rates

-- 30.5% (127 out of 416) of employees who work overtime left the company,
-- compared to only 10.4% (110 out of 1,054) of employees who do not work overtime

-- This suggests that overtime is strongly associated with higher attrition
-- and is one of the major indicators of employee turnover.
SELECT 
	overtime,
	COUNT(*) AS total_headcount,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
	ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS attrition_rate_pct
FROM hr_attrition
GROUP BY 1
ORDER BY 3 DESC;


-- the difference in attrition rate by gender is small
-- only 2.2% is the difference
-- male has  17% attrition rate and female has 14.8%
-- this means that gender is not a strong standalone driver of attrition
SELECT 
	gender,
	COUNT(*) AS total_headcount,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 1) AS attrition_rate_pct
FROM hr_attrition
GROUP BY 1;


-- single employees attrition rate is high 25.5% out of 470
-- married has 12.5% out of 673
-- divorced has 10.1% out of 327
-- this suggests that single individuals are more likely to leave
-- making marital status a moderate indicator of employee attrition
SELECT 
	maritalstatus,
	COUNT(*) AS total_headcount,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)) * 100.0 / COUNT(*), 1) AS attrition_rate_pct
FROM hr_attrition
GROUP BY 1;



-- employees who stay earn more
-- sales has small difference ($1323)
-- r&d has big difference ($2522)
-- HR has very big difference ($3630)
WITH emp_yes AS (
SELECT 
	department,
	ROUND(AVG(monthlyincome), 2) AS avg_income_leavers
FROM hr_attrition
WHERE attrition = 'Yes'
GROUP BY 1
),
emp_no AS (
SELECT 
	department,
	ROUND(AVG(monthlyincome), 2) AS avg_income_stay
FROM hr_attrition
WHERE attrition = 'No'
GROUP BY 1
)
SELECT
	emp_no.department,
	avg_income_stay,
	avg_income_leavers,
	avg_income_stay - avg_income_leavers AS income_gap
FROM emp_no 
INNER JOIN emp_yes
	ON emp_no.department = emp_yes.department
ORDER BY 2 DESC;



-- employees with 4-6 years since last promotion are the most
-- likely to stay

-- employees who were promoted a year ago or 2-3 years ago are more likely to leave
-- employees who have not been promoted for a long time leave more often

-- this suggests that early career employees and long serving employees
-- may affect employee retention
SELECT 	
	CASE
		WHEN yearssincelastpromotion <= 1 THEN '0-1 years'
		WHEN yearssincelastpromotion < 4 THEN '2-3 years'
		WHEN yearssincelastpromotion < 7 THEN '4-6 years'
		ELSE '7+ years'
	END AS buckets,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 1) AS attrition_pct
FROM hr_attrition
GROUP BY 1;



-- employees with low salary hikes show the highest attrition (19.5%)
-- medium and high hike groups have lower and similar attrition (15–16%)
-- this suggests that lower salary growth may be associated with higher attrition rate
-- however, this does not prove salary hike is the direct cause of attrition

SELECT
	CASE
		WHEN percentsalaryhike < 12 THEN 'Low(<12%)'
		WHEN percentsalaryhike < 20 THEN 'Medium(13-19%)'
		ELSE 'High(>20%)'
	END AS salary_hike_bucket,
	COUNT(*) AS total_headcount,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 1) AS attrition_pct
FROM hr_attrition
GROUP BY 1
ORDER BY 3;



-- employees who left tend to have lower satisfaction scores, 
-- but the gap is small, so satisfaction may contribute to attrition
-- but is likely not the main reason employees leave.
-- we could do a survey those who rated 1 and try to improve their satisfaction to lessen it
SELECT 
    attrition,
    COUNT(*) AS total_employees,
    ROUND(AVG(jobsatisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(environmentsatisfaction), 2) AS avg_environment_satisfaction,
    ROUND(AVG(worklifebalance), 2) AS avg_work_life_balance,
    ROUND(AVG(relationshipsatisfaction), 2) AS avg_relationship_satisfaction
FROM hr_attrition	
GROUP BY attrition
ORDER BY attrition;



-- those who rated 1 tend to leave more at 22% out of 289
-- employees with ratings of 2 and 3 have similar attrition rates at around 16.5%.
-- employees who rated 4 only has the lowest attrition rate at 11%

-- this suggests that employees are more likely to leave when they rated 1
-- and less likely when they rated 4

-- we could contact or do a survey to those who rated 1 to lessen employee attrition
SELECT
	jobsatisfaction,
	COUNT(*) AS total_headcount,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_headcount,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS attrition_rate_pct
FROM hr_attrition
GROUP BY 1
ORDER BY 1;



/*
Work-life balance appears most for employees with very low satisfaction (rating 1), 
but since the majority of employees are in rating 3 with lower attrition, 
it may not be the strongest overall driver of attrition across the company.
*/
SELECT 
	worklifebalance,
	COUNT(*) AS total_headcount,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS attrition_pct
FROM hr_attrition
GROUP BY 1
ORDER BY 1;




-- sales rep. has the highest attrition rate at 39.76%
-- second is laboratory technician at 23.94%
-- lowest is research director at 2.50%
WITH CTE AS (
SELECT 
	jobrole,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS attrition_rate
FROM hr_attrition
GROUP BY 1
)
SELECT
	jobrole,
	attrition_rate,
	RANK() OVER(ORDER BY attrition_rate DESC) AS rnk
FROM cte;



-- sales rep. has the highest attrition rate at 39.76% out of 83
-- laboratory technician has 23.94% attrition rate out of 259
-- and lastly, HR has 23.08% attrition rate of 52
WITH CTE AS (
SELECT
	jobrole,
	department,
	COUNT(*) AS total_headcount,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS attrition_rate 
FROM hr_attrition
GROUP BY 1, 2
),
CTE2 AS (
SELECT
	jobrole,
	department,
	total_headcount,
	attrition_rate,
	RANK() OVER(PARTITION BY department ORDER BY attrition_rate DESC) AS rnk
FROM cte
)
SELECT *
FROM cte2
WHERE rnk = 1
ORDER BY 4 DESC;



-- attrition is highest in the first 0-5 years of tenure
-- after year 5, attrition decreases and remains stable at low levels
-- this shows that early tenure is the most critical period of attrition
WITH CTE AS (
SELECT
	yearsatcompany,
	SUM(CASE WHEN attrition = 'Yes' THEN 1 END) AS leavers
FROM hr_attrition
GROUP BY 1
)
SELECT
	yearsatcompany,
	leavers,
	SUM(leavers) OVER(ORDER BY yearsatcompany ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM cte;




-- levels 1-3 satisfaction with overtime have the highest attrition rate
-- ranging from 33% to 38%, showing a high risk of attrition
-- even employees with the highest satisfaction level (4) still have higher attrition rate when working overtime

-- employees who don't do overtime have lower attrition rate across all levels of satisfaction,
-- ranging from 7% to 18%

-- this likely suggests that overtime is a huge driver for employee attrition
-- compared to those who doesn't do overtime
SELECT 
	overtime,
	CASE jobsatisfaction
		WHEN 1 THEN '1-Low'
		WHEN 2 THEN '2-Medium'
		WHEN 3 THEN '3-High'
		WHEN 4 THEN '4-Very High'
	END AS satisfaction,
	COUNT(*) AS total_headcount,
	ROUND((100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)) / COUNT(*), 1) AS attrition_rate
FROM hr_attrition
GROUP BY 1, 2
ORDER BY 4 DESC;



-- avg working years for those who left is 8.2 years
-- avg years at company to those who attritioned is 5.1 years
-- and lastly, the avg years in their current role who left is 2.9 years

-- employees who left usually leave around 5 years in the company, not after very long service
-- most attrition happens early to mid tenures, especially around 5 years in the company
-- and about 3 years in their current role
SELECT 
	attrition,
	ROUND(AVG(totalworkingyears), 1) AS avg_working_years,
	ROUND(AVG(yearsatcompany), 1) AS avg_years_atcompany,
	ROUND(AVG(yearsincurrentrole), 1) AS avg_years_incurrentrole
FROM hr_attrition
WHERE attrition = 'Yes'
GROUP BY 1;




-- those who had 6+ companies has the highest attrition rate around 20.8%
-- 1-2 few companies had 17.1% attrition rate
-- 3-5 and first job has low attrition rate around 11.7% to 13.6%

-- therefore, as the number of companies worked increases, attrition rate also tends to increase

SELECT
	CASE
		WHEN numcompaniesworked = 0 THEN 'First Job'
		WHEN numcompaniesworked < 3 THEN '1-2 Few Companies'
		WHEN numcompaniesworked < 6 THEN '3-5 Moderate'
		ELSE '6+ Job Hopper'
	END AS buckets,
	COUNT(*) AS total_headcount,
	ROUND((SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 1) AS attrition_rate
FROM hr_attrition
GROUP BY 1
ORDER BY 3 DESC;




WITH CTE AS (
SELECT
	department,
	ROUND(AVG(monthlyincome), 2) AS dept_income
FROM hr_attrition d
GROUP BY 1
),
CTE2 AS (
SELECT
	r.employeenumber,
	r.jobrole,
	r.department,
	r.attrition,
	(CASE WHEN r.overtime = 'Yes' THEN 1 ELSE 0 END
	+ CASE WHEN r.jobsatisfaction <= 2 THEN 1 ELSE 0 END
	+ CASE WHEN r.worklifebalance = 1 THEN 1 ELSE 0 END 
	+ CASE WHEN r.yearssincelastpromotion >= 4 THEN 1 ELSE 0 END
	+ CASE WHEN r.monthlyincome < cte.dept_income THEN 1 ELSE 0
	END) AS risk_score
FROM hr_attrition r
INNER JOIN cte
	ON cte.department = r.department
)
SELECT
	risk_score,
	COUNT(*) AS employee_count
FROM cte2
GROUP BY 1
ORDER BY 1;






WITH CTE AS (
SELECT
	department,
	ROUND(AVG(monthlyincome), 2) AS dept_income
FROM hr_attrition d
GROUP BY 1
),
CTE2 AS (
SELECT
	r.employeenumber,
	r.jobrole,
	r.department,
	r.attrition,
	(CASE WHEN r.overtime = 'Yes' THEN 1 ELSE 0 END
	+ CASE WHEN r.jobsatisfaction <= 2 THEN 1 ELSE 0 END
	+ CASE WHEN r.worklifebalance = 1 THEN 1 ELSE 0 END 
	+ CASE WHEN r.yearssincelastpromotion >= 4 THEN 1 ELSE 0 END
	+ CASE WHEN r.monthlyincome < cte.dept_income THEN 1 ELSE 0
	END) AS risk_score
FROM hr_attrition r
INNER JOIN cte
	ON cte.department = r.department
)
SELECT
	employeenumber,
	department,
	jobrole,
	risk_score
FROM cte2
WHERE risk_score >= 4;



WITH CTE AS (
SELECT
	department,
	ROUND(AVG(monthlyincome), 2) AS dept_income
FROM hr_attrition d
GROUP BY 1
),
CTE2 AS (
SELECT
	r.employeenumber,
	r.jobrole,
	r.department,
	r.attrition,
	(CASE WHEN r.overtime = 'Yes' THEN 1 ELSE 0 END
	+ CASE WHEN r.jobsatisfaction <= 2 THEN 1 ELSE 0 END
	+ CASE WHEN r.worklifebalance = 1 THEN 1 ELSE 0 END 
	+ CASE WHEN r.yearssincelastpromotion >= 4 THEN 1 ELSE 0 END
	+ CASE WHEN r.monthlyincome < cte.dept_income THEN 1 ELSE 0
	END) AS risk_score
FROM hr_attrition r
INNER JOIN cte
	ON cte.department = r.department
)
SELECT
	attrition,
	ROUND(AVG(risk_score), 2)
FROM cte2
GROUP BY 1;



	






























