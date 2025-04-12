/* CREATE TABLE olist_customers */
SET sql_mode='';
DROP TABLE IF EXISTS `olist_customers`;
CREATE TABLE `olist_customers` (
  `customer_id` varchar(50) NOT NULL,
  `customer_unique_id` varchar(50) DEFAULT NULL,
  `customer_zip_code_prefix` int DEFAULT NULL,
  `customer_city` varchar(100) DEFAULT NULL,
  `customer_state` char(2) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_geolocation */
DROP TABLE IF EXISTS `olist_geolocation`;
CREATE TABLE `olist_geolocation` (
  `geolocation_zip_code_prefix` int DEFAULT NULL,
  `geolocation_lat` double DEFAULT NULL,
  `geolocation_lng` double DEFAULT NULL,
  `geolocation_city` varchar(100) DEFAULT NULL,
  `geolocation_state` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_order_items */
DROP TABLE IF EXISTS `olist_order_items`;
CREATE TABLE `olist_order_items` (
  `order_id` varchar(50) DEFAULT NULL,
  `order_item_id` int DEFAULT NULL,
  `product_id` varchar(50) DEFAULT NULL,
  `seller_id` varchar(50) DEFAULT NULL,
  `shipping_limit_date` datetime DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `freight_value` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_order_payments */
DROP TABLE IF EXISTS `olist_order_payments`;
CREATE TABLE `olist_order_payments` (
  `order_id` varchar(50) DEFAULT NULL,
  `payment_sequential` int DEFAULT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `payment_installments` int DEFAULT NULL,
  `payment_value` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_order_reviews */
DROP TABLE IF EXISTS `olist_order_reviews`;
CREATE TABLE `olist_order_reviews` (
  `review_id` varchar(50) NOT NULL,
  `order_id` varchar(50) DEFAULT NULL,
  `review_score` int DEFAULT NULL,
  `review_comment_title` text,
  `review_comment_message` text,
  `review_creation_date` date DEFAULT NULL,
  `review_answer_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`review_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_orders */
DROP TABLE IF EXISTS `olist_orders`;
CREATE TABLE `olist_orders` (
  `order_id` varchar(50) NOT NULL,
  `customer_id` varchar(50) DEFAULT NULL,
  `order_status` varchar(20) DEFAULT NULL,
  `order_purchase_timestamp` datetime DEFAULT NULL,
  `order_approved_at` datetime DEFAULT NULL,
  `order_delivered_carrier_date` datetime DEFAULT NULL,
  `order_delivered_customer_date` datetime DEFAULT NULL,
  `order_estimated_delivery_date` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_products */
DROP TABLE IF EXISTS `olist_products`;
CREATE TABLE `olist_products` (
  `product_id` varchar(50) NOT NULL,
  `product_category_name` varchar(100) DEFAULT NULL,
  `product_name_lenght` int DEFAULT NULL,
  `product_description_lenght` int DEFAULT NULL,
  `product_photos_qty` int DEFAULT NULL,
  `product_weight_g` int DEFAULT NULL,
  `product_length_cm` int DEFAULT NULL,
  `product_height_cm` int DEFAULT NULL,
  `product_width_cm` int DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE olist_sellers */
DROP TABLE IF EXISTS `olist_sellers`;
CREATE TABLE `olist_sellers` (
  `seller_id` varchar(50) NOT NULL,
  `seller_zip_code_prefix` int DEFAULT NULL,
  `seller_city` varchar(100) DEFAULT NULL,
  `seller_state` char(2) DEFAULT NULL,
  PRIMARY KEY (`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* CREATE TABLE product_category_name_translation */
DROP TABLE IF EXISTS `product_category_name_translation`;
CREATE TABLE `product_category_name_translation` (
  `product_category_name` varchar(100) DEFAULT NULL,
  `product_category_name_english` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Load olist_customers
LOAD DATA INFILE '/var/lib/mysql-files/olist_customers_dataset.csv'
INTO TABLE olist_customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

-- Load olist_geolocation
LOAD DATA INFILE '/var/lib/mysql-files/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state);

-- Load olist_order_items
LOAD DATA INFILE '/var/lib/mysql-files/olist_order_items_dataset.csv'
INTO TABLE olist_order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load olist_order_payments
LOAD DATA INFILE '/var/lib/mysql-files/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load olist_order_reviews
LOAD DATA INFILE '/var/lib/mysql-files/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load olist_orders
LOAD DATA INFILE '/var/lib/mysql-files/olist_orders_dataset.csv'
INTO TABLE olist_orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load olist_products
LOAD DATA INFILE '/var/lib/mysql-files/olist_products_dataset.csv'
INTO TABLE olist_products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load olist_sellers
LOAD DATA INFILE '/var/lib/mysql-files/olist_sellers_dataset.csv'
INTO TABLE olist_sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load product_category_name_translation
LOAD DATA INFILE '/var/lib/mysql-files/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;