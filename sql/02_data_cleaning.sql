SET search_path TO public;

SELECT *
FROM hr_attrition
LIMIT 10;

SELECT DISTINCT education_field
FROM hr_attrition;


UPDATE hr_attrition
SET department = 
CASE
	WHEN department = 'Research & Development' THEN 'R & D'
	WHEN department = 'Human Resources' THEN 'HR'
END
WHERE department IN ('Research & Development', 'Human Resources')

UPDATE hr_attrition
SET business_travel = 
REPLACE(business_travel, '_', ' ')

UPDATE hr_attrition
SET education_field = 'Human Resources'
WHERE education_field = 'HR';


ALTER TABLE hr_attrition 
ALTER COLUMN education TYPE VARCHAR(50) USING education::varchar;

UPDATE hr_attrition
SET education = 
CASE
	WHEN education = '1' THEN 'Below College'
	WHEN education = '2' THEN 'College'
	WHEN education = '3' THEN 'Bachelor'
	WHEN education = '4' THEN 'Master'
	WHEN education = '5' THEN 'Doctor'
END
WHERE education IN ('1', '2', '3', '4', '5');


UPDATE hr_attrition
SET education = 
CASE
	WHEN education = 'Below College' THEN 'High School'
	WHEN education = 'College' THEN 'Associate Degree'
	WHEN education = 'Bachelor' THEN 'Bachelor''s Degree'
	WHEN education = 'Master' THEN 'Master''s Degree'
	WHEN education = 'Doctor' THEN 'Doctorate'
END
WHERE education IN ('Below College', 'College', 'Bachelor', 'Master', 'Doctor');


ALTER TABLE hr_attrition
ALTER COLUMN employee_number TYPE VARCHAR(50) USING employee_number::varchar;


UPDATE hr_attrition
SET employee_number = 'E-' || employee_number
WHERE employee_number NOT LIKE 'E-%';



ALTER TABLE hr_attrition
ADD COLUMN age_group VARCHAR;

UPDATE hr_attrition 
SET age_group = 
CASE
	WHEN age BETWEEN 18 AND 24 THEN '18-24'
	WHEN age BETWEEN 25 AND 34 THEN '25-34'
	WHEN age BETWEEN 35 AND 44 THEN '35-44'
	WHEN age BETWEEN 45 AND 54 THEN '45-54'
	WHEN age >= 55 THEN '55-60'
END;


















