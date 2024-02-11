CREATE DATABASE restaurant_exam_prep; 
-- suiii
USE restaurant_exam_prep; 
-- 01. Table Design 40/40
CREATE TABLE products (
	id int PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(30) NOT NULL UNIQUE,
    type VARCHAR(30) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
); 

CREATE TABLE clients (
	id int PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    birthdate DATE NOT NULL, 
    card VARCHAR(50),
    review TEXT
); 

CREATE TABLE tables (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    floor INT NOT NULL, 
    reserved BOOLEAN,
    capacity INT NOT NULL
); 

CREATE TABLE waiters (
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(50), 
    salary DECIMAL(10, 2)
); 

CREATE TABLE orders (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    table_id INT NOT NULL, 
    waiter_id INT NOT NULL, 
    order_time TIME NOT NULL,
    payed_status BOOLEAN, 
    CONSTRAINT fk_orders_tables 
    FOREIGN KEY (table_id) 
    REFERENCES tables(id), 
    CONSTRAINT fk_orders_waiters 
    FOREIGN KEY (waiter_id)
    REFERENCES waiters(id)
); 

CREATE TABLE orders_products (
	order_id INT, 
    product_id INT, 
    KEY k_orders_products (order_id, product_id),
    CONSTRAINT fk_orders_products_orders
    FOREIGN KEY (order_id) 
    REFERENCES orders(id), 
    CONSTRAINT fk_orders_products_products 
    FOREIGN KEY (product_id)
    REFERENCES products(id)
); 

CREATE TABLE orders_clients (
	order_id INT, 
    client_id INT, 
    KEY k_orders_clients (order_id, client_id), 
    CONSTRAINT fk_order_clients_orders 
    FOREIGN KEY (order_id)
    REFERENCES orders(id),
    CONSTRAINT fk_order_clients_clients 
    FOREIGN KEY (client_id) 
    REFERENCES clients(id)
); 

-- 02. Insert 10/10
INSERT INTO products (
	name, 
    type,
    price) 
SELECT 
	CONCAT(last_name, ' specialty'),
    'Cocktail',
    CEILING(salary * 0.01)
FROM waiters WHERE id > 6;
 
-- 03. Update 10/10
UPDATE orders 
SET table_id = table_id - 1
WHERE id BETWEEN 12 AND 23;

-- 04. Delete 
DELETE FROM waiters 
WHERE id NOT IN (
	SELECT DISTINCT waiter_id
    FROM orders
); 

-- 05. Clients 10/10
SELECT * FROM clients 
ORDER BY birthdate DESC, id DESC; 

-- 06. Birthdate 10/10
SELECT 
	first_name,
    last_name, 
    birthdate,
    review 
FROM clients 
WHERE card IS NULl AND (YEAR(birthdate) BETWEEN 1978 AND 1993)
ORDER BY last_name DESC, id
LIMIT 5;

-- 07. Accounts 10/10
SELECT 
	id,
	CONCAT(last_name, first_name, CHAR_LENGTH(first_name), "Restaurant") AS username,
    REVERSE(SUBSTRING(email, 2, 12)) AS password
FROM waiters 
WHERE salary IS NOT NULL
ORDER BY password DESC; 

-- 08 Top from Menu 10/10
SELECT 
	p.id,
    p.name, 
    COUNT(op.product_id) AS count
FROM products AS p 
JOIN orders_products AS op 
ON p.id = op.product_id 
GROUP BY p.id 
HAVING count >= 5
ORDER BY count DESC, p.name;

-- 09. Availability 10/10
SELECT 
	t.id, 
    t.capacity, 
    COUNT(oc.client_id) AS count_clients, 
    CASE 
		WHEN capacity > COUNT(oc.client_id) THEN 'Free seats'
        WHEN capacity = COUNT(oc.client_id) THEN 'Full'
        WHEN capacity < COUNT(oc.client_id) THEN 'Extra seats'
    END AS availability
FROM tables AS t 
	JOIN orders AS o 
		ON t.id = o.table_id 
	JOIN orders_clients AS oc 
		ON o.id = oc.order_id 
WHERE t.floor = 1
GROUP BY t.id 
ORDER BY t.id DESC; 

-- 10. Extract Bill 15/15
DELIMITER $ 
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50)) 
RETURNS DECIMAL(10,2) 
DETERMINISTIC 
BEGIN 
	DECLARE result DECIMAL(19, 2); 
    SET result := (
		SELECT 
			SUM(p.price) AS bill
		FROM clients AS c 
			JOIN orders_clients AS oc 
				ON c.id = oc.client_id 
			JOIN orders_products AS op 
				ON oc.order_id = op.order_id 
			JOIN products AS p 
				ON op.product_id = p.id
		WHERE CONCAT(c.first_name, " ", c.last_name) = full_name 
		GROUP BY c.id);
    
    RETURN result;
END $
DELIMITER ; 

SELECT 
    SUM(p.price) AS bill
FROM clients AS c 
	JOIN orders_clients AS oc 
		ON c.id = oc.client_id 
	JOIN orders_products AS op 
		ON oc.order_id = op.order_id 
	JOIN products AS p 
		ON op.product_id = p.id
WHERE CONCAT(c.first_name, " ", c.last_name) = 'Silvio Blyth' 
GROUP BY c.id; 
-- HAVING full_name = 'Silvio Blyth'; 

-- 11. Happy hour 15/15
DELIMITER $ 
CREATE PROCEDURE udp_happy_hour(prouct_type VARCHAR(50))
BEGIN 
	UPDATE products 
    SET price = price * 0.80 
    WHERE type = prouct_type AND price >= 10;
END $
DELIMITER ;