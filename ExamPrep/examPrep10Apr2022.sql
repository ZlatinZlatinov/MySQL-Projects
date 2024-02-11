CREATE DATABASE softuni_imdb; 

USE softuni_imdb; 
-- 01. Table Design 40/40
CREATE TABLE countries ( 
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
	continent VARCHAR(30) NOT NULL, 
	currency VARCHAR(5) NOT NULL
); 

CREATE TABLE genres (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
); 

CREATE TABLE actors ( 
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL, 
	birthdate DATE NOT NULL,
	height INT,
	awards INT,
	country_id INT NOT NULL, 
    CONSTRAINT fk_actors_countries 
    FOREIGN KEY (country_id) 
    REFERENCES countries(id)
); 

CREATE TABLE movies_additional_info (
	id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(10, 2) NOT NULL,
	runtime INT NOT NULL,
	picture_url VARCHAR(80) NOT NULL,
	budget DECIMAL(10, 2),
	release_date DATE NOT NULL,
	has_subtitles BOOLEAN,
	description TEXT
); 

CREATE TABLE movies (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(70) NOT NULL UNIQUE,
	country_id INT,
	movie_info_id INT NOT NULL UNIQUE, 
    CONSTRAINT fk_movies_countries 
    FOREIGN KEY (country_id)
    REFERENCES countries(id), 
    CONSTRAINT fk_movies_movies_additional_info 
    FOREIGN KEY (movie_info_id)
    REFERENCES movies_additional_info(id)
); 

CREATE TABLE movies_actors (
	movie_id INT, 
    actor_id INT, 
    KEY k_movies_actors (movie_id, actor_id),
    CONSTRAINT movies_actors_movies 
    FOREIGN KEY (movie_id)
    REFERENCES movies(id),
    CONSTRAINT movies_actros_actors 
    FOREIGN KEY (actor_id)
    REFERENCES actors(id)
); 

CREATE TABLE genres_movies (
	genre_id INT,
	movie_id INT, 
    KEY k_genres_movies (genre_id, movie_id), 
    CONSTRAINT fk_genres_movies_genres 
    FOREIGN KEY (genre_id)
    REFERENCES genres(id), 
    CONSTRAINT fk_genres_movies_movies 
    FOREIGN KEY (movie_id)
    REFERENCES movies(id)
); 

-- 02. Insert 10/10
INSERT INTO actors (
	first_name,
	last_name,
	birthdate,
	height,
	awards,
	country_id) 
SELECT 
	REVERSE(first_name),
    REVERSE(last_name), 
    SUBDATE(birthdate, INTERVAL 2 DAY),
    (height + 10), 
    country_id, 
    (SELECT id FROM countries WHERE name = 'Armenia') 
FROM actors WHERE id <= 10; 

-- 03. Update 10/10
UPDATE movies_additional_info 
SET runtime = runtime - 10
WHERE id BETWEEN 15 AND 25; 

-- 04. Delete 10/10
DELETE from countries 
WHERE id NOT IN (
	SELECT DISTINCT country_id FROM movies
); 

-- 05. Countries 
SELECT * FROM countries
ORDER BY currency DESC, id; 

-- 06 Old movies 10/10
SELECT 
	m.id, 
    m.title, 
    maf.runtime,
    maf.budget, 
    maf.release_date 
FROM movies AS m 
	JOIN movies_additional_info AS maf
		ON m.movie_info_id = maf.id
WHERE YEAR(maf.release_date) BETWEEN 1996 AND 1999 
ORDER BY maf.runtime, m.id 
LIMIT 20; 

-- 07. Movie Casting 10/10
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(REVERSE(last_name), CHAR_LENGTH(last_name), '@cast.com') AS email,
    CEIL(DATEDIFF('2022-01-01', birthdate) / 365) AS age,
    height
FROM actors 
WHERE id NOT IN (
SELECT DISTINCT actor_id FROM movies_actors
) ORDER BY height; 

-- 08. International festival 10/10
SELECT 
	c.name, 
    COUNT(m.id) AS movies_count 
FROM countries AS c
	JOIN movies AS m 
		ON c.id = m.country_id 
GROUP BY c.id
HAVING movies_count >= 7
ORDER BY c.name DESC; 

-- 09. Rating system 10/10
SELECT 
	m.title, 
    CASE
    WHEN maf.rating <= 4 THEN 'poor'
    WHEN maf.rating <= 7 THEN 'good'
    WHEN maf.rating > 7 THEN 'excellent'
    END AS rating,
    IF(maf.has_subtitles = 1, 'english', '-'),
    maf.budget 
FROM movies AS m 
	JOIN movies_additional_info AS maf 
		ON m.movie_info_id = maf.id
ORDER BY maf.budget DESC; 

-- 10. History movies 15/15
DELIMITER $ 
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50)) 
RETURNS INT
DETERMINISTIC 
BEGIN
	RETURN (
		SELECT 
			COUNT(gm.movie_id) AS history_movies
		FROM genres_movies AS gm
			JOIN movies AS m
				ON gm.movie_id = m.id
			JOIN genres AS g
				ON gm.genre_id = g.id AND g.name = 'History'
			JOIN movies_actors AS ma
				ON ma.movie_id = m.id
			JOIN actors AS a
				ON ma.actor_id = a.id
		WHERE CONCAT(a.first_name, ' ', a.last_name) = full_name
		GROUP BY a.id);
END $
DELIMITER ; 

SELECT 
	COUNT(gm.movie_id) AS history_movies
FROM genres_movies AS gm
	JOIN movies AS m
		ON gm.movie_id = m.id
	JOIN genres AS g
		ON gm.genre_id = g.id AND g.name = 'History'
	JOIN movies_actors AS ma
		ON ma.movie_id = m.id
	JOIN actors AS a
		ON ma.actor_id = a.id
WHERE CONCAT(a.first_name, ' ', a.last_name) = 'Stephan Lundberg'
GROUP BY a.id; 

-- 11. Movie awards 15/15 
DELIMITER $ 
CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50))
BEGIN
	UPDATE actors AS a
    JOIN movies_actors AS ma
		ON ma.actor_id = a.id 
	JOIN movies AS m
		ON ma.movie_id = m.id AND m.title = movie_title 
    SET awards = awards + 1;
     
END $
DELIMITER ;