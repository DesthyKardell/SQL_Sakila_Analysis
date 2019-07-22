USE sakila;

# 1a. Displaying the first and last names of all actors from the table actor
SELECT first_name, last_name
FROM actor;

# 1b. Displaying the first and last name of each actor in a single column named Actor_Name
USE sakila;
SELECT concat(first_name, " ", last_name) AS Actor_Name
FROM actor;

# 2a. Displaying the ID number, first name, 
# and last name of an actor whose first name is "Joe." 
USE Sakila;
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

# 2b. Finding all actors whose last name contain the letters GEN
USE sakila;
SELECT * FROM actor
WHERE last_name LIKE '%GEN%';

# 2c. Finding all actors whose last names contain the letters LI. 
# Ordering results by last name and first name
USE sakila;
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

# 2d. Displaying the country_id  
# of the following countries: Afghanistan, Bangladesh, and China:
USE sakila;
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a. Altering the Actor table to add a Description Field. 
USE sakila;
ALTER TABLE actor
ADD Description BLOB;
SELECT * FROM actor;

# 3b. Deleting the Description column previously created
USE sakila;
ALTER TABLE actor
DROP COLUMN Description;
SELECT * FROM actor;

# 4a. Listing the last names of actors, 
# as well as how many actors have that last name.
USE sakila;
SELECT last_name, COUNT(last_name) as "Count of Last Name"
FROM actor
GROUP BY last_name;

# 4b. Listing last names of actors and the number of actors 
# who have that last name, but only for names that are shared by at least two actors
USE sakila;
SELECT last_name, COUNT(last_name) as "Count of Last Name"
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

# 4c. Writing a query to change actor name.
# It was accidently entered as GROUCHO WILLIAMS but should be HARPO WILLIAMS
USE sakila;
UPDATE actor
SET first_name='HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
SELECT * FROM actor;

# 4d. Reversing 4c by changing first name to GROUCHO from HARPO 
USE sakila;
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';
SELECT * FROM actor;

# 5a. Rebuilding the address table, which I am unable to recreate. 
USE sakila;
Describe address;
# By using SHOW create table, I will be able to see the syntax of the table
# and recreate it. Below is a sample of columns and syntaxes
SHOW CREATE TABLE address;
CREATE TABLE address (
  address_id SMALLINT(5) unsigned NOT NULL auto_increment,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT(5) unsigned NOT NULL);
  
# 6a. Displaying the first and last names, as of well as addresses
# of each staff member, using JOIN on tables staff and address:
USE sakila;
SELECT first_name, last_name, address
FROM staff as s
INNER JOIN address as a
ON s.address_id = a.address_id;

# 6b. Displaying the total amount rung up by each staff members using JOIN
# on tables staff and payment
USE sakila;
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff as s
INNER JOIN payment as p
ON s.staff_id = p.staff_id
GROUP BY p.staff_id;

# 6c. Listing each film and the number of actors 
# who are listed for that film. Using Inner Join on tables film_actor and film
USE sakila;
SELECT f.title, COUNT(fa.actor_id)
FROM film as f
INNER JOIN film_actor as fa
ON f.film_id = fa.film_id
GROUP BY f.title;

# 6d. Displaying the number of copies of the film "Hunchback Impossible" in the inventory system?
USE sakila;
SELECT f.title, COUNT(i.inventory_id)
FROM film as f
INNER JOIN inventory as i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

#6e. Using the tables payment and customer and the JOIN command, 
# listing the total paid by each customer. 
# Listing the customers alphabetically by last name:
USE sakila;
SELECT c.first_name, c.last_name, SUM(p.amount) as 'Total Amount Paid'
FROM customer as c
INNER JOIN payment as p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

# 7a. The music of Queen and Kris Kristofferson 
# have seen an unlikely resurgence. As an unintended consequence, 
# films starting with the letters K and Q have also soared in popularity. 
# Using subqueries to display the titles of movies starting with the letters K and Q 
# whose language is English.
USE sakila;
SELECT title FROM film
WHERE language_id in
	(SELECT language_id
    FROM language
    WHERE name = 'English')
AND (title like 'K%') OR (title LIKE 'Q%');

# 7b. Using subqueries to display all actors
#  who appear in the film "Alone Trip"
USE sakila;
SELECT first_name, last_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
    WHERE film_id in
		(SELECT film_id FROM film
        WHERE title = "Alone Trip"));
	
# 7c. Displaying names and email addresses of all canadian customers
# Using joins to retrieve this information
USE sakila;
SELECT c.first_name, c.last_name, c.email
FROM customer as c
INNER JOIN address as a ON c.address_id = a.address_id
INNER JOIN city as ci ON a.city_id = ci.city_id
INNER JOIN country as co ON ci.country_id = co.country_id WHERE country = 'Canada';

# 7d. Identifying all movies categorized as family films to conduct a promotion.
# Sales have been lagging among young families, 
USE sakila;
SELECT title 
FROM film
WHERE film_id in
	(SELECT film_id FROM film_category 
    WHERE category_id in
		(SELECT category_id FROM category 
        WHERE name = 'family'));
        
# 7e. Displaying the most frequently rented movies in descending order
USE sakila;
SELECT i.film_id, f.title, COUNT(r.inventory_id)
FROM inventory as i
INNER JOIN rental as r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text as f 
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

# 7f. Writing a query to display how much business,
# in dollars, each store brought in
USE sakila;
SELECT store.store_id, SUM(payment.amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment
ON payment.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(payment.amount);

# 7g. Writing a query to display for each store 
# its store ID, city, and country
USE sakila;
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id;

# 7h. Listing the top five genres in gross revenue 
# in descending order. (Use the following tables:
# category, film_category, inventory, payment, and rental.)
USE sakila;
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.customer_id = payment.customer_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

# 8a. Creating a View using 7h.
# Scenario: In my new role as an executive, I would like
# to have an easy way of viewing the Top five genres by gross revenue. 

USE sakila;

CREATE VIEW top_five_genres_revenues AS
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.customer_id = payment.customer_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

# 8b. Displaying the view created in 8a
SELECT * FROM top_five_genres_revenues;

# 8c. Query to delete view created above: top_five_genres. 
DROP VIEW top_five_genres_revenues;


