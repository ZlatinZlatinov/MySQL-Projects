USE book_library; 

-- 01. Find Book Titles 100/100
SELECT title FROM books
WHERE title LIKE 'The%';

-- 02. Replace Titles 100/100
SELECT REPLACE(title, 'The', '***') FROM books
WHERE title LIKE 'The%';  

-- 03. Sum Cost of All Books 100/100
SELECT FORMAT(SUM(cost), 2) as 'Total cost' 
FROM books; 

-- 04. Days Lived Not sure if correct, but still 100/100
SELECT CONCAT(first_name, " ", last_name) as 'Full Name',
DATEDIFF(died, born) as 'Days Lived'
FROM authors; 

-- 05. Harry Potter Books 100/100
SELECT title FROM books
WHERE title LIKE 'Harry Potter%';

