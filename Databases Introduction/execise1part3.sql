-- CREATE DATABASE car_rental; 
-- 12. Car Rental Database 100/100 judge
USE car_rental; 

CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    category VARCHAR(50) NOT NULL, 
    daily_rate DOUBLE, 
    weekly_rate DOUBLE, 
    monthly_rate DOUBLE, 
    weekend_rate DOUBLE 
); 

CREATE TABLE cars (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    plate_number VARCHAR(10), 
    make VARCHAR(30), 
    model VARCHAR(50), 
    car_year YEAR, 
    category_id INT, 
    doors INT, 
    picture BLOB, 
    car_condition VARCHAR(25), 
    available BOOLEAN NOT NULL
); 

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    title VARCHAR(50), 
    notes TEXT
); 

CREATE TABLE customers (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    driver_licence_number INT NOT NULL, 
    full_name VARCHAR(110), 
    address VARCHAR(80), 
    city VARCHAR(80), 
    zip_code INT, 
    notes TEXT
);

CREATE TABLE rental_orders (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    employee_id INT, 
    customer_id INT, 
    car_id INT, 
    car_condition VARCHAR(35), 
    tank_level DOUBLE, 
    kilometrage_start INT, 
    kilometrage_end INT, 
    total_kilometrage INT, 
    start_date DATE, 
    end_date DATE, 
    total_days INT, 
    rate_applied DOUBLE, 
    tax_rate DOUBLE, 
    order_status VARCHAR(30), 
    notes TEXT
   ); 
   
INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES ('Economy', 35.99, 199.99, 799.99, 49.99),
('Compact', 45.99, 249.99, 999.99, 59.99),
('SUV', 59.99, 349.99, 1399.99, 79.99); 

INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, picture, car_condition, available)
VALUES ('ABC123', 'Toyota', 'Corolla', 2022, 1, 4, NULL, 'Excellent', TRUE),
('XYZ789', 'Honda', 'Civic', 2021, 2, 4, NULL, 'Good', TRUE),
('DEF456', 'Ford', 'Escape', 2020, 3, 5, NULL, 'Very Good', TRUE);

INSERT INTO employees (first_name, last_name, title, notes)
VALUES ('John', 'Doe', 'Manager', 'Experienced manager with a focus on customer satisfaction.'),
('Jane', 'Smith', 'Sales Associate', 'Enthusiastic sales professional with strong communication skills.'),
('Bob', 'Johnson', 'Mechanic', 'Certified mechanic specializing in vehicle maintenance.');

INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes)
VALUES (123456789, 'Alice Johnson', '123 Main St', 'Cityville', 12345, 'Frequent customer, reliable and punctual.'),
(987654321, 'Bob Smith', '456 Oak St', 'Townton', 54321, 'New customer, inquiring about long-term rental options.'),
(456789123, 'Charlie Davis', '789 Pine St', 'Villagetown', 67890, 'Corporate account, special billing instructions.');

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
VALUES (1, 1, 1, 'Clean', 80.0, 10000, 10250, 250, '2024-01-01', '2024-01-05', 5, 199.99, 0.1, 'Completed', 'Customer was satisfied with the rental.'),
(2, 2, 2, 'Average', 75.0, 8000, 8250, 250, '2024-02-10', '2024-02-15', 5, 249.99, 0.1, 'In Progress', 'Customer extended the rental by 2 days.'),
(3, 3, 3, 'Excellent', 90.0, 12000, 12300, 300, '2024-03-20', '2024-03-25', 5, 349.99, 0.1, 'Completed', 'Corporate rental, all conditions met.');


