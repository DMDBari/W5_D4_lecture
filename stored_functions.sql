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





