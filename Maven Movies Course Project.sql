/* My partner and I want to come by each of the stores in person and meet the managers. Please send over 
the managers’ names at each store, with the full address of each property (street address, district, city, and 
country please) */

SELECT
	e.first_name,
    e.last_name,
    a.address,
    a.district,
    c.city,
    country.country
FROM staff AS e
	INNER JOIN store AS s
		ON e.staff_id = s.manager_staff_id
	INNER JOIN address AS a
		ON s.address_id = a.address_id
	INNER JOIN city AS c
		ON a.city_id = c.city_id
	INNER JOIN country
		ON c.country_id = country.country_id;

/* I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, the 
inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. */

SELECT -- should this be a SELECT DISTINCT? The table is cluttered.
	i.store_id AS store_id_number,
    i.inventory_id AS inventory_id,
    f.title AS film_name,
    f.rating AS film_rating,
    f.rental_rate AS rental_rate,
    f.replacement_cost AS replacement_cost
FROM inventory AS i
	INNER JOIN film AS f
    ON i.film_id = f.film_id;
    
/* From the same list of films you just pulled, please roll that data up and provide a summary level overview of 
your inventory. We would like to know how many inventory items you have with each rating at each store. */

SELECT
	i.store_id AS store_id_number,
    f.rating AS film_rating,
    COUNT(DISTINCT i.inventory_id) AS inventory_count
FROM inventory AS i
	INNER JOIN film AS f
    ON i.film_id = f.film_id
GROUP BY i.store_id, f.rating;

/* Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement 
cost, sliced by store and film category. */


SELECT 
	i.store_id AS store_id_number,
    cat.name AS category,
    COUNT(DISTINCT i.inventory_id) AS films,
    AVG(f.replacement_cost) AS avg_replacement_cost,
    SUM(f.replacement_cost) AS total_replacement_cost

FROM inventory AS i
	LEFT JOIN film AS f
		ON i.film_id = f.film_id
    LEFT JOIN film_category AS c
		ON f.film_id = c.film_id
	LEFT JOIN category AS cat
		ON c.category_id = cat.category_id
	
GROUP BY
		store_id, 
        category;

/* We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, and their full 
addresses – street address, city, and country. */

SELECT
	c.first_name,
    c.last_name,
    c.store_id,
    CASE 
		WHEN c.active = 1 THEN 'Active Customer'
        WHEN c.active = 0 THEN 'Inactive Customer'
        ELSE 'You have a code error here' 
        END AS customer_status,
    a.address,
    city.city,
    country.country
FROM customer AS c
	INNER JOIN address AS a
		ON c.address_id = a.address_id
	INNER JOIN city
		ON a.city_id = city.city_id
	INNER JOIN country
		ON city.country_id = country.country_id;

/* We would like to understand how much your customers are spending with you, and also to know who your 
most valuable customers are. Please pull together a list of customer names, their total lifetime rentals, and the 
sum of all payments you have collected from them. It would be great to see this ordered on total lifetime value, 
with the most valuable customers at the top of the list. */

SELECT
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_lifetime_rentals,
    SUM(p.amount) AS total_payments_taken
FROM
	customer AS c
    INNER JOIN rental AS r
		ON c.customer_id = r.customer_id
	INNER JOIN payment AS p
		ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY total_payments_taken DESC;

/* My partner and I would like to get to know your board of advisors and any current investors. Could you 
please provide a list of advisor and investor names in one table? Could you please note whether they are an 
investor or an advisor, and for the investors, it would be good to include which company they work with. */

SELECT
'advisor' AS type,
first_name,
last_name,
NULL AS company_name -- Adding a placeholder so colums match up
FROM advisor

UNION

SELECT
'investor' AS type,
first_name,
last_name,
company_name
FROM investor;

/* We're interested in how well you have covered the most-awarded actors. Of all the actors with three types of 
awards, for what % of them do we carry a film? And how about for actors with two types of awards? Same 
questions. Finally, how about actors with just one award? */

SELECT
	CASE
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony','Oscar,Tony') THEN '2 awards'
        ELSE '1 award'
	END AS number_of_awards,
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
    
FROM actor_award

GROUP BY
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
		WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony','Oscar,Tony') THEN '2 awards'
        ELSE '1 award'
	END
