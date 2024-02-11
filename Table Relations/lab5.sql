USE camp;

-- 1. Mountains and Peaks 100/100
CREATE TABLE mountains(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL 
); 

CREATE TABLE peaks(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    mountain_id INT, 
    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
); 

-- 2. Trip Organization 100/100
SELECT driver_id, 
vehicle_type, 
CONCAT(first_name, ' ', last_name) as driver_name
FROM vehicles AS v
JOIN campers AS c 
ON  v.driver_id = c.id; 

-- 3. SoftUni Hiking 100/100
SELECT starting_point AS route_starting_point, 
	end_point AS route_ending_point, 
    leader_id, 
    CONCAT(first_name, ' ', last_name) AS leader_name 
FROM campers as c
JOIN routes AS r
ON c.id = r.leader_id; 

-- 4. Delete Mountains 100/100
CREATE TABLE mountains(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL 
); 

CREATE TABLE peaks(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    mountain_id INT, 
    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (mountain_id)
    REFERENCES mountains(id)
    ON DELETE CASCADE
); 

-- 5. Project Management DB ; no tests in Judge
-- Not executed

CREATE DATABASE project_management; 

USE project_management; 

CREATE TABLE clients (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100)
); 

CREATE TABLE projects (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    client_id INT(11),
    project_leader_id INT(11),
    CONSTRAINT fk_projects_clients
    FOREIGN KEY (client_id)
    REFERENCES clients(id)
    ON DELETE CASCADE
); 

CREATE TABLE employees (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    project_id INT(11),
    CONSTRAINT fk_employees_projects
    FOREIGN KEY (project_id)
    REFERENCES projects(id)
    ON DELETE CASCADE
);
