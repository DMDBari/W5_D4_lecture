-- Stored Functions

-- Example - We are often asked to get the count of actors who have a last name starting with _

-- Create a stored function that will return the count of actors with a last name starting with the given letter

CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor
	WHERE last_name ILIKE CONCAT(letter, '%');
	RETURN actor_count;
END;
$$;



-- execute the function - use select
SELECT get_actor_count('A');
SELECT GET_actor_count('b');


-- Stored function that returns a table

-- Example2 - We are often asked to provide a table of all customers that live in "country" with the first, last, address, city, district, and country

SELECT first_name, last_name, address, city, district, country
FROM customer c
JOIN address a 
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE country = 'India';

-- Write the above query into a function
CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR)
RETURNS TABLE (
	first_name VARCHAR,
	last_name VARCHAR,
	address VARCHAR,
	city VARCHAR,
	district VARCHAR,
	country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c
	JOIN address a
	ON c.address_id = a.address_id
	JOIN city ci
	ON a.city_id = ci.city_id
	JOIN country co
	ON ci.country_id = co.country_id
	WHERE co.country =  country_name;
END;
$$;


-- Execute a function that returns a table - use SELECT ... FROM function_name();
SELECT *
FROM customer_in_country('India');

SELECT *
FROM customer_in_country('Canada')
WHERE district = 'Ontario';

DROP FUNCTION customers_in_country;




-- Create a new procedure

ALTER TABLE customer
ADD COLUMN loyalty_member BOOLEAN;

UPDATE customer 
SET loyalty_member = FALSE;

SELECT *
FROM customer c
WHERE loyalty_member = False;


-- Create a Procedure that will make any customer who has spent >= $100 a loyalty member

-- step 1. Get the ids of customers who have spent >= $100
SELECT customer_id
FROM payment
GROUP BY customer_id 
HAVING sum(amount) >= 100;

-- Step 2. Write an update statement to set the above customers as loyalty_members
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id 
	HAVING sum(amount) >= 100
);

SELECT *
FROM customer c
WHERE loyalty_member = FALSE;

-- Step 3. Take Step 2 and put it into a Stored Procedure

CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id 
		HAVING sum(amount) >= 100
	);
END;
$$;



-- Execute a procedure - use CALL
CALL UPDATE_loyalty_status();

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;


-- Let's pretend that a user close to the threshold makes a new payment

SELECT customer_id, sum(amount)
FROM payment p 
GROUP BY customer_id 
HAVING sum(amount) BETWEEN 95 AND 100;


SELECT *
FROM customer c 
WHERE customer_id = 175

-- Add a new payment for customer 175 of 4.99
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (175, 1, 1, 4.99, '2024-03-21 12:02:30');

-- call the procedure again
CALL update_loyalty_status();

SELECT *
FROM customer c 
WHERE customer_id = 175;


-- Creating a procedure for inserting data

SELECT *
FROM actor;

SELECT now();

INSERT INTO actor(first_name, last_name, last_update)
VALUES ('Cillian', 'Murphy', NOW());

INSERT INTO actor(first_name, last_name, last_update)
values('Emma', 'Stone', NOW());

SELECT *
FROM actor a
ORDER BY actor_id DESC;


CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR, last_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	values(first_name, last_name, now());
END;
$$;


-- Add actors
CALL add_actor('Robert', 'Downey Jr.');
CALL add_actor('Florence', 'Pugh');

SELECT *
FROM actor
ORDER BY actor_id DESC;


-- To remove a procedure, use DROP PROCEDURE procedure_name
DROP PROCEDURE IF EXISTS update_loyalty_status;

