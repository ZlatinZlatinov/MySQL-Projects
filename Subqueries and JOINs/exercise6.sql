USE soft_uni; 

-- 01. Employee Address 100/100
SELECT e.employee_id,
	e.job_title, 
    e.address_id, 
    a.address_text 
FROM employees as e
	INNER JOIN addresses AS a 
    ON e.address_id = a.address_id
ORDER BY address_id
LIMIT 5; 

-- 02. Addresses with Towns 100/100
SELECT
	e.first_name, 
    e.last_name,
    t.name,
    a.address_text 
FROM employees as e
	INNER JOIN addresses AS a 
    ON e.address_id = a.address_id
    JOIN towns AS t
    ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5; 

-- 03. Sales Employee 100/100
SELECT 
	e.employee_id,
    e.first_name,
    e.last_name, 
    d.name 
FROM employees AS e 
	INNER JOIN departments AS d
    ON e.department_id = d.department_id
WHERE d.name = "Sales"
ORDER BY employee_id DESC; 

-- 04. Employee Departments 100/100
SELECT 
	e.employee_id,
    e.first_name,
    e.salary, 
    d.name 
FROM employees AS e 
	INNER JOIN departments AS d
    ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5; 

-- 05. Employees Without Project 100/100
SELECT 
	e.employee_id,
    e.first_name 
FROM employees AS e 
WHERE e.employee_id NOT IN (
	SELECT DISTINCT employee_id FROM employees_projects
) 
ORDER BY e.employee_id DESC 
LIMIT 3; 

-- 06. Employees Hired After 100/100
SELECT 
	e.first_name,
    e.last_name,
    e.hire_date,
    d.name AS dept_name 
FROM employees AS e
	INNER JOIN departments AS d
    ON d.department_id = e.department_id AND (d.name = 'Sales' OR d.name = 'Finance')
WHERE e.hire_date > '1999-1-1'  
ORDER BY e.hire_date;  

-- 07. Employees with Project 100/100 DEA I JUJETO WEEE 
SELECT 
	e.employee_id, 
    e.first_name, 
    p.name AS project_name
FROM employees AS e 
	JOIN employees_projects AS ep 
    ON e.employee_id = ep.employee_id
    JOIN projects AS p 
    ON ep.project_id = p.project_id
WHERE DATE(p.start_date) > '2002-8-13' AND p.end_date IS NULL
ORDER BY first_name, project_name
LIMIT 5;  

-- 08. Employee 24 100/100
SELECT 
	e.employee_id, 
    e.first_name, 
    IF(YEAR(p.start_date) = 2005, NULL, p.name) AS project_name
FROM employees AS e 
	JOIN employees_projects AS ep 
    ON e.employee_id = ep.employee_id
    JOIN projects AS p 
    ON ep.project_id = p.project_id
WHERE ep.employee_id = 24
ORDER BY project_name; 

-- 09. Employee Manager 100/100
SELECT 
	e.employee_id,
    e.first_name,
    e.manager_id,
    m.first_name AS manager_name
FROM employees AS e
	JOIN employees AS m
    ON e.manager_id = m.employee_id 
WHERE e.manager_id IN (3, 7) 
ORDER BY e.first_name; 

-- 10. Employee Summary 100/100
SELECT 
	e.employee_id,
    CONCAT(e.first_name, " ", e.last_name) AS employee_name,
    CONCAT(m.first_name, " ", m.last_name) AS manager_name,
    d.name AS department_name
FROM employees AS e
	JOIN employees AS m
    ON e.manager_id = m.employee_id
    JOIN departments AS d
    ON e.department_id = d.department_id
WHERE e.manager_id IS NOT NULL 
ORDER BY e.employee_id
LIMIT 5; 

-- 11. Min Average Salary 100/100
SELECT AVG(salary) AS min_average_salary
	FROM employees 
GROUP BY department_id 
ORDER BY min_average_salary
LIMIT 1; 

USE geography; 

-- 12. Highest Peaks in Bulgaria 100/100
SELECT 
	c.country_code, 
    m.mountain_range, 
    p.peak_name, 
    p.elevation
FROM countries AS c
	JOIN mountains_countries as mc
    ON c.country_code = mc.country_code AND c.country_name = 'Bulgaria'
    JOIN mountains AS m
    ON mc.mountain_id = m.id
    JOIN peaks AS p
    ON m.id = p.mountain_id AND p.elevation > 2835 
ORDER BY p.elevation DESC; 

-- 13. Count Mountain Ranges 100/100
SELECT
	c.country_code, 
    COUNT(mc.mountain_id) AS mountain_range
FROM countries AS c
	JOIN mountains_countries AS mc
	ON mc.country_code = c.country_code
WHERE c.country_name IN ('United States', 'Russia', 'Bulgaria')
GROUP BY c.country_code 
ORDER BY mountain_range DESC;

-- 14. Countries with Rivers 100/100
SELECT 
	c.country_name,
    r.river_name 
FROM continents AS cnt
	JOIN countries AS c 
    ON cnt.continent_code = c.continent_code AND cnt.continent_name = 'Africa'
    LEFT JOIN countries_rivers AS cr
    ON cr.country_code = c.country_code
    LEFT JOIN rivers AS r
    ON cr.river_id = r.id
ORDER BY c.country_name
LIMIT 5; 

-- 16. Countries without any Mountains 100/100
SELECT COUNT(country_code) AS country_count
FROM countries AS c 
WHERE c.country_code NOT IN(
SELECT DISTINCT country_code AS codes
FROM  mountains_countries); 

-- 17. Highest Peak and Longest River by Country 100/100
SELECT 
	c.country_name, 
    MAX(p.elevation) AS highest_peak_elevation, 
    MAX(r.length) AS longest_river_length
FROM countries AS c 
	JOIN mountains_countries AS mc
    ON mc.country_code = c.country_code 
    JOIN mountains as m 
    ON mc.mountain_id = m.id
    JOIN peaks AS p
    ON m.id = p.mountain_id
    -- 
    JOIN countries_rivers AS cr
    ON c.country_code = cr.country_code 
    JOIN rivers AS r 
    ON cr.river_id = r.id
GROUP BY c.country_name 
ORDER BY highest_peak_elevation DESC, longest_river_length DESC
LIMIT 5; 

-- 15.
SELECT 
	continent_code,
    currency_code,
    COUNT(country_code) AS currency_usage
FROM countries 
WHERE continent_code = 'AS'
GROUP BY currency_code 
ORDER BY currency_usage DESC
LIMIT 1;

-- 15. *Continents and Currencies 100/100
SELECT 
	c.continent_code, 
    c.currency_code, 
    COUNT(*) AS currency_usage 
FROM countries AS c
GROUP BY c.continent_code, c.currency_code 
HAVING currency_usage > 1 AND currency_usage = (
	SELECT COUNT(*) AS max_usage
    FROM countries
    WHERE continent_code = c.continent_code
    GROUP BY currency_code
    ORDER BY max_usage DESC
    LIMIT 1)
ORDER BY c.continent_code, c.currency_code;

-- ChatGPT version
SELECT 
    c.continent_code,
    mc.currency_code,
    COUNT(c.country_code) AS currency_usage
FROM countries c
JOIN (
    SELECT 
        continent_code,
        currency_code,
        ROW_NUMBER() OVER (PARTITION BY continent_code ORDER BY COUNT(country_code) DESC) AS row_num
    FROM countries
    GROUP BY continent_code, currency_code
) mc ON c.continent_code = mc.continent_code AND c.currency_code = mc.currency_code AND mc.row_num = 1
GROUP BY c.continent_code, mc.currency_code
ORDER BY c.continent_code, currency_usage;
