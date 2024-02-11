CREATE DATABASE real_estate; 
-- suiiiii
USE real_estate; 
-- 01. Table Design 40/40
CREATE TABLE cities (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(60) NOT NULL UNIQUE
); 

CREATE TABLE buyers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT,
    CONSTRAINT fk_buyers_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(id)
); 

CREATE TABLE agents (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    city_id INT,
    CONSTRAINT fk_agents_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(id)
); 

CREATE TABLE property_types (
	id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(40) NOT NULL UNIQUE, 
    description TEXT
); 

CREATE TABLE properties (
	id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(80) NOT NULL UNIQUE,
    price DECIMAL(19,2) NOT NULL,
    area DECIMAL(19,2), 
    property_type_id INT,
    city_id INT, 
    CONSTRAINT fk_properties_property_types 
    FOREIGN KEY (property_type_id)
    REFERENCES property_types(id),
    CONSTRAINT fk_properties_cities 
    FOREIGN KEY (city_id)
    REFERENCES cities(id)
); 

CREATE TABLE property_offers (
	property_id INT NOT NULL, 
    agent_id INT NOT NULL, 
    price DECIMAL(19, 2) NOT NULL, 
    offer_datetime DATETIME,
    KEY pk_property_offers (property_id, agent_id), 
    CONSTRAINT fk_prperty_offers_properties 
    FOREIGN KEY (property_id) 
    REFERENCES properties(id), 
    CONSTRAINT fk_propert_offers_agents
    FOREIGN KEY (agent_id)
    REFERENCES agents(id)
); 

CREATE TABLE property_transactions (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    property_id INT NOT NULL, 
    buyer_id INT NOT NULL, 
    transaction_date DATE,
    bank_name VARCHAR(30),
    iban VARCHAR(40) UNIQUE, 
    is_successful BOOLEAN, 
    CONSTRAINT fk_property_transactions_properties
    FOREIGN KEY (property_id)
    REFERENCES properties(id),
    CONSTRAINT fk_property_transactions_buyers 
    FOREIGN KEY (buyer_id) 
    REFERENCES buyers(id)
); 

-- 02. Insert 10/10
INSERT INTO property_transactions (
	property_id,
    buyer_id,
    transaction_date,
    bank_name,
    iban,
    is_successful
) SELECT
	agent_id + DAY(offer_datetime),
    agent_id + MONTH(offer_datetime),
    DATE(offer_datetime),
    CONCAT("Bank ", agent_id),
    CONCAT("BG", price, agent_id),
    1
FROM property_offers 
WHERE agent_id <= 2; 

SELECT DATE('2022-09-04 02:46:07'); 

-- 03. Update 10/10
UPDATE properties 
SET price = price - 50000
WHERE price >= 800000; 

-- 04. Delete 10/10
DELETE FROM property_transactions
WHERE is_successful = 0; 

-- 05. Agents 10/10
SELECT * FROM agents 
ORDER BY city_id DESC, phone DESC; 

-- 06. Offers from 2021 10/10
SELECT 
	property_id, 
    agent_id, 
    price, 
    offer_datetime 
FROM  property_offers 
WHERE YEAR(offer_datetime) = '2021' 
ORDER BY price 
LIMIT 10; 

-- 07. Properties without offers 10/10
SELECT 
	SUBSTRING(address, 1, 6) AS agent_name,
    CHAR_LENGTH(address) * 5430 AS price
FROM properties 
WHERE id NOT IN (
	SELECT DISTINCT property_id 
    FROM property_offers) 
ORDER BY agent_name DESC, price DESC; 

-- 08. Best Banks 10/10
SELECT 
	bank_name,
    COUNT(iban) AS count 
FROM property_transactions 
GROUP BY bank_name 
HAVING count >= 9 
ORDER BY count DESC, bank_name; 

-- 09. Size of the area 10/10
SELECT 
	address, 
    area, 
    CASE 
		WHEN area <= 100 THEN 'small'
        WHEN area <= 200 THEN 'medium'
        WHEN area <= 500 THEN 'large'
        WHEN area > 500 THEN 'extra large'
	END AS size 
FROM properties 
ORDER BY area, address DESC; 

-- 10. Offers count in a city 15/15
DELIMITER $ 
CREATE FUNCTION udf_offers_from_city_name (cityName VARCHAR(50)) 
RETURNS INT 
DETERMINISTIC 
BEGIN 
	RETURN (
		SELECT COUNT(po.property_id) AS count 
		FROM property_offers AS po 
			JOIN properties AS p
				ON po.property_id = p.id
			JOIN cities AS c
				ON p.city_id = c.id
		WHERE c.name = cityName
		GROUP BY c.id);
END $
DELIMITER ; 

SELECT COUNT(po.property_id) AS count 
FROM property_offers AS po 
    JOIN properties AS p
		ON po.property_id = p.id
    JOIN cities AS c
		ON p.city_id = c.id
WHERE c.name = 'Vienna'
GROUP BY c.id; -- returns 10 

-- 11. Special Offer 15/15
DELIMITER $ 
CREATE PROCEDURE udp_special_offer(first_name VARCHAR(50))
BEGIN
	UPDATE property_offers AS po
    JOIN agents AS a
		ON po.agent_id = a.id AND a.first_name = first_name
    SET price = price * 0.9;
END $
DELIMITER ; 

SELECT 
	a.first_name, 
	po.agent_id,
    po.price, 
    po.price * 0.9
FROM property_offers AS po
	JOIN agents AS a
		ON po.agent_id = a.id AND a.first_name = 'Hans';