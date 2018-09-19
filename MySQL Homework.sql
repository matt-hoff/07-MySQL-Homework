USE sakila;

-- 1a.
SELECT * FROM actor;

-- 1b.
SELECT CONCAT(first_name, ' ',  last_name) AS 'Actor Name'
FROM actor;

-- 2a.
SELECT *
FROM actor
WHERE first_name = 'joe';

-- 2b.
SELECT *
FROM actor
WHERE last_name like '%gen%';

-- 2c.
SELECT last_name, first_name
FROM actor
WHERE last_name like '%li%'
ORDER BY last_name, first_name;

-- 2d.
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a.
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

-- 3b.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a.
SELECT last_name, count(last_name) AS 'Count'
FROM actor 
GROUP BY last_name;

-- 4b.
SELECT last_name, COUNT(last_name) AS 'Count'
FROM actor 
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- 4c.
UPDATE actor
SET first_name = REPLACE(first_name, 'GROUCHO', 'HARPO')
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

-- 4d.
SET SQL_SAFE_UPDATES = 0;

UPDATE actor
SET first_name = REPLACE(first_name, 'GROUCHO', 'HARPO')
WHERE first_name='GROUCHO';

SET SQL_SAFE_UPDATES = 1;

-- 5a.
DESCRIBE address;

-- 6a.
SELECT address.address_id, staff.last_name, staff.first_name
FROM address 
RIGHT JOIN staff ON 
address.address_id = staff.address_id;

-- 6b.
SELECT payment.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS 'total_rung_up (Aug 2005)'
FROM payment
RIGHT JOIN staff ON 
payment.staff_id = staff.staff_id
WHERE payment_date like '%2005-08%'
GROUP BY staff_id;

-- 6c.
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) AS 'number of actors'
FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY film_id;

-- 6d.
SELECT title, COUNT(Inventory_id) AS 'Copies of Film'
FROM inventory
JOIN film ON 
inventory.film_id = film.film_id
WHERE title like 'Hunchback Impossible'
GROUP BY title;

SELECT * FROM inventory
WHERE flim_id = 439;

-- 6e.
SELECT payment.customer_id, customer.last_name, customer.first_name, SUM(payment.amount) AS 'total_paid_by_customer'
FROM payment
JOIN customer ON 
payment.customer_id = customer.customer_id
GROUP BY customer_id
ORDER BY last_name;

-- 7a.
SELECT title
FROM film
WHERE title LIKE 'Q%' OR title LIKE 'K%' AND language_id
IN (
		SELECT language_id
        FROM language
        WHERE name = 'English');

-- 7b.
SELECT first_name, last_name
FROM actor
WHERE actor_id
IN (
		SELECT actor_id
        FROM film_actor
        WHERE film_id
        IN (
				SELECT film_id
                FROM film
                WHERE title = 'Alone Trip'
		)
	);

-- 7c.
SELECT country.country, first_name, last_name, email
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.address_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country like 'Canada';

-- 7d.
SELECT title, category.name
FROM film 
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE name like 'Family';

-- 7e.
SELECT title, COUNT(rental.inventory_id)
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY COUNT(rental.inventory_id) DESC;

-- 7f.
SELECT store.store_id, SUM(payment.amount)
FROM payment
JOIN customer ON customer.customer_id = payment.customer_id
JOIN store ON store.store_id = customer.store_id
GROUP BY store_id
ORDER BY SUM(payment.amount) DESC;

-- 7g.
SELECT store_id, city.city, country.country
FROM store 
JOIN address ON store.address_id = address.address_id
JOIN city ON address.address_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- 7h.
SELECT name, SUM(payment.amount)
FROM category 
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8a.
CREATE VIEW top_five_genres AS 
SELECT name, SUM(payment.amount)
FROM category 
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8b.
SELECT * FROM top_five_genres;

-- 8c.
DROP VIEW top_five_genres;
