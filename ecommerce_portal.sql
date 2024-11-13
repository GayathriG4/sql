mysql> CREATE DATABASE ecommerce_portal;
Query OK, 1 row affected (0.03 sec)

mysql> USE ecommerce_portal;
Database changed
mysql> CREATE TABLE user_profiles (
    ->     profile_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     full_name VARCHAR(255) NOT NULL,
    ->     email_address VARCHAR(255) UNIQUE NOT NULL,
    ->     home_address VARCHAR(255)
    -> );
Query OK, 0 rows affected (0.08 sec)

mysql> CREATE TABLE sales_records (
    ->     sales_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     profile_id INT,
    ->     sales_date DATE,
    ->     order_total DECIMAL(10, 2),
    ->     FOREIGN KEY (profile_id) REFERENCES user_profiles(profile_id)
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> CREATE TABLE product_listings (
    ->     listing_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     listing_name VARCHAR(255) NOT NULL,
    ->     listing_price DECIMAL(10, 2),
    ->     listing_description TEXT
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> INSERT INTO user_profiles (full_name, email_address, home_address) VALUES
    -> ('Alice', 'alice@example.com', '123 Maple St.'),
    -> ('Bob', 'bob@example.com', '456 Oak St.'),
    -> ('Charlie', 'charlie@example.com', '789 Pine St.');
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO sales_records (profile_id, sales_date, order_total) VALUES
    -> (1, '2024-10-15', 100.00),
    -> (2, '2024-11-10', 150.00),
    -> (3, '2024-11-11', 200.00);
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> SHOW TABLES;
+----------------------------+
| Tables_in_ecommerce_portal |
+----------------------------+
| product_listings           |
| sales_records              |
| user_profiles              |
+----------------------------+
3 rows in set (0.00 sec)

mysql> DESCRIBE user_profiles;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| profile_id    | int          | NO   | PRI | NULL    | auto_increment |
| full_name     | varchar(255) | NO   |     | NULL    |                |
| email_address | varchar(255) | NO   | UNI | NULL    |                |
| home_address  | varchar(255) | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> SELECT * FROM user_profiles;
+------------+-----------+---------------------+---------------+
| profile_id | full_name | email_address       | home_address  |
+------------+-----------+---------------------+---------------+
|          1 | Alice     | alice@example.com   | 123 Maple St. |
|          2 | Bob       | bob@example.com     | 456 Oak St.   |
|          3 | Charlie   | charlie@example.com | 789 Pine St.  |
+------------+-----------+---------------------+---------------+
3 rows in set (0.00 sec)

mysql> INSERT INTO product_listings (listing_name, listing_price, listing_description) VALUES
    -> ('Product A', 30.00, 'Description of Product A'),
    -> ('Product B', 20.00, 'Description of Product B'),
    -> ('Product C', 50.00, 'Description of Product C');
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> SELECT DISTINCT u.full_name
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id
    -> WHERE s.sales_date >= CURDATE() - INTERVAL 30 DAY;
+-----------+
| full_name |
+-----------+
| Alice     |
| Bob       |
| Charlie   |
+-----------+
3 rows in set (0.01 sec)

mysql> SELECT u.full_name, SUM(s.order_total) AS total_spent
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id
    -> GROUP BY u.full_name;
+-----------+-------------+
| full_name | total_spent |
+-----------+-------------+
| Alice     |      100.00 |
| Bob       |      150.00 |
| Charlie   |      200.00 |
+-----------+-------------+
3 rows in set (0.01 sec)

mysql> UPDATE product_listings
    -> SET listing_price = 45.00
    -> WHERE listing_name = 'Product C';
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> ALTER TABLE product_listings
    -> ADD COLUMN discount_rate DECIMAL(5, 2) DEFAULT 0.00;
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT listing_name, listing_price
    -> FROM product_listings
    -> ORDER BY listing_price DESC
    -> LIMIT 3;
+--------------+---------------+
| listing_name | listing_price |
+--------------+---------------+
| Product C    |         45.00 |
| Product A    |         30.00 |
| Product B    |         20.00 |
+--------------+---------------+
3 rows in set (0.00 sec)

mysql> SELECT DISTINCT u.full_name
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id
    -> JOIN order_details od ON s.sales_id = od.sales_id
    -> JOIN product_listings p ON od.listing_id = p.listing_id
    -> WHERE p.listing_name = 'Product A';
ERROR 1146 (42S02): Table 'ecommerce_portal.order_details' doesn't exist
mysql> SELECT DISTINCT u.full_name
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id
    -> JOIN order_details od ON s.sales_id = od.sales_id
    -> JOIN product_listings p ON od.listing_id = p.listing_id
    -> WHERE p.listing_name = 'Product A';
ERROR 1146 (42S02): Table 'ecommerce_portal.order_details' doesn't exist
mysql>
mysql> -- Create order_details table
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE TABLE order_details (
    ->     detail_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     sales_id INT,
    ->     listing_id INT,
    ->     quantity INT,
    ->     FOREIGN KEY (sales_id) REFERENCES sales_records(sales_id),
    ->     FOREIGN KEY (listing_id) REFERENCES product_listings(listing_id)
    -> );
Query OK, 0 rows affected (0.09 sec)

mysql> SELECT DISTINCT u.full_name
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id
    -> JOIN order_details od ON s.sales_id = od.sales_id
    -> JOIN product_listings p ON od.listing_id = p.listing_id
    -> WHERE p.listing_name = 'Product A';
Empty set (0.02 sec)

mysql> -- Retrieve each sales record with user name and date
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT u.full_name, s.sales_date
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id;
+-----------+------------+
| full_name | sales_date |
+-----------+------------+
| Alice     | 2024-10-15 |
| Bob       | 2024-11-10 |
| Charlie   | 2024-11-11 |
+-----------+------------+
3 rows in set (0.00 sec)

mysql>
mysql> SELECT sales_id, order_total
    -> FROM sales_records
    -> WHERE order_total > 150.00;
+----------+-------------+
| sales_id | order_total |
+----------+-------------+
|        3 |      200.00 |
+----------+-------------+
1 row in set (0.01 sec)

mysql> CREATE TABLE order_details (
    ->     detail_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     sales_id INT,
    ->     listing_id INT,
    ->     quantity INT,
    ->     FOREIGN KEY (sales_id) REFERENCES sales_records(sales_id),
    ->     FOREIGN KEY (listing_id) REFERENCES product_listings(listing_id)
    -> );
ERROR 1050 (42S01): Table 'order_details' already exists
mysql> DESCRIBE order_details;
+------------+------+------+-----+---------+----------------+
| Field      | Type | Null | Key | Default | Extra          |
+------------+------+------+-----+---------+----------------+
| detail_id  | int  | NO   | PRI | NULL    | auto_increment |
| sales_id   | int  | YES  | MUL | NULL    |                |
| listing_id | int  | YES  | MUL | NULL    |                |
| quantity   | int  | YES  |     | NULL    |                |
+------------+------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> DROP TABLE order_details;
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE order_details (
    ->     detail_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     sales_id INT,
    ->     listing_id INT,
    ->     quantity INT,
    ->     FOREIGN KEY (sales_id) REFERENCES sales_records(sales_id),
    ->     FOREIGN KEY (listing_id) REFERENCES product_listings(listing_id)
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql>
mysql> SELECT DISTINCT u.full_name
    -> FROM user_profiles u
    -> JOIN sales_records s ON u.profile_id = s.profile_id
    -> JOIN order_details od ON s.sales_id = od.sales_id
    -> JOIN product_listings p ON od.listing_id = p.listing_id
    -> WHERE p.listing_name = 'Product A';
Empty set (0.01 sec)

mysql> CREATE TABLE order_details (
    ->     detail_id INT AUTO_INCREMENT PRIMARY KEY,
    ->     sales_id INT,
    ->     listing_id INT,
    ->     quantity INT,
    ->     FOREIGN KEY (sales_id) REFERENCES sales_records(sales_id),
    ->     FOREIGN KEY (listing_id) REFERENCES product_listings(listing_id)
    -> );
ERROR 1050 (42S01): Table 'order_details' already exists
mysql> ALTER TABLE sales_records
    -> DROP COLUMN order_total;
Query OK, 0 rows affected (0.05 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> SELECT AVG(order_total) AS average_sales_total
    -> FROM sales_records;
ERROR 1054 (42S22): Unknown column 'order_total' in 'field list'
mysql> SELECT AVG(total_amount) AS average_sales_total
    -> FROM (
    ->     SELECT s.sales_id, SUM(od.quantity * p.listing_price) AS total_amount
    ->     FROM sales_records s
    ->     JOIN order_details od ON s.sales_id = od.sales_id
    ->     JOIN product_listings p ON od.listing_id = p.listing_id
    ->     GROUP BY s.sales_id
    -> ) AS order_totals;
+---------------------+
| average_sales_total |
+---------------------+
|                NULL |
+---------------------+
1 row in set (0.02 sec)

mysql> SELECT AVG(total_amount) AS average_sales_total
    -> FROM (
    ->     SELECT s.sales_id, SUM(od.quantity * p.listing_price) AS total_amount
    ->     FROM sales_records s
    ->     JOIN order_details od ON s.sales_id = od.sales_id
    ->     JOIN product_listings p ON od.listing_id = p.listing_id
    ->     GROUP BY s.sales_id
    -> ) AS order_totals;
+---------------------+
| average_sales_total |
+---------------------+
|                NULL |
+---------------------+
1 row in set (0.00 sec)

mysql> SELECT AVG(total_amount) AS average_sales_total
    -> FROM (
    ->     SELECT s.sales_id, SUM(od.quantity * p.listing_price) AS total_amount
    ->     FROM sales_records s
    ->     JOIN order_details od ON s.sales_id = od.sales_id
    ->     JOIN product_listings p ON od.listing_id = p.listing_id
    ->     GROUP BY s.sales_id
    -> ) AS order_totals;
+---------------------+
| average_sales_total |
+---------------------+
|                NULL |
+---------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM order_details;
Empty set (0.00 sec)

mysql> SELECT * FROM sales_records;
+----------+------------+------------+
| sales_id | profile_id | sales_date |
+----------+------------+------------+
|        1 |          1 | 2024-10-15 |
|        2 |          2 | 2024-11-10 |
|        3 |          3 | 2024-11-11 |
+----------+------------+------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM product_listings;
+------------+--------------+---------------+--------------------------+---------------+
| listing_id | listing_name | listing_price | listing_description      | discount_rate |
+------------+--------------+---------------+--------------------------+---------------+
|          1 | Product A    |         30.00 | Description of Product A |          0.00 |
|          2 | Product B    |         20.00 | Description of Product B |          0.00 |
|          3 | Product C    |         45.00 | Description of Product C |          0.00 |
+------------+--------------+---------------+--------------------------+---------------+
3 rows in set (0.00 sec)

mysql> SELECT s.sales_id, SUM(od.quantity * p.listing_price) AS total_amount

    -> FROM sales_records s
    -> JOIN order_details od ON s.sales_id = od.sales_id
    -> JOIN product_listings p ON od.listing_id = p.listing_id
    -> GROUP BY s.sales_id;
Empty set (0.00 sec)

mysql>
mysql> SELECT AVG(total_amount) AS average_sales_total
    -> FROM (
    ->     SELECT s.sales_id, SUM(COALESCE(od.quantity, 0) * COALESCE(p.listing_price, 0)) AS total_amount
    ->     FROM sales_records s
    ->     JOIN order_details od ON s.sales_id = od.sales_id
    ->     JOIN product_listings p ON od.listing_id = p.listing_id
    ->     GROUP BY s.sales_id
    -> ) AS order_totals;
+---------------------+
| average_sales_total |
+---------------------+
|                NULL |
+---------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM sales_records;
+----------+------------+------------+
| sales_id | profile_id | sales_date |
+----------+------------+------------+
|        1 |          1 | 2024-10-15 |
|        2 |          2 | 2024-11-10 |
|        3 |          3 | 2024-11-11 |
+----------+------------+------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM sales_records;
+----------+------------+------------+
| sales_id | profile_id | sales_date |
+----------+------------+------------+
|        1 |          1 | 2024-10-15 |
|        2 |          2 | 2024-11-10 |
|        3 |          3 | 2024-11-11 |
+----------+------------+------------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM order_details;
Empty set (0.00 sec)

mysql> SELECT * FROM product_listings;
+------------+--------------+---------------+--------------------------+---------------+
| listing_id | listing_name | listing_price | listing_description      | discount_rate |
+------------+--------------+---------------+--------------------------+---------------+
|          1 | Product A    |         30.00 | Description of Product A |          0.00 |
|          2 | Product B    |         20.00 | Description of Product B |          0.00 |
|          3 | Product C    |         45.00 | Description of Product C |          0.00 |
+------------+--------------+---------------+--------------------------+---------------+
3 rows in set (0.00 sec)

mysql> SELECT s.sales_id, SUM(COALESCE(od.quantity, 0) * COALESCE(p.listing_price, 0)) AS total_amount
    -> FROM sales_records s
    -> JOIN order_details od ON s.sales_id = od.sales_id
    -> JOIN product_listings p ON od.listing_id = p.listing_id
    -> GROUP BY s.sales_id;
Empty set (0.00 sec)

mysql>
mysql> INSERT INTO sales_records (profile_id, sales_date) VALUES (1, '2024-11-11');
Query OK, 1 row affected (0.02 sec)

mysql>
mysql> INSERT INTO order_details (sales_id, listing_id, quantity) VALUES (1, 1, 2);
Query OK, 1 row affected (0.00 sec)

mysql>
mysql> INSERT INTO product_listings (listing_name, listing_price, listing_description) VALUES
    -> ('Product A', 30.00, 'Description of Product A'),
    -> ('Product B', 20.00, 'Description of Product B');
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SELECT AVG(total_amount) AS average_sales_total
    -> FROM (
    ->     SELECT s.sales_id, SUM(COALESCE(od.quantity, 0) * COALESCE(p.listing_price, 0)) AS total_amount
    ->     FROM sales_records s
    ->     JOIN order_details od ON s.sales_id = od.sales_id
    ->     JOIN product_listings p ON od.listing_id = p.listing_id
    ->     GROUP BY s.sales_id
    -> ) AS order_totals;
+---------------------+
| average_sales_total |
+---------------------+
|           60.000000 |
+---------------------+
1 row in set (0.01 sec)
