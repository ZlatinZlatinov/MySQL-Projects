-- 01. Select Employee Information 100/100
SELECT id, first_name, last_name, job_title 
FROM employees 
ORDER BY id ASC; 

-- 02. Select Employees with Filter 100/100
SELECT id, CONCAT(first_name, " ", last_name) as full_name, job_title, salary
FROM employees 
WHERE salary > 1000.00
ORDER BY id ASC; 

-- 03. Update Salary and Select 100/100
UPDATE employees 
SET salary = salary + 100
where job_title = "Manager"; 
SELECT salary FROM employees; 

-- 04. Top Paid Employee 100/100
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1; 

-- 05. Select Employees by Multiple Filters 100/100
SELECT * FROM employees
WHERE department_id = 4 
AND salary >= 1000
ORDER BY id; 

-- 06. Delete from Table 100/100 
-- Query is not executed!

-- DELETE from employees 
-- WHERE department_id = 1 OR department_id = 2; 
SELECT * FROM employees
ORDER BY id;
