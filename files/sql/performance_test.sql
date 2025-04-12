-- Fjah1872 - Basic Aggregation Checks

-- Fjah1872 Test 1.1: Count of all orders placed
SELECT COUNT(*) FROM olist_orders;

-- Fjah1872 Test 1.2: Total payment amount received
SELECT SUM(payment_value) FROM olist_order_payments;

-- Fjah1872 Test 1.3: Average value per payment transaction
SELECT AVG(payment_value) FROM olist_order_payments;

-- Fjah1872 Test 1.4: Distribution of order statuses
SELECT order_status, COUNT(*) 
FROM olist_orders 
GROUP BY order_status;

-- Fjah1872 - Advanced Aggregation Queries

-- Fjah1872 Test 2.1: Revenue grouped by payment method
SELECT payment_type, SUM(payment_value) as total_revenue
FROM olist_order_payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- Fjah1872 Test 2.2: State-wise average order value
SELECT c.customer_state, AVG(op.payment_value) as avg_order_value
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN olist_order_payments op ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY avg_order_value DESC;

-- Fjah1872 Test 2.3: Top 10 categories by items sold
SELECT p.product_category_name, COUNT(oi.order_item_id) as items_sold
FROM olist_products p
JOIN olist_order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;

-- Fjah1872 - Time-Based Metrics

-- Fjah1872 Test 3.1: Order count per calendar month
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') as month,
    COUNT(*) as order_count
FROM olist_orders
GROUP BY month
ORDER BY month;

-- Fjah1872 Test 3.2: Mean delivery duration in days
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) as avg_delivery_days
FROM olist_orders
WHERE order_delivered_customer_date IS NOT NULL;

-- Fjah1872 Test 3.3: Monthly revenue generation
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') as month,
    SUM(op.payment_value) as total_revenue
FROM olist_orders o
JOIN olist_order_payments op ON o.order_id = op.order_id
GROUP BY month
ORDER BY month;

-- Fjah1872 - Filtered Insights & Comparative Analysis

-- Fjah1872 Test 4.1: Top 10% high-value payments
SET @offset := FLOOR((SELECT COUNT(*) FROM olist_order_payments) * 0.9);

SET @sql := CONCAT('
  SELECT payment_value INTO @p90
  FROM olist_order_payments
  ORDER BY payment_value
  LIMIT 1 OFFSET ', @offset
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT o.order_id, op.payment_value
FROM olist_orders o
JOIN olist_order_payments op ON o.order_id = op.order_id
WHERE op.payment_value > @p90
ORDER BY op.payment_value DESC
LIMIT 100;

-- Fjah1872 Test 4.2: Products with high average margins
SELECT 
    p.product_id,
    p.product_category_name,
    AVG(oi.price) as avg_price,
    AVG(oi.freight_value) as avg_freight,
    AVG(oi.price - oi.freight_value) as avg_profit
FROM olist_products p
JOIN olist_order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_category_name
HAVING avg_profit > 100
ORDER BY avg_profit DESC
LIMIT 20;

-- Fjah1872 - Correlation & Relationships

-- Fjah1872 Test 5.1: Average payment by review score tier
SELECT 
    AVG(CASE WHEN r.review_score >= 4 THEN op.payment_value ELSE NULL END) as high_rating_avg_value,
    AVG(CASE WHEN r.review_score < 4 THEN op.payment_value ELSE NULL END) as low_rating_avg_value
FROM olist_orders o
JOIN olist_order_payments op ON o.order_id = op.order_id
JOIN olist_order_reviews r ON o.order_id = r.order_id;

-- Fjah1872 Test 5.2: Review score vs delivery speed
SELECT 
    AVG(CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) <= 7 
        THEN r.review_score ELSE NULL END) as fast_delivery_avg_score,
    AVG(CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) > 7 
        THEN r.review_score ELSE NULL END) as slow_delivery_avg_score
FROM olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL;

-- Fjah1872 - Index Optimization

-- Fjah1872 Test 6.1: Index creation for payment value
CREATE INDEX indx_payment_val ON olist_order_payments(payment_value);

-- Fjah1872 Test 6.2: Using index for high-value payments
SELECT * FROM olist_order_payments WHERE payment_value > 1000 LIMIT 100;

-- Fjah1872 Test 6.3: Composite index on order_id & payment sequence
CREATE INDEX indx_order_payment ON olist_order_payments(order_id, payment_sequential);

-- Fjah1872 Test 6.4: Quick lookup using composite index
SELECT * FROM olist_order_payments WHERE order_id = 'e481f51cbdc54678c7cc91f6eeb20c99';

-- Fjah1872 - Customer & Seller Metrics

-- Fjah1872 Test 7.1: Lifetime value for each customer
SELECT 
    c.customer_id,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(op.payment_value) as total_spent,
    AVG(op.payment_value) as avg_order_value
FROM olist_customers c
JOIN olist_orders o ON c.customer_id = o.customer_id
JOIN olist_order_payments op ON o.order_id = op.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 20;

-- Fjah1872 Test 7.2: Seller performance breakdown
SELECT 
    s.seller_id,
    COUNT(DISTINCT oi.order_id) as order_count,
    COUNT(oi.order_item_id) as item_count,
    SUM(oi.price) as total_revenue,
    AVG(oi.price) as avg_item_price
FROM olist_sellers s
JOIN olist_order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 20;

-- Fjah1872 - Window Function Experiments

-- Fjah1872 Test 8.1: Running total of payments over time
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    op.payment_value,
    SUM(op.payment_value) OVER (ORDER BY o.order_purchase_timestamp) as running_total
FROM olist_orders o
JOIN olist_order_payments op ON o.order_id = op.order_id
ORDER BY o.order_purchase_timestamp
LIMIT 100;

-- Fjah1872 Test 8.2: Revenue-based seller rankings
SELECT 
    s.seller_id,
    SUM(oi.price) as total_revenue,
    RANK() OVER (ORDER BY SUM(oi.price) DESC) as revenue_rank
FROM olist_sellers s
JOIN olist_order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY revenue_rank
LIMIT 20;
