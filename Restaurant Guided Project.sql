/* The first step in the project asked me to look at the menu_items table
and then find the number of items on the menu */

SELECT *
FROM menu_items;

SELECT COUNT(*)
FROM menu_items;

SELECT -- Show list of items, 
	item_name,
	price
FROM menu_items
/* In the following line, you can remove "DESC" to order min to maximum
in order to find the lowest priced item instead of the highest priced
item*/
ORDER BY price DESC;

/* The next question in the assignment asks us to find the count of Italian menu
items and then to find the most and least expensive Italian items on the menu. */

SELECT
	COUNT(*)
FROM menu_items
WHERE category = 'Italian';

SELECT
	item_name,
    price
FROM menu_items
WHERE
	category = 'Italian'
ORDER BY price DESC; -- Again, you can remove DESC or change to ASC

/* The next question is to find out how many dishes are in each category,
and then the average dish price within each category */

SELECT
	category,
    COUNT(menu_item_id) AS number_of_options
FROM menu_items
GROUP BY category;

SELECT
	category,
    COUNT(menu_item_id) AS number_of_options,
    ROUND(AVG(price),2) AS avg_category_price
FROM menu_items
GROUP BY category;

/* The next set of exercises follows the order_details table. I will begin this
exercise by viewing the entire table to review how the data looks. */

SELECT *
FROM order_details;

-- View the order_details table. What is the date range of this table?

SELECT
	MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
FROM order_details;

-- How many orders were made within this date range?

SELECT COUNT(DISTINCT order_id) AS number_of_orders
FROM order_details;

-- How many items were ordered within this date range?

SELECT COUNT(*) AS number_of_items
FROM order_details;

-- Which orders had the most items?

SELECT
	order_id,
    COUNT(item_id) AS number_of_items
FROM order_details
GROUP BY order_id
ORDER BY number_of_items DESC;

-- How many orders had more than 12 items?

SELECT
	order_id,
    COUNT(item_id) AS number_of_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12;

/* The next set of questions combines both tables and involves writing
queries about those tables. */

-- Combine the menu_items and order_details tables into a single table.

SELECT *
FROM order_details AS o
LEFT JOIN menu_items AS m
	ON o.item_id = m.menu_item_id;
    
-- What were the least and most ordered items? What categories were they in?

SELECT
    m.item_name,
    m.category,
    COUNT(o.order_details_id) AS ordered_items
FROM
    order_details AS o
LEFT JOIN menu_items AS m
	ON o.item_id = m.menu_item_id
GROUP BY
    m.item_name, m.category
ORDER BY
    ordered_items DESC -- can remove DESC to get lowest ordered items
LIMIT 10; -- to keep results from being overwhelming

-- What were the top 5 orders that spent the most money?

SELECT
	o.order_id AS id,
    SUM(price) AS total_price
FROM order_details AS o
LEFT JOIN menu_items AS m
	ON o.item_id = m.menu_item_id
GROUP BY id
ORDER BY total_price DESC -- can remove DESC to get lowest 5
LIMIT 5; -- Top 5 orders

-- View the details of the highest spend order. Which specific items were purchased?

SELECT
	category,
    order_id,
    COUNT(o.item_id) AS number_of_items
FROM order_details AS o
LEFT JOIN menu_items AS m
	ON o.item_id = m.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675) -- top 5 orders or WHERE order_id = 440
GROUP BY order_id,category;
