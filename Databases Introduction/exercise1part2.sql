CREATE DATABASE movies; 

USE movies; 

CREATE TABLE directors(
	id INT PRIMARY KEY AUTO_INCREMENT, 
    director_name VARCHAR(80) NOT NULL, 
    notes TEXT
);

CREATE TABLE genres(
id INT PRIMARY KEY AUTO_INCREMENT,
genre_name VARCHAR(40) NOT NULL,
notes TEXT
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL,
notes TEXT
);

CREATE TABLE movies(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(100) NOT NULL, 
director_id INT NOT NULL, 
copyright_year INT NOT NULL, 
length INT NOT NULL, 
genre_id INT NOT NULL, 
category_id INT NOT NULL, 
rating DEC(4,2), 
notes TEXT, 
FOREIGN KEY (director_id) REFERENCES directors(id),
FOREIGN KEY (genre_id) REFERENCES genres(id),
FOREIGN KEY (category_id) REFERENCES categories(id)
); 
-- remove  foreing keys, and use for foreign key, just double, year/time, for 100
-- Directors
INSERT INTO directors (director_name, notes) VALUES
('Christopher Nolan', 'Renowned for his work on Inception and The Dark Knight trilogy.'),
('Quentin Tarantino', 'Famous for Pulp Fiction and Kill Bill series.'),
('Greta Gerwig', 'Known for directing Lady Bird and Little Women.'),
('Martin Scorsese', 'Acclaimed director of Taxi Driver and Goodfellas.'),
('Ava DuVernay', 'Director of Selma and 13th documentary.');

-- Genres
INSERT INTO genres (genre_name, notes) VALUES
('Action', 'Movies with intense physical activity and thrilling plot.'),
('Drama', 'Focused on realistic storytelling and character development.'),
('Science Fiction', 'Explores futuristic concepts and scientific themes.'),
('Comedy', 'Designed to be humorous and provide laughter.'),
('Mystery', 'Involves suspense and solving a puzzle or crime.');

-- Categories
INSERT INTO categories (category_name, notes) VALUES
('Adventure', 'Movies that take the audience on a journey or quest.'),
('Romance', 'Focuses on love and romantic relationships.'),
('Horror', 'Intended to scare, frighten, or invoke fear.'),
('Documentary', 'Presents factual information and real events.'),
('Fantasy', 'Involves elements of magic, supernatural, or imaginary worlds.');

-- Movies
INSERT INTO movies (title, director_id, copyright_year, length, genre_id, category_id, rating, notes) VALUES
('Inception', 1, 2010, 148, 1, 3, 8.7, 'Mind-bending thriller with stunning visuals.'),
('Pulp Fiction', 2, 1994, 154, 2, 4, 8.9, 'Quirky and nonlinear storytelling.'),
('Lady Bird', 3, 2017, 94, 2, 5, 7.4, 'Coming-of-age drama-comedy.'),
('Taxi Driver', 4, 1976, 113, 2, 1, 8.3, 'Psychological thriller film.'),
('Selma', 5, 2014, 128, 1, 2, 7.5, 'Historical drama about the 1965 Selma to Montgomery marches.');
