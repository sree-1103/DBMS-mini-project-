SELECT o.order_id, SUM(oi.product_price - oi.selling_price) AS total_amount_saved
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY total_amount_saved DESC;

SELECT product_name
FROM products
ORDER BY demand DESC
LIMIT 10;

SELECT supplier_name
FROM suppliers
WHERE supplier_id IN (
  SELECT supplier_id
  FROM product_suppliers
  WHERE product_id IN (
    SELECT product_id
    FROM products
    WHERE product_name IN (
      SELECT product_name
      FROM products
      ORDER BY demand DESC
      LIMIT 10
    )
  )
);


SELECT c.customer_name, s.supplier_name
FROM customers c
JOIN suppliers s ON c.country = s.country;


SELECT c.customer_name
FROM customers c
LEFT JOIN suppliers s ON c.country = s.country
WHERE s.supplier_id IS NULL;


SELECT s.supplier_name
FROM suppliers s
LEFT JOIN customers c ON s.country = c.country
WHERE c.customer_id IS NULL;

CREATE VIEW supplier_sales AS
SELECT s.supplier_id, s.supplier_name, p.product_id, p.product_name, oi.quantity, oi.selling_price
FROM suppliers s
JOIN product_suppliers ps ON s.supplier_id = ps.supplier_id
JOIN products p ON ps.product_id = p.product_id
JOIN order_items oi ON p.product_id = oi.product_id;
SELECT supplier_name, SUM(total_sales) AS total_sales
FROM (
  SELECT supplier_name, product_name, SUM(quantity * selling_price) AS total_sales,
    ROW_NUMBER() OVER (PARTITION BY supplier_name ORDER BY total_sales DESC) AS rank
  FROM supplier_sales
  GROUP BY supplier_name, product_name
) AS subquery
WHERE rank <= 2
GROUP BY supplier_name
ORDER BY total_sales DESC;


SELECT p.product_name, s.supplier_name, s.country
FROM products p
JOIN product_suppliers ps ON p.product_id = ps.product_id
JOIN suppliers s ON ps.supplier_id = s.supplier_id
WHERE p.country <> s.country AND p.country = 'UK'
ORDER BY p.product_name;


CREATE TABLE customer (
  id INT PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  phone VARCHAR(255) NOT NULL
);
CREATE TABLE customer_backup (
  id INT PRIMARY KEY,
  first