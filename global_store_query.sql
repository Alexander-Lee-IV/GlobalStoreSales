DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
order_id varchar(50),
order_date DATE,
ship_date DATE,
ship_mode varchar(50),
customer_id varchar(50),
customer_name varchar(50),
segment varchar(50),
city varchar(50),
state varchar(50),
country varchar(50),
market varchar(50),
region varchar(50),
product_id varchar(50),
category varchar(50),
sub_category varchar(50),
product_name varchar(50),
sales INT,
quantity INT,
discount FLOAT,
profit FLOAT,
shipping_cost FLOAT,
order_priority varchar(50)	
); 

ALTER TABLE sales
ALTER COLUMN sales TYPE FLOAT;

COPY sales
FROM 'C:\Users\alexa\OneDrive\Desktop\global super store\global_sales.csv'
DELIMITER ','
CSV HEADER;


-- City Sales --
SELECT
	DISTINCT(CONCAT(state, ', ', country)) as location,
	CONCAT(city, ', ', state) as cities,
	TO_CHAR(order_date, 'mm/dd/yyyy') AS dates,
	ROUND(SUM(sales)) as sales,
	ROUND(SUM(profit)) as profit
FROM sales
GROUP BY country, state, city, order_date
ORDER BY dates;
-- Category Sales --
SELECT
	category,
	sub_category,
	CONCAT(state, ', ', country) as location,
	ROUND(SUM(sales)) as sales,
	ROUND(SUM(profit)) as profit
FROM sales
GROUP BY category, sub_category, city, location
ORDER BY category, city;
-- Top Country and City --
SELECT
	CONCAT(state, ', ', country) as location,
	TO_CHAR(order_date, 'mm/dd/yyyy') AS dates,
	ROUND(SUM(sales)) as sales
FROM sales
GROUP BY location, dates
ORDER BY sales;
-- Segment Profit and Loss --
SELECT 
	CONCAT(state, ', ', country) as location,
	segment,
	ROUND(SUM(sales)) as sales,
	ROUND(SUM(sales) - SUM(profit)) / 2 as loss
FROM sales
GROUP BY country, segment, state, country
ORDER BY country, sales;


-- Export Data -- 
COPY(SELECT
	DISTINCT(CONCAT(state, ', ', country)) as location,
	CONCAT(city, ', ', state) as cities,
	TO_CHAR(order_date, 'mm/dd/yyyy') AS dates,
	ROUND(SUM(sales)) as sales,
	ROUND(SUM(profit)) as profit
FROM sales
GROUP BY country, state, city, order_date
ORDER BY dates) TO 'C:\Users\alexa\OneDrive\Desktop\global super store\city_sales.csv' DELIMITER ',' CSV HEADER;

COPY(SELECT
	category,
	sub_category,
	CONCAT(state, ', ', country) as location,
	ROUND(SUM(sales)) as sales,
	ROUND(SUM(profit)) as profit
FROM sales
GROUP BY category, sub_category, city, location
ORDER BY city, category) TO 'C:\Users\alexa\OneDrive\Desktop\global super store\category_sales.csv' DELIMITER ',' CSV HEADER;

COPY(SELECT
	CONCAT(state, ', ', country) as location,
	TO_CHAR(order_date, 'mm/dd/yyyy') AS dates,
	ROUND(SUM(sales)) as sales
FROM sales
GROUP BY location, dates
ORDER BY sales) TO 'C:\Users\alexa\OneDrive\Desktop\global super store\top_country_and_city.csv' DELIMITER ',' CSV HEADER;

COPY(SELECT 
	CONCAT(state, ', ', country) as location,
	segment,
	ROUND(SUM(sales)) as sales,
	ROUND(SUM(sales) - SUM(profit)) / 2 as loss
FROM sales
GROUP BY country, segment, state, country
ORDER BY country, sales) TO 'C:\Users\alexa\OneDrive\Desktop\global super store\segment_profit_and_loss' DELIMITER ',' CSV HEADER;