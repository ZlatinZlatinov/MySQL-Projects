
-- 01. Employees with Salary Above 35000 100/100
DELIMITER $ 

CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN 
	SELECT first_name, last_name 
    FROM employees 
    WHERE salary > 35000 
	ORDER BY first_name, last_name, employee_id;
END $ 

DELIMITER ; 

USE soft_uni; 
SELECT first_name, last_name 
    FROM employees 
    WHERE salary > 35000 
ORDER BY first_name, last_name, employee_id; 

-- 02. Employees with Salary Above Number 100/100
DELIMITER $
CREATE PROCEDURE usp_get_employees_salary_above(num DECIMAL(15,4))
BEGIN
	SELECT first_name, last_name 
		FROM employees 
		WHERE salary >= num 
	ORDER BY first_name, last_name, employee_id; 
END $ 

DELIMITER ; 

-- 03. Town Names Starting With 100/100
DELIMITER $
CREATE PROCEDURE usp_get_towns_starting_with(inputString VARCHAR(55)) 
BEGIN 
	SELECT name as town_name
    FROM towns 
    WHERE name LIKE CONCAT(inputString, '%') 
    ORDER BY name;
END $ 
DELIMITER ; 

-- 04. Employees from Town 100/100
DELIMITER $ 
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(55))
BEGIN
	SELECT e.first_name, e.last_name
	FROM employees AS e 
		JOIN addresses as a 
		ON e.address_id = a.address_id 
		JOIN towns as t
		ON a.town_id = t.town_id 
	WHERE t.name = town_name
	ORDER BY e.first_name, e.last_name, e.employee_id; 
END $ 
DELIMITER ;

-- 05. Salary Level Function 100/100
DELIMITER $ 
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE result VARCHAR(20);
		SET result := CASE 
			WHEN salary < 30000 THEN 'Low' 
            WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
            WHEN salary > 50000 THEN 'High'
		END;  
	RETURN result;
END $
DELIMITER ; 

SELECT salary, 
	ufn_get_salary_level(salary) 
    FROM employees;
    
    
-- 06. Employees by Salary Level 100/100
DELIMITER $ 
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(10))
BEGIN 
	IF(salary_level = 'Low' ) THEN 
		SELECT first_name, last_name 
        FROM employees 
        WHERE salary < 30000
        ORDER BY first_name DESC, last_name DESC; 
	ELSEIF(salary_level = 'Average') THEN 
		SELECT first_name, last_name 
        FROM employees 
        WHERE salary BETWEEN 30000 AND 50000
        ORDER BY first_name DESC, last_name DESC; 
	ELSEIF(salary_level = 'High') THEN
		SELECT first_name, last_name 
        FROM employees 
        WHERE salary > 50000
        ORDER BY first_name DESC, last_name DESC; 
	END IF;
END $ 
DELIMITER ; 


-- 07. Define Function 100/100
DELIMITER $ 
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50) , word varchar(50))  
RETURNS TINYINT
BEGIN 
	DECLARE set_length INT;
    DECLARE i INT;
    DECLARE current_letter CHAR; 
    
    SET word_length := LENGTH(word);
    SET i := 1; 
    
    WHILE i <= word_length DO 
		SET current_letter := SUBSTRING(word, i, 1);
        
        IF (LOCATE(current_letter, set_of_letters) = 0) THEN
            RETURN 0;
        END IF; 
        
        SET i = i + 1; 
        
	END WHILE; 
    
    RETURN 1; 
END $
DELIMITER ; 

-- Senior style with regex 100/100
DELIMITER $
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50) , word varchar(50))  
RETURNS TINYINT
BEGIN 
	RETURN word REGEXP CONCAT('^[', set_of_letters, ']$');
END $
DELIMITER ; 

-- 08. Find Full Name 100/100
DELIMITER $ 
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN 
	SELECT CONCAT(first_name, " ", last_name) AS full_name 
    FROM account_holders
    ORDER BY full_name;
END $
DELIMITER ; 

-- 9. People with Balance Higher Than 100/100
DELIMITER $ 
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(num INT)
BEGIN
	SELECT 
		ah.first_name, 
		ah.last_name
	FROM account_holders AS ah
		JOIN accounts AS a
		ON ah.id = a.account_holder_id
	GROUP BY ah.id 
	HAVING SUM(a.balance) > num
    ORDER BY ah.id;
END $  
DELIMITER ; 

SELECT 
		ah.first_name, 
		ah.last_name
	FROM account_holders AS ah
		JOIN accounts AS a
		ON ah.id = a.account_holder_id
	GROUP BY ah.id 
	HAVING SUM(a.balance) > 7000
    ORDER BY ah.id; 
    

-- 10. Future Value Function 100/100    
DELIMITER $ 
CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(10, 4), interest_rate DECIMAL(10, 4), years INT)
RETURNS DECIMAL(10, 4) 
BEGIN 
	
    RETURN initial_sum * POWER((1 + interest_rate), years);
    
END $
DELIMITER ; 

SELECT 1000 * POWER((1 + 0.5), 5) AS result; 

-- 11. Calculating Interest 100/100
DELIMITER $
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, ir DECIMAL(10,4)) 
BEGIN 
	SELECT 
		a.id,
        ah.first_name,
        ah.last_name,
        a.balance,
        ufn_calculate_future_value(a.balance, ir, 5) AS balance_in_5_years 
	FROM accounts AS a 
		JOIN account_holders AS ah
        ON a.account_holder_id = ah.id AND a.id = id;
END $ 
DELIMITER ; 

-- 12. Deposit Money 100/100
DELIMITER $ 
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(12,4))
BEGIN 
	START TRANSACTION; 
    IF (money_amount <= 0 OR (SELECT COUNT(*) FROM accounts WHERE id = account_id) = 0) THEN 
		ROLLBACK; 
	ELSE 
		UPDATE accounts 
        SET balance = balance + money_amount
        WHERE id = account_id; 
        COMMIT;
	END IF;
END $
DELIMITER ; 

SELECT COUNT(*) FROM accounts 
WHERE id = 40; 


-- 13. Withdraw Money 100/100
DELIMITER $ 
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(16,4))
BEGIN 
	START TRANSACTION; 
    IF ((SELECT COUNT(*) FROM accounts WHERE id = account_id) <> 1 
		OR money_amount < 0
        OR (SELECT balance FROM accounts WHERE id = account_id) < money_amount) THEN 
		ROLLBACK;
	ELSE 
		UPDATE accounts 
        SET balance = balance - money_amount
        WHERE id = account_id; 
        COMMIT;
	END IF;
END $
DELIMITER ;

SELECT balance from accounts where id = 1; 


-- 14. Money Transfer 100/100
DELIMITER $ 
CREATE PROCEDURE usp_transfer_money(from_id INT, to_id INT, amount DECIMAL(16,4))
BEGIN 
	START TRANSACTION; 
    
    IF(from_id = to_id OR
		(SELECT COUNT(*) FROM accounts WHERE id = from_id) <> 1 OR
        (SELECT COUNT(*) FROM accounts WHERE id = to_id) <> 1 OR
        (SELECT balance FROM accounts WHERE id = from_id) < amount OR
        amount <= 0) THEN ROLLBACK; 
	ELSE 
		UPDATE accounts
        SET balance = balance - amount 
        WHERE id = from_id; 
        
        UPDATE accounts
        SET balance = balance + amount 
        WHERE id = to_id;
    END IF;
END $
DELIMITER ; 


-- 15. Log Accounts Trigger 100/100 
-- + 16. Emails Trigger
CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT, 
    account_id INT, 
    old_sum DECIMAL(18,4), 
    new_sum DECIMAL(18,4)
); 

CREATE TRIGGER tr_account_update 
AFTER UPDATE 
ON accounts
FOR EACH ROW
	INSERT INTO logs(account_id, old_sum, new_sum)
    VALUES (OLD.id, OLD.balance, NEW.balance);

-- 16
CREATE TABLE notification_emails(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    recipient INT, 
    subject VARCHAR(100), 
    body TEXT
); 

CREATE TRIGGER tr_notifications 
AFTER INSERT 
ON logs 
FOR EACH ROW 
	INSERT INTO notification_emails (recipient, subject, body)
    VALUES (NEW.account_id, 
		CONCAT('Balance change for account: ', NEW.account_id),
        CONCAT('On ', 
        DATE_FORMAT(current_date, "%b %d %Y"), 
        ' at ', CURRENT_TIME(), ' AM your balance was changed from ', 
        NEW.old_sum, ' to ', NEW.new_sum, '.'));