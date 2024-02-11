USE `gringotts`; 

-- 01. Records’ Count 100/100
SELECT COUNT(id) as 'count'
FROM wizzard_deposits; 

-- 02. Longest Magic Wand 100/100
SELECT MAX(magic_wand_size) as longest_magic_wand 
FROM wizzard_deposits; 

-- 03. Longest Magic Wand per Deposit Groups 100/100
SELECT deposit_group, MAX(magic_wand_size) as longest_magic_wand
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY longest_magic_wand, deposit_group; 

-- 04. Smallest Deposit Group per Magic Wand Size 100/100 
-- Definitely not the right way...
SELECT deposit_group
FROM wizzard_deposits
GROUP BY deposit_group
HAVING AVG(magic_wand_size)
LIMIT 1;

-- 05. Deposits Sum 100/100
SELECT deposit_group, ROUND(SUM(deposit_amount), 2) as total_sum
FROM wizzard_deposits
GROUP BY deposit_group
ORDER BY total_sum;

-- 06. Deposits Sum for Ollivander Family 100/100
SELECT deposit_group, ROUND(SUM(deposit_amount), 2) as total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
ORDER BY deposit_group; 

-- 07. Deposits Filter 100/100
SELECT deposit_group, ROUND(SUM(deposit_amount), 2) as total_sum
FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC; 

-- 08. Deposit Charge 100/100
SELECT deposit_group, 
	magic_wand_creator, 
	MIN(deposit_charge) as 'min_deposit_charge'
FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group; 


SELECT COUNT(id) as wizard_count
FROM wizzard_deposits
WHERE age BETWEEN 11 AND 20
GROUP BY age;

-- 09. Age Groups 100/100 dobre che e ChatGPT
SELECT
  CASE
    WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
    WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
    WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
    WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
    WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
    WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
    WHEN age >= 61 THEN '[61+]'
  END AS age_group,
  COUNT(id) AS wizard_count
FROM wizzard_deposits
GROUP BY age_group
ORDER BY age_group; 

-- 10. First Letter 100/100
SELECT SUBSTRING(first_name, 1, 1) as first_letter 
from wizzard_deposits
where deposit_group = 'Troll Chest'
GROUP BY first_letter
ORDER BY first_letter;

-- 11. Average Interest 100/100
SELECT deposit_group,
	is_deposit_expired,
	AVG(deposit_interest) as average_interest
FROM wizzard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired;

USE soft_uni; 

-- 12. Employees Minimum Salaries 100/100
SELECT department_id, 
	ROUND(MIN(salary), 2) as minimum_salary
FROM employees
WHERE department_id IN(2,5,7) AND hire_date > '2000-01-01'
GROUP BY department_id 
ORDER BY department_id; 

-- 13. Employees Average Salaries 100/100
CREATE TABLE high_paid_emp (
  `employee_id` int(10) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) NOT NULL,
  `department_id` int(10) NOT NULL,
  `manager_id` int(10) DEFAULT NULL,
  `hire_date` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `salary` decimal(19,4) NOT NULL,
  `address_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `PK_Employees` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=294 DEFAULT CHARSET=utf8;

INSERT INTO high_paid_emp 
SELECT * FROM employees
WHERE salary > 30000; 

DELETE from high_paid_emp 
WHERE manager_id = 42;

UPDATE high_paid_emp
SET salary = salary + 5000
WHERE department_id = 1; 

SELECT department_id, AVG(salary) as avg_salary
FROM high_paid_emp
GROUP BY department_id
ORDER BY department_id;

-- 14. Employees Maximum Salaries 100/100
SELECT department_id, 
	MAX(salary) AS max_salary
FROM employees 
GROUP BY department_id
HAVING max_salary NOT BETWEEN 30000 AND 70000
ORDER BY department_id;

-- 15. Employees Count Salaries 100/100
SELECT COUNT(employee_id) as count
FROM employees
WHERE manager_id IS NULL; 

-- 16. 3rd Highest Salary 100/100
SELECT department_id AS d,
    (SELECT DISTINCT salary
        FROM employees
        WHERE department_id = d
        ORDER BY salary DESC
        LIMIT 1 OFFSET 2) AS third_highest_salary
FROM employees
GROUP BY department_id
HAVING third_highest_salary IS NOT NULL
ORDER BY department_id;

SELECT DISTINCT salary, department_id 
from employees 
where department_id = 1 
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

-- 17. Salary Challenge 100/100
SELECT e.first_name, e.last_name, e.department_id
FROM employees AS e
WHERE e.salary > (
	SELECT AVG(salary)
	FROM employees 
	WHERE e.department_id = department_id)
ORDER BY e.department_id, e.employee_id
LIMIT 10; 


SELECT AVG(salary)
FROM employees
GROUP BY department_id;

-- 18. Departments Total Salaries 100/100
SELECT department_id, SUM(salary) as total_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;