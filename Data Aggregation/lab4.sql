USE restaurant;
-- 1. Departments Info 100/100;
SELECT department_id, 
	COUNT(department_id) AS 'Number of employees'
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 2. Average Salary 100/100
SELECT department_id, 
	ROUND(AVG(salary), 2) AS 'Average Salary'
FROM employees
GROUP BY department_id
ORDER BY department_id; -- by default; 

-- 3. Minimum Salary 100/100
SELECT department_id, 
	ROUND(MIN(salary), 2) AS 'Min Salary'
FROM employees
GROUP BY department_id
HAVING  MIN(salary) > 800
ORDER BY department_id; -- by default; 

-- 4. Appetizers Count 100/100
SELECT COUNT(category_id) as 'Appetizers Count'
FROM products 
WHERE price > 8
GROUP BY category_id
HAVING category_id = 2; 

-- 5. Menu Prices 100/100; On the document was used FORMAT
SELECT category_id,
	ROUND(AVG(price), 2) as 'Average Price',
    ROUND(MIN(price), 2) as 'Cheapest Product',
    ROUND(MAX(price), 2) as 'Most Expensive Product'
FROM products
GROUP BY category_id; 