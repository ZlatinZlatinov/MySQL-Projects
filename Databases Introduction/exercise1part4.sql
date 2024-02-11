-- CREATE DATABASE soft_uni; 

-- 13. Basic Insert 100/100
USE soft_uni;
-- MySQL DOES NOT WANT TO CRATE IT
-- DATABASE IS NOT POPULATED WITH DATA
-- SOME OF THE TABLE ARE NOT CREATED

CREATE TABLE towns (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(80)
);

CREATE TABLE addresses (
	id INT PRIMARY KEY AUTO_INCREMENT, 
	address_text TEXT, 
    town_id INT, 
    CONSTRAINT FK_ADDRESS_TOWN 
    FOREIGN KEY (town_id) REFERENCES town(id)
); 

CREATE TABLE departments (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(80)
); 

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(80) NOT NULL, 
    middle_name VARCHAR(80), 
    last_name VARCHAR(80) NOT NULL, 
    job_title VARCHAR(30), 
    department_id INT, 
    hire_date DATE, 
    salary DOUBLE, 
    address_id INT, 
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (address_id) REFERENCES addresses(id)
); 

INSERT INTO towns (name)
VALUES ("Sofia"), ("Plovdiv"), ("Varna"), ("Burgas"); 

INSERT INTO departments (name) VALUES
("Engineering"),
("Sales"), 
("Marketing"),
("Software Development"),  
("Quality Assurance"); 

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

-- 14. Basic Select All Fields 100/100
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

-- 15. Basic Select All Fields and Order Them 100/100
SELECT *
FROM towns
ORDER BY name, id ASC;

SELECT * 
FROM departments
ORDER BY name, id ASC; 

SELECT * 
FROM employees
ORDER BY salary DESC;

-- 16. Basic Select Some Fields 100/100
SELECT name
FROM towns
ORDER BY name ASC;

SELECT name
FROM departments
ORDER BY name ASC; 

SELECT first_name, last_name, job_title, salary 
FROM employees
ORDER BY salary DESC; 

-- 17. Increase Employees Salary 100/100
UPDATE employees
SET salary = salary * 1.10; 

SELECT salary FROM employees;