CREATE DATABASE exercise5; 

USE exercise5; 

-- 01. One-To-One Relationship 100/100 ATM
CREATE TABLE passports (
	passport_id INT PRIMARY KEY,
    passport_number VARCHAR(50)
);

CREATE TABLE people (
	id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT,
    first_name VARCHAR(50) NOT NULL,
    salary DECIMAL(7, 2),
    passport_id INT UNIQUE, 
    CONSTRAINT fk_people_passports
    FOREIGN KEY (passport_id)
    REFERENCES passports(passport_id)
); 

INSERT INTO passports (passport_id, passport_number)
VALUES
  (101, 'N34FG21B'),
  (102, 'K65LO4R7'),
  (103, 'ZE657QP2');

INSERT INTO people (person_id, first_name, salary, passport_id)
VALUES
  (1, 'Roberto', 43300, 102),
  (2, 'Tom', 56100, 103),
  (3, 'Yana', 60200, 101);

ALTER TABLE people
DROP COLUMN id, 
ADD PRIMARY KEY (person_id);

-- 2. One-To-Many Relationship 100/100
CREATE TABLE manufacturers (
	manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25),
    established_on DATE
); 

CREATE TABLE models (
	model_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(25),
    manufacturer_id INT,
    CONSTRAINT fk_models_manufacturers
    FOREIGN KEY (manufacturer_id)
    REFERENCES manufacturers(manufacturer_id)
); 

ALTER TABLE models AUTO_INCREMENT = 101; 

-- Insert data into the "manufacturers" table
INSERT INTO manufacturers (manufacturer_id, name, established_on)
VALUES
    (1, 'BMW', '1916-03-01'),
    (2, 'Tesla', '2003-01-01'),
    (3, 'Lada', '1966-05-01');

-- Insert data into the "models" table
INSERT INTO models (model_id, name, manufacturer_id)
VALUES
    (101, 'X1', 1),
    (102, 'i6', 1),
    (103, 'Model S', 2),
    (104, 'Model X', 2),
    (105, 'Model 3', 2),
    (106, 'Nova', 3);


-- TODO: INSERT THE DATA FROM THE TABLES

-- 3. Many-To-Many Relationship 100/100
CREATE TABLE students (
	student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(35)
);
 
CREATE TABLE exams (
	exam_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40)
); 

CREATE TABLE students_exams (
	student_id INT,
    exam_id INT,
    CONSTRAINT pk_students_exams
    PRIMARY KEY(student_id, exam_id),
    CONSTRAINT fk_students_exams_students
    FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    CONSTRAINT fk_students_exams_exams
    FOREIGN KEY (exam_id)
    REFERENCES exams(exam_id)
);

INSERT INTO students VALUES
(1, "Mila"),                                      
(2,	"Toni"),
(3,	"Ron"); 

INSERT INTO exams VALUES
(101, "Spring MVC"),
(102, "Neo4j"),
(103,	"Oracle 11g");

INSERT INTO students_exams VALUES 
(1,	101),
(1,	102),
(2,	101), 
(3,	103),
(2,	102),
(2,	103);

-- 4. Self-Referencing 100/100 
CREATE TABLE teachers (
	teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(35),
    manager_id INT,
    CONSTRAINT fk_teachers
    FOREIGN KEY (manager_id)
    REFERENCES teachers(teacher_id)
);  

INSERT INTO teachers(teacher_id, name) VALUES 
(101,	"John"),
(102,	"Maya"),
(103,	"Silvia"),
(104,	"Ted"),
(105,	"Mark"),
(106,	"Greta"); 

UPDATE teachers
SET manager_id = 106 
WHERE teacher_id IN (102, 103); 

UPDATE teachers
SET manager_id = 101 
WHERE teacher_id IN (105, 106);

UPDATE teachers
SET manager_id = 105 
WHERE teacher_id = 104;

-- 5. Online Store Database 100/100
CREATE DATABASE online_store;
 
USE online_store; 

CREATE TABLE cities (
	city_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
); 

CREATE table customers (
	customer_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    birthday DATE,
	city_id INT(11),
    CONSTRAINT fk_customers_cities
    FOREIGN KEY (city_id)
    REFERENCES cities(city_id)
); 

CREATE TABLE orders (
	order_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    customer_id INT(11) NOT NULL,
    CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
); 

CREATE TABLE item_types (
	item_type_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE items (
	item_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50), 
    item_type_id INT(11) NOT NULL, 
    CONSTRAINT fk_items_item_types
    FOREIGN KEY (item_type_id)
    REFERENCES item_types(item_type_id)
); 

CREATE TABLE order_items (
	order_id INT(11) NOT NULL,
    item_id INT(11) NOT NULL,
    CONSTRAINT pk_order_items
    PRIMARY KEY(order_id, item_id),
    CONSTRAINT fk_order_items_orders
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_items
    FOREIGN KEY (item_id)
    REFERENCES items(item_id)
);  

-- 06. University Database 100/100

CREATE TABLE subjects (
	subject_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(50)
); 

CREATE TABLE majors (
	major_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
); 

CREATE TABLE students (
	student_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(12),
    student_name VARCHAR(50),
    major_id INT, 
    CONSTRAINT fk_students_majors
    FOREIGN KEY (major_id)
    REFERENCES majors(major_id)
); 

CREATE TABLE payments (
	payment_id INT(11) PRIMARY KEY AUTO_INCREMENT, 
    payment_date DATE,
    payment_amount DECIMAL(8,2),
    student_id INT, 
    CONSTRAINT fk_payments_students 
    FOREIGN KEY (student_id)
    REFERENCES students(student_id)
); 

CREATE TABLE agenda(
	student_id INT(11),
    subject_id INT(11), 
    CONSTRAINT pk_agenda
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_agenda_students 
    FOREIGN KEY (student_id)
    REFERENCES students(student_id), 
    CONSTRAINT fk_agenda_subjects 
    FOREIGN KEY (subject_id)
    REFERENCES subjects(subject_id)
);

-- 7 and 8 DONE 

USE geography; 
-- 09. Peaks in Rila 100/100
SELECT mountain_range, peak_name, elevation as peak_elevation
FROM peaks as p
JOIN mountains as m
ON p.mountain_id = m.id
WHERE mountain_range = 'Rila'
ORDER BY peak_elevation DESC;
