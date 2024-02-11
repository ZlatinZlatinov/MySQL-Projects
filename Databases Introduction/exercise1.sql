CREATE DATABASE minions; 

USE minions; 

-- 01. Create Tables 100/100
CREATE TABLE minions (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50),
    age INT
); 

CREATE TABLE towns (
    town_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50)
); 

-- 02. Also
ALTER TABLE towns 
RENAME COLUMN town_id
to id; 

-- 02. Alter Minions Table 100/100
ALTER TABLE minions
ADD COLUMN town_id INT NOT NULL,
ADD FOREIGN KEY (town_id) REFERENCES towns(id);

-- 03. Insert Records in Both Tables 100/100, dea i Judgeto
INSERT INTO towns (id, name) VALUES 
(1, "Sofia"),
(2, "Plovdiv"),
(3, "Varna"); 

INSERT INTO minions (id, name, age, town_id) VALUES 
(1, "Kevin", 22, 1),
(2, "Bob", 15, 3),
(3, "Steward", NULL, 2); 

-- 04. Truncate Table Minions 100/100
-- DELETE FROM minions; -- Clears all the data from the table. Not executed

-- 05. Drop All Tables 100/100
-- DROP TABLE minions; -- both not executed
-- DROP TABLE towns; -- drops/deletes the tables 

-- 06. Create Table People 100/100
CREATE TABLE people (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(200) NOT NULL,
picture BLOB,
height double(3, 2),
weight double(5, 2),
gender CHAR(2) NOT NULL,
birthdate DATE NOT NULL,
biography TEXT
); 

INSERT INTO people (name, picture, height, weight, gender, birthdate, biography) VALUES
('John Doe', NULL, 1.75, 70.2, 'M', '1990-05-15', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
('Jane Smith', NULL, 1.68, 55.7, 'F', '1985-08-22', 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
('Bob Johnson', NULL, 1.80, 85.1, 'M', '1982-11-10', 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.'),
('Alice Brown', NULL, 1.63, 58.9, 'F', '1995-03-30', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore.'),
('Chris Davis', NULL, 1.78, 75.5, 'M', '1988-07-05', 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');

-- 07. Create Table Users 100/100
CREATE TABLE users (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) UNIQUE NOT NULL,
password VARCHAR(26) NOT NULL,
profile_picture BLOB,
last_login_time DATE, -- can be timestamp
is_deleted BOOLEAN
); 

INSERT INTO users(username, password, profile_picture, last_login_time, is_deleted) VALUES
('john_doe', 'hashed_password_1', NULL, '2024-01-13', FALSE),
('jane_smith', 'hashed_password_2', NULL, '2024-01-12', FALSE),
('bob_johnson', 'hashed_password_3', NULL, '2024-01-11', FALSE),
('alice_brown', 'hashed_password_4', NULL, '2024-01-10', TRUE),
('chris_davis', 'hashed_password_5', NULL, '2024-01-09', FALSE); 

-- 08. Change Primary Key 100/100
ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY pk_users (id, username); 

-- 9. Set Default Value of a Field 100/100
ALTER TABLE users
MODIFY COLUMN last_login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP(); 

-- 10. Set Unique Field 100/100 (needs to modify column username if not already unique)
ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY pk_users (id);
