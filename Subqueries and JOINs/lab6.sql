USE soft_uni; 

-- 1. Managers 100/100
SELECT e.employee_id, 
	CONCAT(e.first_name, " ", e.last_name) AS full_name, 
    d.department_id,
    d.name
FROM employees AS e 
RIGHT JOIN departments AS d
ON e.employee_id = d.manager_id 
ORDER BY e.employee_id
LIMIT 5; 

-- 2. Towns and Addresses 100/100
SELECT t.town_id, 
	t.name AS town_name,
    a.address_text 
FROM towns AS t
JOIN addresses AS a
ON t.town_id = a.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation') 
ORDER BY t.town_id, a.address_id; 

-- 3. Employees Without Managers 100/100
SELECT employee_id, 
	first_name, 
    last_name, 
    department_id, 
    salary 
FROM employees 
WHERE manager_id is NULL; 

-- 4. High Salary 100/100
SELECT COUNT(employee_id) AS count 
FROM employees 
WHERE salary > (
	SELECT AVG(salary) FROM employees);