-- Challenge

-- Write SQL queries to perform the following tasks using the Sakila database:
USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT 
    film_id, COUNT(inventory_id)
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible')
GROUP BY film_id;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT 
    title
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film f
                JOIN
            film_actor fa ON f.film_id = fa.film_id
        WHERE
            title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_category
        WHERE
            category_id = (SELECT 
                    category_id
                FROM
                    sakila.category
                WHERE
                    name = 'Family'));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT 
    first_name, last_name, email
FROM
    sakila.customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            country co
                JOIN
            city ci ON co.country_id = ci.country_id
                JOIN
            address ad ON ad.city_id = ci.city_id
        WHERE
            country = 'Canada');

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            sakila.film_actor
        WHERE
            actor_id = (SELECT 
                    actor_id
                FROM
                    sakila.film_actor
                GROUP BY actor_id
                ORDER BY COUNT(film_id) DESC
                LIMIT 1));


-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            f.film_id
        FROM
            film f
                JOIN
            inventory i ON f.film_id = i.film_id
                JOIN
            rental r ON r.inventory_id = i.inventory_id
        WHERE
            customer_id = (SELECT 
                    customer_id
                FROM
                    sakila.payment
                GROUP BY customer_id
                ORDER BY SUM(amount) DESC
                LIMIT 1));

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT 
    customer_id, SUM(amount) AS total_amount
FROM
    payment
GROUP BY customer_id
HAVING total_amount > (SELECT 
        AVG(total_amount)
    FROM
        (SELECT 
            customer_id, SUM(amount) AS total_amount
        FROM
            payment
        GROUP BY customer_id) AS s1);


