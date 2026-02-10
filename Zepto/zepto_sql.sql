use zepto;

-- deleting the table if exist
drop table zepto;
drop table zepto_v2;

-- --creating table
CREATE TABLE zepto (
    sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock VARCHAR(10),   -- TEMPORARY (important)
    quantity INT
);

show tables;

-- --data cleaning
SELECT * FROM zepto
WHERE mrp = 0;

DELETE FROM zepto
WHERE sku_id IN (
    SELECT sku_id
    FROM (
        SELECT sku_id
        FROM zepto
        WHERE mrp = 0
    ) AS temp
);

SELECT * FROM zepto
WHERE mrp = 0;

--- -convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

---- Data Exploration
select * from zepto;

DESCRIBE zepto;

-- --count of rows
select count(*) from zepto;

-- --sample data
SELECT * FROM zepto
LIMIT 10;

-- Checking for the duplicates
SELECT name, COUNT(*) AS duplicate_count
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;


-- --null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- --different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- --product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

-- Products Count by Category
SELECT category, COUNT(*) AS product_count
FROM zepto
GROUP BY category
ORDER BY product_count DESC;

-- --products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- price range analysis
SELECT
    MIN(mrp) AS min_mrp,
    MAX(mrp) AS max_mrp,
    AVG(mrp) AS avg_mrp
FROM zepto;

-- Discount Distribution
SELECT
    MIN(discountPercent) AS min_discount,
    MAX(discountPercent) AS max_discount,
    AVG(discountPercent) AS avg_discount
FROM zepto;

-- Validate discount logic
SELECT name, mrp, discountedSellingPrice
FROM zepto
WHERE discountedSellingPrice > mrp;

-- High Discount products
SELECT  name, category, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Low stock products
SELECT name, availableQuantity
FROM zepto
WHERE availableQuantity < 10
ORDER BY availableQuantity ASC;

-- Weight Distribution
SELECT
    MIN(weightInGms) AS min_weight,
    MAX(weightInGms) AS max_weight,
    AVG(weightInGms) AS avg_weight
FROM zepto;

-- Products by weight range
SELECT
    CASE
        WHEN weightInGms <= 250 THEN 'Small Pack'
        WHEN weightInGms BETWEEN 251 AND 1000 THEN 'Medium Pack'
        ELSE 'Large Pack'
    END AS weight_category,
    COUNT(*) AS product_count
FROM zepto
GROUP BY weight_category;

-- Outofstock category 
SELECT category, COUNT(*) AS out_of_stock_count
FROM zepto
WHERE outOfStock = TRUE
GROUP BY category
ORDER BY out_of_stock_count DESC;

-- Value for money indicating
SELECT
    name,
    category,
    mrp,
    discountedSellingPrice,
    (mrp - discountedSellingPrice) AS savings
FROM zepto
ORDER BY savings DESC
LIMIT 10;

-- Quantity Distribution
SELECT
    z.name,
    z.quantity,
    q.product_count
FROM zepto z
JOIN (
    SELECT quantity, COUNT(*) AS product_count
    FROM zepto
    GROUP BY quantity
) q
ON z.quantity = q.quantity
ORDER BY z.quantity DESC;

-- summary
SELECT
    COUNT(*) AS total_products,
    COUNT(DISTINCT category) AS total_categories,
    ROUND(AVG(discountPercent), 2) AS avg_discount,
    SUM(outOfStock = TRUE) AS out_of_stock_products
FROM zepto;

-- List categories where more than 50 products are available.
SELECT category, COUNT(*) AS product_count
FROM zepto
GROUP BY category
HAVING COUNT(*) > 50;

-- Find the top 10 products with the highest available quantity.
SELECT name, availableQuantity
FROM zepto
ORDER BY availableQuantity DESC
LIMIT 10;

-- Which products are sold at the same price as MRP (no discount)?
SELECT name, mrp, discountedSellingPrice
FROM zepto
WHERE mrp = discountedSellingPrice;

-- How many products have a discount greater than 30%?
SELECT COUNT(*) AS products_with_high_discount
FROM zepto
WHERE discountPercent > 30;

-- Which categories have the highest average discounts?
SELECT category, AVG(discountPercent) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;


