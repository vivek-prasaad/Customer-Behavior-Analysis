create database Customer;
use Customer;
select * from customer_data
SELECT gender, SUM(purchase_amount) AS revenue
FROM Customer_data
GROUP BY gender;

SELECT customer_id, purchase_amount
FROM Customer_data
WHERE discount_applied = 'yes'
  AND purchase_amount >= (
      SELECT AVG(purchase_amount)
      FROM Customer_data
  );

SELECT 
    item_purchased,
    ROUND(AVG(review_rating), 2) AS average_product_rating
FROM Customer_data
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

SELECT 
    shipping_type,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase
FROM Customer_data
WHERE shipping_type IN ('standard', 'express')
GROUP BY shipping_type;

SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM Customer_data
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;

SELECT 
    item_purchased,
    ROUND(
        100 * SUM(CASE WHEN discount_applied = 'yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS discount_rate
FROM Customer_data
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

WITH customer_type AS (
    SELECT 
        customer_id,
        previous_purchases,
        CASE
            WHEN previous_purchases = 1 THEN 'new'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'returning'
            ELSE 'loyal'
        END AS customer_segment
    FROM Customer_data
)
SELECT 
    customer_segment,
    COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;

WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM Customer_data
    GROUP BY category, item_purchased
)
SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM Customer_data
WHERE previous_purchases > 5
GROUP BY subscription_status;

SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM Customer_data
GROUP BY age_group
ORDER BY total_revenue DESC;








