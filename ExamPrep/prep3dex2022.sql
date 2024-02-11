CREATE DATABASE airlines; 
-- suuiiiii
USE airlines;

-- 01. Table Design 40/40
CREATE TABLE countries(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(30) NOT NULL UNIQUE, 
    description TEXT, 
    currency VARCHAR(5) NOT NULL
); 

CREATE TABLE airplanes (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    model VARCHAR(50) NOT NULL UNIQUE,
    passengers_capacity INT NOT NULL, 
    tank_capacity DECIMAL(19,2) NOT NULL,
    cost DECIMAL(19,2) NOT NULL
); 

CREATE TABLE passengers (
	id int PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(30), 
    last_name VARCHAR(30), 
    country_id INT NOT NULL, 
    CONSTRAINT fk_passenger_countries 
    FOREIGN KEY (country_id) 
    REFERENCES countries(id)
); 

CREATE TABLE flights (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    flight_code VARCHAR(30) NOT NULL UNIQUE,
    departure_country INT NOT NULL,
    destination_country INT NOT NULL, 
    airplane_id INT NOT NULL,
    has_delay BOOLEAN, 
    departure DATETIME, 
    CONSTRAINT fk_flights_countries1 
		FOREIGN KEY (departure_country) 
		REFERENCES countries(id), 
    CONSTRAINT fk_flights_countries2 
		FOREIGN KEY (destination_country) 
		REFERENCES countries(id),
    CONSTRAINT fk_flights_airplanes 
		FOREIGN KEY (airplane_id) 
		REFERENCES airplanes(id)
); 

CREATE TABLE flights_passengers(
	flight_id INT,
    passenger_id INT,
    KEY flights_passengers_key (flight_id, passenger_id),
    CONSTRAINT fk_fp_flights 
    FOREIGN KEY (flight_id)
    REFERENCES flights(id),
    CONSTRAINT fk_fp_passengers 
    FOREIGN KEY (passenger_id)
    REFERENCES passengers(id)
); 

-- 02. Insert 10/10
INSERT INTO airplanes (
	model,
    passengers_capacity, 
    tank_capacity, 
    cost
) SELECT (
	CONCAT(REVERSE(first_name), '797'), 
    CHAR_LENGTH(last_name) * 17,
    id * 790,
    CHAR_LENGTH(first_name) * 50.6
) FROM passengers
WHERE id <= 5;  

-- 03 UPDATE 10/10
UPDATE flights AS f
JOIN countries AS c 
ON f.departure_country = c.id AND name = 'Armenia'
SET airplane_id = airplane_id + 1; 
 
-- 04 DELETE 10/10
DELETE FROM flights 
WHERE id NOT IN (
	SELECT DISTINCT flight_id
    FROM flights_passengers); 
    
-- 05 Airplanes 10/10
SELECT * FROM airplanes 
ORDER BY cost DESC, id DESC;

-- 06 Flights from 2022 10/10 
SELECT 
	flight_code,
	departure_country,
	airplane_id,
	departure 
FROM flights 
WHERE YEAR(departure) = '2022'
ORDER BY airplane_id, flight_code 
LIMIT 20; 


-- 07 Private flights 10/10
SELECT 
	CONCAT(UPPER(SUBSTRING(last_name, 1, 2)), country_id) AS flight_code, 
    CONCAT(first_name, ' ', last_name) AS full_name,
    country_id 
FROM passengers 
WHERE id NOT IN (
	SELECT DISTINCT passenger_id
	FROM flights_passengers) 
ORDER BY country_id;  

-- 08 Leading destinations 10/10
SELECT 
	c.name,
    c.currency, 
    COUNT(fp.flight_id) AS booked_tickets 
FROM countries AS c 
	JOIN flights AS f
	ON c.id = f.destination_country
    JOIN flights_passengers AS fp 
    ON f.id = fp.flight_id AND passenger_id IS NOT NULL
GROUP BY c.id 
HAVING booked_tickets >= 20 
ORDER BY booked_tickets DESC; 

-- 09. Parts of the day 10/10 
SELECT 
	flight_code, 
    departure, 
    CASE 
		WHEN HOUR(departure) >= 5 AND HOUR(departure) < 12 THEN 'Morning'
        WHEN HOUR(departure) >= 12 AND HOUR(departure) < 17 THEN 'Afternoon'
        WHEN HOUR(departure) >= 17 AND HOUR(departure) < 21 THEN 'Evening'
        WHEN HOUR(departure) >= 21 OR HOUR(departure) < 5 THEN 'Night'
    END AS day_part
FROM flights 
ORDER BY flight_code DESC; 

SELECT DATETIME('2022-04-27 00:51:17'); 

-- 10. Number of flights 15/15
DELIMITER $ 
CREATE FUNCTION udf_count_flights_from_country(country VARCHAR(50)) 
RETURNS INT 
DETERMINISTIC 
BEGIN 
	RETURN (
    SELECT COUNT(c.id) AS count
	FROM countries AS c
		JOIN flights AS f 
		ON c.id = f.departure_country AND c.name = country
	GROUP BY c.id);
END $
DELIMITER ; 

SELECT COUNT(c.id) AS count
FROM countries AS c
JOIN flights AS f 
ON c.id = f.departure_country AND c.name = 'Brazil'
GROUP BY c.id; 

-- 11. Delay Flight 15/15 
DELIMITER $
CREATE PROCEDURE udp_delay_flight(f_code VARCHAR(50))
BEGIN 
	UPDATE flights 
    SET has_delay = 1, departure = ADDTIME(departure, "0:30:0") 
    WHERE flight_code = f_code;
END $
DELIMITER ;