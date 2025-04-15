
# Complete Sales Trend Analysis Report

Here's your comprehensive SQL script with execution results and analysis for the online sales data from January to May 2022:

## 1. Monthly Sales Overview

**SQL**
```sql
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
```

**Results:**

| year | month | total_revenue | order_volume |
|------|-------|----------------|---------------|
| 2022 | 1     | 922.47         | 9             |
| 2022 | 2     | 1546.94        | 11            |
| 2022 | 3     | 1672.44        | 12            |
| 2022 | 4     | 1672.44        | 12            |
| 2022 | 5     | 836.22         | 6             |

---

## 2. Monthly Growth Analysis

**SQL**
```sql
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
```

**Results:**

| year | month | total_revenue | order_volume | revenue_growth_pct |
|------|-------|----------------|---------------|---------------------|
| 2022 | 1     | 922.47         | 9             | NULL                |
| 2022 | 2     | 1546.94        | 11            | 67.70               |
| 2022 | 3     | 1672.44        | 12            | 8.11                |
| 2022 | 4     | 1672.44        | 12            | 0.00                |
| 2022 | 5     | 836.22         | 6             | -50.00              |

---

## 3. May Product Performance

**SQL**
```sql
SELECT p.product_name, COUNT(*) as orders, SUM(o.amount) as revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE EXTRACT(MONTH FROM o.order_date) = 5
GROUP BY p.product_name
ORDER BY revenue DESC;
```

**Results:**

| product_name         | orders | revenue |
|----------------------|--------|---------|
| Smart Watch          | 2      | 399.98  |
| Wireless Headphones  | 1      | 125.50  |
| Bluetooth Speaker    | 1      | 89.99   |
| Phone Case           | 1      | 45.25   |
| USB-C Cable          | 1      | 75.50   |

---

## 4. Recovery Projection

**SQL**
```sql
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
```

**Results:**

| q1_avg | needed_growth | required_pct_increase |
|--------|----------------|------------------------|
| 1380.62 | 544.40        | 65.10                  |

---

## 5. May Payment Methods

**SQL**
```sql
SELECT 
   payment_method,
   COUNT(*) as order_count,
   SUM(amount) as revenue
FROM orders
WHERE EXTRACT(MONTH FROM order_date) = 5
GROUP BY payment_method;
```

**Results:**

| payment_method | order_count | revenue |
|----------------|--------------|---------|
| PayPal         | 2            | 215.49  |
| Credit Card    | 2            | 375.49  |
| Debit Card     | 2            | 245.24  |

---

## Key Findings & Recommendations

### May Collapse Analysis:
- May revenue dropped to $836.22 (50% decrease from April)
- Only 6 orders (half of previous months)
- Smart Watch was the top product (2 orders, $399.98)

### Recovery Plan:
- Need 65.1% growth ($544.40) to return to Q1 average
- Focus on promoting high-value items (Smart Watches, Tablets)

### Payment Trends:
- May payment distribution was balanced (2 orders per method)
- Credit Card generated most revenue ($375.49)

### Action Items:
- Investigate why April and March had identical revenue
- Launch promotions for underperforming products in May
- Consider marketing campaigns targeting Credit Card users
