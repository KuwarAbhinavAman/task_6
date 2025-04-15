
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM 
    orders
WHERE 
    order_date BETWEEN '2022-01-01' AND '2022-05-31'
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    year ASC,
    month ASC;
    
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(amount) AS total_revenue,
        COUNT(DISTINCT order_id) AS order_volume
    FROM 
        orders
    WHERE 
        order_date BETWEEN '2022-01-01' AND '2022-05-31'
    GROUP BY 
        EXTRACT(YEAR FROM order_date),
        EXTRACT(MONTH FROM order_date)
)
SELECT *,
    (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month)) / 
    LAG(total_revenue) OVER (ORDER BY year, month) * 100 AS revenue_growth_pct
FROM monthly_sales
ORDER BY year, month;

-- Check May orders by product
SELECT p.product_name, COUNT(*) as orders, SUM(o.amount) as revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE EXTRACT(MONTH FROM o.order_date) = 5
GROUP BY p.product_name
ORDER BY revenue DESC;

-- Projected June revenue needed to return to Q1 levels
SELECT 
   AVG(total_revenue) as q1_avg,
   (AVG(total_revenue) - 836.22) as needed_growth,
   ((AVG(total_revenue) - 836.22) / 836.22 * 100) as required_pct_increase
FROM (
   SELECT SUM(amount) as total_revenue
   FROM orders
   WHERE EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 3
   GROUP BY EXTRACT(MONTH FROM order_date)
) q1_months;


-- Check if payment preferences changed in May
SELECT 
   payment_method,
   COUNT(*) as order_count,
   SUM(amount) as revenue
FROM orders
WHERE EXTRACT(MONTH FROM order_date) = 5
GROUP BY payment_method;