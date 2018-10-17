-- Using Sakila Database 
use sakila;

-- Displaying the first and last names of the actors from the table actor.
SELECT first_name, last_name
FROM actor;

-- Displaying the first and last name of each actor in a one column with upper case letters and name the column Actor Name.
SELECT UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name'
FROM actor;

-- Retrieving the ID number of Joe
SELECT first_name, last_name, actor_id 
FROM actor
where first_name = 'Joe';

-- Displaying all actors whose last name contain the letters GEN
SELECT first_name, last_name, actor_id 
FROM actor
WHERE last_name LIKE '%Gen%';

-- Displaying all actors whose last names contain the letters LI
SELECT first_name, last_name, actor_id 
FROM actor
WHERE last_name LIKE '%Li%' 
ORDER BY last_name, first_name;

-- displaying the country_id and country columns for Afghanistan, Bangladesh, and China
SELECT country_id, country 
FROM country
WHERE country IN('Afghanistan','Bangladesh', 'China'); 


-- 4a. List and count actors last names 
SELECT DISTINCT
    last_name, COUNT(last_name) AS 'name_count'
FROM
    actor
GROUP BY last_name;


-- Listing and counting actors last names only for names that are shared by at least two actors
SELECT DISTINCT
    last_name, COUNT(last_name) AS 'name_count'
FROM
    actor
GROUP BY last_name 
HAVING name_count >= 2;

-- Updating actor's name 
UPDATE actor 
SET 
    first_name = 'HARPO'
WHERE
    first_name = 'GROUCHO'
        AND last_name = 'WILLIAMS';


-- -- Changing the first name to `MUCHO GROUCHO`
UPDATE actor 
SET 
    first_name = 
		CASE
        WHEN first_name = 'HARPO'
        THEN 'GROUCHO'
        ELSE 'MUCHO GROUCHO'
    END
WHERE
    actor_id = 172;

-- Displaying actor's first name, last names, address, city and postal code
SELECT actor.first_name, actor.last_name, address.address, address.city_id,
address.postal_code
FROM actor
JOIN address 
ON actor.actor_id = address.address_id;

-- Displaying staff's first names, last names and addresses 
SELECT first_name, last_name, address
FROM staff 
JOIN address 
ON staff.address_id = address.address_id;

-- Displaying staff's names and payment info
SELECT staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff 
JOIN payment  
ON staff.staff_id = payment.staff_id and payment_date like '2005-08%';

-- Dsiplaying film's actor IDs with their respective films
select film.title, film_actor.actor_id
from film 
inner join film_actor
on film.film_id = film_actor.actor_id;

-- Displaying film title like Hunchback Impossible
SELECT film.title
FROM film 
INNER JOIN inventory
ON film.film_id = inventory.film_id AND film.title LIKE 'Hunchback Impossible';

-- Displaying customers' payment info with their respective names
SELECT customer.first_name,customer.last_name,payment.amount
FROM customer 
JOIN payment 
ON customer.customer_id  = payment.customer_id
ORDER BY customer.last_name;

-- Displaying films that starts with "K" and "Q" whose language are English  
SELECT film.title
FROM film 
WHERE film.language_id IN (
		SELECT language.language_id
	   FROM language 
WHERE film.title like 'K%' OR film.title like 'Q%' AND language.name = "English");

-- Displaying film actor of Alone Trip 
SELECT film_actor.actor_id
from film_actor
where film_actor.actor_id in (
	SElECT film.film_id
	FROM film
	WHERE film.title = "Alone Trip");

-- Displaying customer first names, last names, emails who are based in Canada
SELECT customer.first_name, customer.Last_name, customer.email,country.country
FROM customer 
JOIN country
on customer.customer_id = country.country_id
WHERE country.country = "Canada";

-- Displaying film title which category is "family"
SELECT film.title, category.name
FROM film
JOIN category
ON film.film_id = category.category_id
WHERE category.name= "Family";

-- Counting most rented films in descending order 
SELECT film.title, COUNT(rental_id) AS 'Times Rented'
FROM rental 
JOIN inventory 
ON (rental.inventory_id = inventory.inventory_id)
JOIN film 
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY `Times Rented` DESC;

-- Revenue base on store ID 
SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

-- Display for each store, its store ID, city, and country 
SELECT store.store_id, city.city, country.country 
FROM store 
JOIN address  
ON (store.address_id = address.address_id)
JOIN city 
ON (city.city_id = address.city_id)
JOIN country
ON (country.country_id = city.country_id);

-- List the top five genres in gross revenue in descending order 
SELECT 
    name, SUM(p.amount) AS gross_revenue
FROM
    category c
        INNER JOIN
    film_category fc ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = fc.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        RIGHT JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- Creating the Top five genres by gross revenue
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS

SELECT 
    name, SUM(p.amount) AS gross_revenue
FROM
    category c
        INNER JOIN
    film_category fc ON fc.category_id = c.category_id
        INNER JOIN
    inventory i ON i.film_id = fc.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
        RIGHT JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- Viewing the Top five genres by gross revenu
SELECT * FROM top_five_genres;

-- Dropping the top five genres 
DROP VIEW top_five_genres;



