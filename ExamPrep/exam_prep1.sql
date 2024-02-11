CREATE DATABASE universities; 

USE universities; 

CREATE TABLE countries (
    id INT AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    PRIMARY KEY (id)
); 

CREATE TABLE cities (
    id INT AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    population INT,
    country_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (country_id)
        REFERENCES countries (id)
); 

CREATE TABLE universities (
    id INT AUTO_INCREMENT,
    name VARCHAR(60) NOT NULL UNIQUE,
    address VARCHAR(80) NOT NULL UNIQUE,
    tuition_fee DECIMAL(19 , 2 ) NOT NULL,
    number_of_staff INT,
    city_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
); 

CREATE TABLE students (
    id INT AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    age INT,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    is_graduated BOOLEAN NOT NULL,
    city_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (city_id)
        REFERENCES cities (id)
); 

CREATE TABLE courses (
    id INT AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    duration_hours DECIMAL(19 , 2 ),
    start_date DATE,
    teacher_name VARCHAR(60) NOT NULL UNIQUE,
    description TEXT,
    university_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (university_id)
        REFERENCES universities (id)
); 

CREATE TABLE students_courses (
    grade DECIMAL(19 , 2 ) NOT NULL,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    KEY `pk_students_courses` (student_id , course_id),
    CONSTRAINT `fk_students_courses_students` FOREIGN KEY (student_id)
        REFERENCES students (id),
    CONSTRAINT `fk_students_courses_courses` FOREIGN KEY (course_id)
        REFERENCES courses (id)
); 

-- 02 Insert

-- 10/10
INSERT INTO courses (
	name, 
	duration_hours,
    start_date,
    teacher_name,
    description,
    university_id)
SELECT 
	(CONCAT(c.teacher_name, ' course')) cn, 
	CHAR_LENGTH(c.name) / 10,
    DATE(c.start_date + 5),
    REVERSE(c.teacher_name),
    CONCAT('Course ', c.teacher_name, REVERSE(c.description)),
    DAY(c.start_date)
FROM courses AS c
WHERE c.id <= 5; 

-- 03. Update 10/10
UPDATE universities 
SET tuition_fee = tuition_fee + 300 
WHERE id BETWEEN 5 AND 12;  

-- 04. Delete 10/10
DELETE FROM universities 
WHERE number_of_staff IS NULL; 

-- 05. Cities 10/10
SELECT * FROM cities
ORDER BY population DESC; 

-- 06. Students age 10/10
SELECT 
	first_name, 
    last_name,
    age,
    phone,
    email 
FROM students 
WHERE age >= 21 
ORDER BY first_name DESC, email, id
LIMIT 10; 

-- 07. New students 10/10
SELECT 
	CONCAT(first_name, ' ', last_name) AS full_name,
    SUBSTRING(email, 2, 10) AS username,
    REVERSE(phone) AS password
FROM students 
WHERE id NOT IN(
	SELECT DISTINCT student_id FROM students_courses
) 
ORDER BY password DESC; 

-- 08. Students count 10/10
SELECT 
	COUNT(s.id) AS students_count, 
    u.name AS university_name 
FROM students AS s
	JOIN students_courses AS sc
		ON s.id = sc.student_id
	JOIN courses AS c
		ON sc.course_id = c.id
	JOIN universities AS u
		ON c.university_id = u.id
GROUP BY u.id
	HAVING students_count >= 8
ORDER BY students_count DESC, university_name DESC; 

-- 09. Price rankings 10/10
SELECT 
	u.name, 
    c.name, 
    u.address, 
    CASE 
		WHEN u.tuition_fee < 800 THEN 'cheap'
        WHEN u.tuition_fee < 1200 THEN 'normal'
        WHEN u.tuition_fee < 2500 THEN 'high'
        WHEN u.tuition_fee >= 2500 THEN 'expensive'
    END AS price_rank, 
    u.tuition_fee
FROM universities AS u
	JOIN cities AS c
		ON u.city_id = c.id
ORDER BY u.tuition_fee; 


-- 10. Average grades 15/15
DELIMITER $ 
	CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60)) 
    RETURNS DECIMAL(19, 2)
    READS SQL DATA
    BEGIN 
		RETURN (SELECT 
    SUM(sc.grade) / COUNT(sc.course_id) as averr
FROM courses AS c
	JOIN students_courses AS sc 
    ON c.id = sc.course_id AND c.name = course_name 
    JOIN students AS s 
    ON sc.student_id = s.id
WHERE s.is_graduated = 1
GROUP BY c.id);
    END $
DELIMITER ; 


SELECT 
	c.name, 
    SUM(sc.grade) / COUNT(sc.course_id) as averr
FROM courses AS c
	JOIN students_courses AS sc 
    ON c.id = sc.course_id AND c.name = 'Quantum Physics' 
    JOIN students AS s 
    ON sc.student_id = s.id
WHERE s.is_graduated = 1
GROUP BY c.id;

-- 11. Graduate students 15/15
DELIMITER $ 
CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
BEGIN 
	UPDATE students AS s
	JOIN students_courses AS sc 
		ON s.id = sc.student_id
    JOIN courses AS c 
		ON sc.course_id = c.id AND YEAR(c.start_date) = year_started
	SET s.is_graduated = 1;
END $ 
DELIMITER ; 

SELECT 
	s.first_name, 
    s.is_graduated, 
    c.name,
    c.start_date 
FROM students AS s
	JOIN students_courses AS sc 
		ON s.id = sc.student_id AND s.is_graduated = 0
    JOIN courses AS c 
		ON sc.course_id = c.id;

-- siuuuu