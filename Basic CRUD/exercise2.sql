USE soft_uni; -- DB was created at some point
-- 01. Find All Information About Departments 100/100
SELECT * FROM departments
ORDER BY department_id; 

-- 02. Find all Department Names 100/100
SELECT name FROM departments
ORDER BY department_id; 

-- 03. Find Salary of Each Employee 100/100
SELECT first_name, last_name, salary 
FROM employees  
ORDER BY employee_id; 

-- 04. Find Full Name of Each Employee 100/100
SELECT first_name, middle_name, last_name 
FROM employees  
ORDER BY employee_id;

-- 05. Find Email Address of Each Employee 100/100
SELECT CONCAT(first_name, ".", last_name, "@softuni.bg") as full_email_address
FROM employees; 

-- 06. Find All Different Employee’s Salaries 100/100
SELECT DISTINCT salary as Salary FROM employees;  

-- 07. Find all Information About Employees 100/100
SELECT * FROM employees
WHERE job_title = "Sales Representative"
ORDER BY employee_id; 

-- 08. Find Names of All Employees by Salary in Range 100/100
SELECT first_name, last_name, job_title 
FROM employees 
WHERE salary BETWEEN 20000 AND 30000
ORDER BY employee_id; 

-- 9. Find Names of All Employees 100/100
SELECT CONCAT(first_name, " ", middle_name, " ", last_name) as 'Full Name' 
FROM employees 
WHERE salary in (25000, 14000, 12500, 23600); 

-- 10. Find All Employees Without Manager 100/100
SELECT first_name, last_name
FROM employees
WHERE manager_id IS NULL; 

-- 11. Find All Employees with Salary More Than 50000 100/100
SELECT first_name, last_name, salary
FROM employees 
WHERE salary > 50000
ORDER BY salary DESC; 

-- 12. Find 5 Best Paid Employees 100/100
SELECT first_name, last_name
FROM employees
ORDER BY salary DESC
LIMIT 5; 

-- 13. Find All Employees Except Marketing 100/100
SELECT first_name, last_name
FROM employees 
WHERE department_id <> 4; 

-- 14. Sort Employees Table 100/100
SELECT *
FROM employees
ORDER BY salary DESC, first_name ASC, last_name DESC, middle_name ASC, employee_id ASC;

-- 15. Create View Employees with Salaries 100/100
CREATE VIEW v_employees_salaries AS
SELECT first_name, last_name, salary 
FROM employees;

-- 16. Create View Employees with Job Titles 100/100 -- ot 10tiq put xdd
CREATE VIEW v_employees_job_titles2 AS
SELECT CONCAT(first_name, " ", IF(ISNULL(middle_name), "", CONCAT(middle_name, " ")), last_name) as full_name, job_title
FROM  employees;  
-- Simy use CONCAT_WS

-- 17. Distinct Job Titles 100/100
SELECT DISTINCT job_title 
FROM employees 
ORDER BY job_title ASC;

-- 18. Find First 10 Started Projects 100/100
SELECT * FROM projects
ORDER BY start_date ASC, name, project_id 
LIMIT 10; 

-- 19. Last 7 Hired Employees 100/100
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 7;

-- 20. Increase Salaries 100/100 dea i jugeto
UPDATE  employees 
SET salary = salary * 1.12
WHERE department_id IN (
	SELECT DISTINCT department_id from departments
    WHERE NAME IN('Engineering', 'Tool Design', 'Marketing', 'Information Services')
); 

SELECT salary as Salary FROM employees;

SELECT DISTINCT department_id from departments
WHERE name IN('Engineering', 'Tool Design', 'Marketing', 'Information Services');

-- For thoose bellow DB is not created
-- 21. All Mountain Peaks 100/100
SELECT peak_name FROM peaks
ORDER BY peak_name ASC; 

-- 22. Biggest Countries by Population 100/100
SELECT country_name, population 
FROM countries 
WHERE continent_code = 'EU'
ORDER BY population DESC, country_name ASC
LIMIT 30;  

-- 23. Countries and Currency (Euro / Not Euro) 100/100
SELECT country_name, country_code, IF(currency_code = 'EUR', "Euro", 'Not Euro') 
FROM countries 
ORDER BY country_name ASC;

-- 24. All Diablo Characters 100/100
SELECT name FROM characters 
ORDER BY name ASC;