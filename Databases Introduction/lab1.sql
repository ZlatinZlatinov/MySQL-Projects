-- CREATE DATABASE gamebar; 

USE gamebar; 
-- Task1 - Creating Tables, 100/100
CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);  

CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
); 

CREATE TABLE products (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL, 
    category_id INT NOT NULL
);  

-- Task2 - Data insertion 100/100
INSERT INTO employees(first_name, last_name)
VALUES ("John", "Cena"),
		("Stone", "Cold"),
        ("Dave", "Batista"); 
        
ALTER TABLE employees 
ADD middle_name VARCHAR(50) NOT NULL; 

-- Task 4, foreign key, 100/100
ALTER TABLE products 
ADD CONSTRAINT category_id
FOREIGN KEY(category_id) REFERENCES categories(id); 

-- ALTER TABLE products
-- ADD FOREIGN KEY (category_id) REFERENCES category(id); 

-- Task 5 modify collumn 100/100
ALTER TABLE employees
MODIFY middle_name VARCHAR(100) NOT NULL;



