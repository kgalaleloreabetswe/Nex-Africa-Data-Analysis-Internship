
CREATE TABLE superstore (
    row_id INTEGER,
    order_id VARCHAR(20),
    order_date Date,
    ship_date Date,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INTEGER,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

Select * From superstore

UPDATE superstore
SET
    sales = REPLACE(sales, ',', '.'),
    profit = REPLACE(profit, ',', '.'),
    discount = REPLACE(discount, ',', '.');

ALTER TABLE superstore
    ALTER COLUMN sales TYPE DECIMAL(10,2)
        USING sales::DECIMAL(10,2),

    ALTER COLUMN profit TYPE DECIMAL(10,2)
        USING profit::DECIMAL(10,2),

    ALTER COLUMN quantity TYPE INTEGER
        USING quantity::INTEGER,

    ALTER COLUMN discount TYPE DECIMAL(5,2)
        USING discount::DECIMAL(5,2);

-- ============================================================
-- WEEK 3 — PART A: PRODUCT ANALYSIS
-- ============================================================


-- 1. TOP 10 PRODUCTS BY SALES
-- ============================================================

SELECT
    product_name,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


-- 2. TOP 10 PRODUCTS BY PROFIT
-- ============================================================

SELECT
    product_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- 3. BOTTOM 10 PRODUCTS BY PROFIT
-- ============================================================

SELECT
    product_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;


-- 4. PRODUCTS WITH NEGATIVE PROFIT
-- ============================================================

SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


-- 5. SUB-CATEGORY ANALYSIS
-- Sales, Profit and Quantity
-- ============================================================

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM superstore
GROUP BY sub_category
ORDER BY total_sales DESC;


-- 6. SUB-CATEGORY ANALYSIS WITH PROFIT MARGIN
-- Additional useful metric
-- ============================================================

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0)) * 100,
        2
    ) AS profit_margin
FROM superstore
GROUP BY sub_category
ORDER BY total_profit DESC;


-- ============================================================
-- QUESTIONS TO ANSWER
-- ============================================================


-- 7. WHICH PRODUCT GENERATES THE MOST SALES?
-- ============================================================

SELECT
    product_name,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 1;


-- 8. WHICH PRODUCT GENERATES THE MOST PROFIT?
-- ============================================================

SELECT
    product_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 1;


-- 9. WHICH CATEGORY PERFORMS BEST?
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0)) * 100,
        2
    ) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;


-- 10. WHICH SUB-CATEGORY NEEDS ATTENTION?
-- ============================================================

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0)) * 100,
        2
    ) AS profit_margin
FROM superstore
GROUP BY sub_category
ORDER BY total_profit ASC;


-- ============================================================
-- ADDITIONAL PRODUCT INSIGHTS
-- ============================================================


-- 11. NUMBER OF LOSS-MAKING PRODUCTS
-- ============================================================

SELECT
    COUNT(*) AS loss_making_products
FROM (
    SELECT
        product_name,
        SUM(profit) AS total_profit
    FROM superstore
    GROUP BY product_name
    HAVING SUM(profit) < 0
) AS loss_products;


-- 12. LOSS-MAKING SUB-CATEGORIES
-- ============================================================

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


-- 13. MOST PROFITABLE SUB-CATEGORY
-- ============================================================

SELECT
    sub_category,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 1;


-- 14. MOST POPULAR SUB-CATEGORY BY QUANTITY
-- ============================================================

SELECT
    sub_category,
    SUM(quantity) AS total_quantity
FROM superstore
GROUP BY sub_category
ORDER BY total_quantity DESC
LIMIT 1;


-- 15. SALES VS PROFIT BY CATEGORY
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0)) * 100,
        2
    ) AS profit_margin
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- ============================================
-- WEEK 3 - PART B: CUSTOMER ANALYSIS
-- ============================================


-- 1. TOTAL NUMBER OF CUSTOMERS
-- ============================================

SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM superstore;


-- 2. SALES PER CUSTOMER
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC;


-- 3. ORDERS PER CUSTOMER
-- ============================================

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_orders DESC;


-- 4. PROFIT PER CUSTOMER
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC;


-- 5. AVERAGE CUSTOMER ORDER VALUE
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY average_order_value DESC;


-- 6. COMPLETE CUSTOMER ANALYSIS
-- ============================================
-- Combines sales, profit, orders, quantity
-- and average order value for each customer.

SELECT
    customer_id,
    customer_name,
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM superstore
GROUP BY
    customer_id,
    customer_name,
    segment
ORDER BY total_sales DESC;


-- 7. CUSTOMER SEGMENTATION
-- ============================================
-- Top 20%    = High-Value
-- Middle 60% = Medium-Value
-- Bottom 20% = Low-Value

WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        COUNT(DISTINCT order_id) AS total_orders
    FROM superstore
    GROUP BY customer_id, customer_name
),

ranked_customers AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY total_sales DESC
        ) AS sales_group
    FROM customer_sales
)

SELECT
    customer_id,
    customer_name,
    total_sales,
    total_profit,
    total_orders,
    CASE
        WHEN sales_group = 1 THEN 'High-Value'
        WHEN sales_group IN (2, 3, 4) THEN 'Medium-Value'
        WHEN sales_group = 5 THEN 'Low-Value'
    END AS customer_value_segment
FROM ranked_customers
ORDER BY total_sales DESC;


-- 8. CUSTOMER SEGMENT SUMMARY
-- ============================================
-- Shows how each customer segment contributes
-- to sales, profit and orders.

WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        COUNT(DISTINCT order_id) AS total_orders
    FROM superstore
    GROUP BY customer_id, customer_name
),

ranked_customers AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY total_sales DESC
        ) AS sales_group
    FROM customer_sales
),

segmented_customers AS (
    SELECT
        *,
        CASE
            WHEN sales_group = 1 THEN 'High-Value'
            WHEN sales_group IN (2, 3, 4) THEN 'Medium-Value'
            WHEN sales_group = 5 THEN 'Low-Value'
        END AS customer_value_segment
    FROM ranked_customers
)

SELECT
    customer_value_segment,
    COUNT(*) AS customer_count,
    SUM(total_sales) AS total_sales,
    SUM(total_profit) AS total_profit,
    SUM(total_orders) AS total_orders,
    ROUND(AVG(total_sales), 2) AS avg_customer_sales,
    ROUND(AVG(total_profit), 2) AS avg_customer_profit
FROM segmented_customers
GROUP BY customer_value_segment
ORDER BY
    CASE customer_value_segment
        WHEN 'High-Value' THEN 1
        WHEN 'Medium-Value' THEN 2
        WHEN 'Low-Value' THEN 3
    END;


-- ============================================
-- ADDITIONAL CUSTOMER INSIGHTS
-- ============================================


-- 9. TOP 10 CUSTOMERS BY SALES
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- 10. TOP 10 CUSTOMERS BY PROFIT
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC
LIMIT 10;


-- 11. CUSTOMERS WITH NEGATIVE PROFIT
-- ============================================

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY customer_id, customer_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


-- 12. TOP 10 CUSTOMERS BY NUMBER OF ORDERS
-- ============================================

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_orders DESC
LIMIT 10;


-- 13. TOP 10 CUSTOMERS BY AVERAGE ORDER VALUE
-- ============================================

SELECT
    customer_id,
    customer_name,
    ROUND(
        SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY average_order_value DESC
LIMIT 10;