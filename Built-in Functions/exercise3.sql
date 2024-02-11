USE soft_uni; 

-- 01. Find Names of All Employees by First Name 100/100
SELECT first_name, last_name 
FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id; 

-- 02. Find Names of All Employees by Last Name 100/100
SELECT first_name, last_name 
FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id; 

-- 03. Find First Names of All Employess 100/100
SELECT first_name FROM employees
WHERE department_id IN (3, 10) AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id; 

-- 04. Find All Employees Except Engineers 100/100
SELECT first_name, last_name 
FROM employees 
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id; 

-- 05. Find Towns with Name Length 100/100
SELECT name FROM towns
WHERE LENGTH(name) IN (5,6)
ORDER BY name;

-- 06. Find Towns Starting With 100/100
SELECT town_id, name FROM towns
WHERE name LIKE 'M%' OR name LIKE 'K%' OR name LIKE 'B%' OR name LIKE 'E%'
ORDER BY name;  

-- 07. Find Towns Not Starting With 100/100
SELECT town_id, name FROM towns
WHERE name NOT LIKE 'R%' AND name NOT LIKE 'B%' AND name NOT LIKE 'D%'
ORDER BY name;

-- 08. Create View Employees Hired After 100/100
CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name, last_name 
FROM employees
WHERE YEAR(hire_date) > 2000;

-- 09. Length of Last Name 100/100
SELECT first_name, last_name 
FROM employees 
WHERE LENGTH(last_name) = 5;

USE geography; -- DB is created

-- 10. Countries Holding 'A' 100/100 Ама добре че е ChatGPT 
SELECT country_name, iso_code
FROM countries
WHERE country_name REGEXP '([aA].*){3,}'
ORDER BY iso_code; 

-- 11. Mix of Peak and River Names 100/100 GPT...
SELECT peaks.peak_name, rivers.river_name, LOWER(CONCAT(peaks.peak_name, SUBSTRING(rivers.river_name, 2))) as mix
FROM peaks, rivers
WHERE SUBSTRING(peaks.peak_name, -1) = SUBSTRING(rivers.river_name, 1, 1)
ORDER BY mix; 
-- Moze i taka. IDK...
SELECT peak_name, river_name, LOWER(CONCAT(peaks.peak_name, SUBSTRING(river_name, 2))) as mix
FROM peaks
JOIN rivers ON SUBSTRING(peaks.peak_name, -1) = SUBSTRING(rivers.river_name, 1, 1)
ORDER BY mix; 

-- 12. Games From 2011 and 2012 Year 100/100
SELECT name, DATE_FORMAT(start, "%Y-%m-%d") FROM games
WHERE YEAR(start) IN (2011, 2012)
ORDER BY start, name
LIMIT 50; 

-- 13. User Email Providers 100/100
SELECT user_name, SUBSTRING(email, POSITION('@' IN email) + 1) AS email_provider
FROM users
ORDER BY email_provider, user_name; 

-- 14. Get Users with IP Address Like Pattern 100/100; USE LIKE!
SELECT user_name, ip_address
FROM users
WHERE ip_address Like '___.1%.%.___'
ORDER BY user_name; 

USE diablo;

-- 15. Show All Games with Duration 100/100
SELECT name as 'game',
CASE
	WHEN HOUR(start) >= 0 AND HOUR(start) < 12 THEN 'Morning' 
    WHEN HOUR(start) >= 12 AND HOUR(start) < 18 THEN 'Afternoon'
    WHEN HOUR(start) >= 18 AND HOUR(start) < 24 THEN 'Evening'
    END AS 'Part of the Day',
CASE
	WHEN duration <= 3 THEN 'Extra Short'
    WHEN duration > 3 AND duration <= 6 THEN 'Short'
    WHEN duration > 6 AND duration <= 10 THEN 'Long'
    ELSE 'Extra Long'
	END AS 'Duration'
FROM games;

-- 16. Orders Table 100/100 ; DB not crated
SELECT product_name, order_date, 
ADDDATE(order_date, INTERVAL 3 DAY) as 'pay_due',
ADDDATE(order_date, INTERVAL 1 MONTH)
FROM orders;