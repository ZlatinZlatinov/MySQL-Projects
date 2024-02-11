USE soft_uni; 

-- 1. Count Employees by Town 100/100
-- Send without delimiter
DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20)) 
RETURNS INT 
DETERMINISTIC 
BEGIN 
	DECLARE e_count INT; 
    SET e_count := (
    SELECT 
		COUNT(*)
	FROM employees AS e
		JOIN addresses AS a
		ON e.address_id = a.address_id
		JOIN towns AS t
		ON a.town_id = t.town_id
	WHERE t.name = town_name);
    RETURN e_count; 
END$$ 

SELECT ufn_count_employees_by_town(null) AS count; 

DELIMITER $$ 
CREATE PROCEDURE usp_select_employees_by_seniority() 
BEGIN 
	SELECT * FROM employees 
    WHERE ROUND((DATEDIFF(NOW(), hire_date) / 365.25)) < 15; 
END $$

DELIMITER ;
CALL usp_select_employees_by_seniority(); 

-- 2. Employees Promotion 100/100
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name varchar(50)) 
BEGIN 
	UPDATE employees AS e 
	JOIN departments AS d
	ON e.department_id = d.department_id
	SET salary = salary * 1.05 
	WHERE d.name = department_name; 
END$$ 

DELIMITER ; 
SELECT first_name, salary FROM employees 
where department_id = 10;
CALL usp_raise_salaries('Finance'); 


-- 3. Employees Promotion By ID 100/100
-- This is transaction
DELIMITER $

CREATE PROCEDURE usp_raise_salary_by_id(id INT) 
BEGIN 
	START TRANSACTION; 
    IF((SELECT COUNT(*) FROM employees WHERE employee_id = id) <> 1) THEN 
		ROLLBACK; 
    ELSE 
		UPDATE employees
        SET salary = salary * 1.05 
        WHERE employee_id = id;
        COMMIT;
    END IF; 
END $ 

DELIMITER ; 

CALL usp_raise_salary_by_id(17); 

SELECT * FROM employees 
WHERE employee_id = 17; 


USE soft_uni; 

-- 4. Triggered 100/100
CREATE TABLE deleted_employees (
	employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    middle_name VARCHAR(20), 
    job_title VARCHAR(50),
    department_id INT, 
    salary DOUBLE
); 

CREATE TRIGGER tr_deleted_employees 
AFTER DELETE 
ON employees 
FOR EACH ROW 
	INSERT INTO deleted_employees(first_name,
		last_name,
		middle_name,
		job_title,
		department_id,
		salary) 
	VALUE (OLD.first_name, OLD.last_name, OLD.middle_name,
		OLD.job_title, OLD.department_id, OLD.salary);