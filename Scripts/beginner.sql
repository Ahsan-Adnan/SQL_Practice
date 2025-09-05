-- THis is a comment
/* USE MyDatabase
*/
-- Retrieve all customer data
SELECT *
FROM customers
-- RETRIEVE ALL ORDER DATA
SELECT *
FROM orders
-- RETRIEVE ALL CUSTOMERS NAME,COUNTRY,SCORE
SELECT first_name,country,score
FROM CUSTOMERS
-- RETRIEVE ALL SCORES THAT IS NOT EQUAL TO ZERO
SELECT *
FROM CUSTOMERS
WHERE score != 0
--RETRIEVE CUSTOMERS FROM GERMANY
SELECT *
FROM customers
WHERE country = 'Germany'
SELECT 
first_name,
country

FROM customers
WHERE country = 'Germany'
-- RETRIEVE CUSTOMERS DATA IN ORDER OF SCORE HIGHEST TO LOWEST
SELECT *
FROM CUSTOMERS
ORDER BY score DESC
SELECT *
FROM CUSTOMERS
ORDER BY country ASC , score DESC
-- FIND THE TOTAL SCORE FOR EACH COUNTRY
SELECT
country,
SUM(score) AS total_score
FROM CUSTOMERS
GROUP BY country 
-- FIND THE TOTAL SCORE AND TOTAL NUMBER OF CUSTOMERS USING SQL
SELECT country,
SUM(score) AS total_score,
COUNT(id) AS total_customer
FROM CUSTOMERS
GROUP BY country
/* FIND THE AVERAGE SCORE FOR EACH COUNTRY CONSIDERING ONLY CUSTOMERS WITH A SCORE NOT EQUAL TO 0 AND RETURN ONLY THOSE COUNTRIES WITH AN AVERAGE SCOE GREATER THAN 430*/
SELECT 
country,
AVG(score) as Avg_score
FROM customers
where score!=0
GROUP BY country
HAVING AVG(score) >430
-- Return unique list of all countries
SELECT DISTINCT country
FROM customers
-- Retrieve only three customers
SELECT TOP 3 *
FROM customers
-- Retrieve three customers with highest scores
SELECT TOP 3 *
FROM customers
ORDER BY score DESC
-- Retrieve the lowest two customers based on the score
SELECT TOP 2 *
FROM customers
ORDER BY score ASC
-- Get the two most recent order
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC
-- cool technique
SELECT 'Hello' AS static_query
-- Create a new tabele called persons with columns :id,person_name,birth_date,and phone
CREATE TABLE persons (
id INT NOT NULL,
person_name VARCHAR(50) NoT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
)
SELECT * FROM persons

-- Add anew column called email to the persons table
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL 

-- Remove the column phone from the persons table
ALTER TABLE persons
DROP COLUMN phone
SELECT * FROM persons
  -- Delete the table persons from database
--  DROP TABLE persons

  -- Data Manipulation
  INSERT INTO customers(id,first_name,country,score)
  VALUES
		(6,'Anna','USA',NULL),
		(7,'SAM',NULL,100)

SELECT * FROM customers
-- Insert data from 'customers' into 'persons'
INSERT INTO persons (id,person_name,birth_date,email)
SELECT 
id,
first_name,
NULL,
'Unknown'
FROM customers
 --change the score of customer 6 to 0
 UPDATE customers 
 SET score = 0
 WHERE id = 6
/* SELECT * 
 FROM customers
 WHERE id =6*/

 --Change the score of customer 10 to 0 and update the countery to UK
 UPDATE customers
 SET score =0,
 country = 'UK'
 WHERE id = 7

 SELECT *
 FROM customers

 -- Update all customers with a NULL score by setting their score to 0
Update customers 
SET score = 0
WHERE score IS NULL

SELECT *
FROM customers
WHERE score IS NULL

-- Delete all customers with an ID greater than 5
DELETE FROM customers
WHERE id>5

SELECT *
FROM customers
WHERE id>5

-- Delete all datea from table persons
--DELETE FROM persons
TRUNCATE TABLE persons

SELECT *
FROM persons
-- Retrieve all customers who are not from Germany
SELECT *
FROM customers
WHERE country <> 'Germany'
--Retrieve all customers with a score greater than 500
SELECT *
FROM customers
WHERE score >500
--Retrieve all customers with a score of 500 or more
SELECT * 
FROM customers
WHERE score>=500
--Retrieve all customers with a score less than 500
SELECT *
FROM customers
WHERE score < 500
--Retrieve all customers who are from USA and have a score greater than 500
SELECT *
FROM customers
WHERE country = 'Germany' AND score >250
--Retrieve all customers who are either from USA or have a score greater than 500
SELECT * 
FROM customers
WHERE country = 'USA' OR score > 500
-- Retrieve  all customers with a score not less than 500
SELECT *
FROM customers
WHERE NOT country = 'USA'
-- REtrieve all customers whos e score falls in the range between 100 and 500
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500
--Retrieve all customers from either Germany or USA
SELECT *
FROM customers
WHERE country IN ('GERMANY','USA')
-- Find all customers whose first name starts with 'M'
SELECT *
FROM customers
WHERE first_name LIKE 'M%'

SELECT *
FROM customers
WHERE first_name LIKE '%n'

SELECT * 
FROM customers
WHERE first_name LIKE '%r%'

SELECT * 
FROM customers 
WHERE first_name LIKE '__r%'

--Retrieve all data from customers and orders in two different results
SELECT *
FROM customers

SELECT *
FROM orders

--GET all customers along with their orders but only for customers who have placed an order
SELECT *
FROM customers
INNER JOIN orders
ON id = customer_id

SELECT 
c.id,
c.first_name,
o.order_id,
o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

--Get all customers along wiht their orders including those without orders
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- GET all customers along with their orders, including orders without matching customers
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id

-- GET all customers and all orders , even if there's no match
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

--Get all customers who haven't place any order
SELECT * 
FROM customers AS c 
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

--GET all orders without matching customers
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id =o.customer_id
WHERE c.id IS NULL

--FINd customers without orders and orders without customers 
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id =o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

--Get all cutomers along with their orders,but only for customers who have placed an order without using INNER JOIN
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id =o.customer_id
WHERE o.customer_id IS NOT NULL
AND c.id IS NOT NULL

--Generate all possible combinations of cutomers and orders
SELECT *
FROM customers 
CROSS JOIN orders

--Show a list of customers' first names together with their 
--country in one column
SELECT
first_name,
country,
CONCAT(first_name, ' ' ,country) AS name_country,
LOWER(first_name) AS low_name,
UPPER(first_name) AS UPP_name
FROM customers

--Find customers whose first name contains leading or trailing spaces
  SELECT 
  first_name,
  LEN(first_name) len_name,
  LEN(TRIM(first_name)) len_trim_name,
  LEN(first_name) - LEN(TRIM(first_name)) flag
  FROM customers
  WHERE LEN(first_name) != LEN(TRIM(first_name))

  -- Remove dashes from a phone number 
  SELECT
  '123-456-789' AS phone,
  REPLACE('123-456-7890' , '-', '') AS clean_phone
  --Replace file extence from txt to csv
  SELECT 
  'report.txt' AS old_filename,
  REPLACE('report.txt','.txt','.csv') AS new_filename
  --calculate the length of each customer's first name
  SELECT
  first_name,
  LEN(first_name) AS len_name
  FROM customers

  --Retrieve the first two characters of each first name
  SELECT
  first_name,
  LEFT(TRIM(first_name),2) first_2_char,
  RIGHT(first_name,2) last_2_char
  FROM customers
  --Retrieve a list of customer's first names after removing the first character
  SELECT 
  first_name,
  SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS sub_name
  FROM customers
  SELECT
  3.516,
  ROUND(3.516,2) AS round_2,
  ROUND(3.516,1) AS round_1,
  ROUND(3.516,0) AS round_0
  SELECT
  -10,
  ABS(-10),
  ABS(10)
