 --- SQL Customer_Segmentation_Analysis
 
Use sql_project5;
Create table customer_segments
(customer_ID INT PRIMARY KEY,
year_birth INT,
education VARCHAR(50),
marital_status VARCHAR(50),
income DECIMAL(12,2),
kidhome INT,
teenhome INT,
dt_customer DATE,
recency INT,
mnt_wines DECIMAL(10,2),
mnt_fruits DECIMAL(10,2),
mnt_meat_products DECIMAL(10,2),
mnt_fish_products DECIMAL(10,2),
mnt_sweet_products DECIMAL(10,2),
mnt_gold_prods DECIMAL(10,2),
num_deals_purchases INT,
num_web_purchases INT,
num_catalog_purchases INT,
num_store_purchases INT,
num_web_visits_month INT
);
 
 Select * from customer_segments;
 
 -- Data Analysis and Business insights
 
 -- 1. Which education group generates the highest revenue?
 
SELECT Education,
ROUND(SUM( MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds),2) AS Total_Revenue
FROM customer_segments
GROUP BY Education
ORDER BY Total_Revenue DESC;
 
 -- 2. Which marital status group spends the most?
 
SELECT Marital_Status,
ROUND(SUM( MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds),2) AS Total_Spending
FROM customer_segments
GROUP BY Marital_Status
ORDER BY Total_Spending DESC;
 
 -- 3. Which product category generates the highest sales?
 
SELECT 'Wines' AS Product, SUM(MntWines) AS Sales
FROM customer_segments
UNION ALL
SELECT 'Fruits', SUM(MntFruits)
FROM customer_segments
UNION ALL
SELECT 'Meat Products', SUM(MntMeatProducts)
FROM customer_segments
UNION ALL
SELECT 'Fish Products', SUM(MntFishProducts)
FROM customer_segments
UNION ALL
SELECT 'Sweet Products', SUM(MntSweetProducts)
FROM customer_segments
UNION ALL
SELECT 'Gold Products', SUM(MntGoldProds)
FROM customer_segments
ORDER BY Sales DESC;
 
 -- 4. How does income impact customer spending?
 
 SELECT
CASE
WHEN Income < 30000 THEN 'Low Income'
WHEN Income BETWEEN 30000 AND 70000 THEN 'Middle Income'
ELSE 'High Income'
END AS Income_Group,
COUNT(*) AS Customers,
ROUND(SUM( MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds),2) AS Avg_Spending
FROM customer_segments
GROUP BY Income_Group
ORDER BY Avg_Spending DESC;
 
 -- 5. Which purchase channel is preferred by customers?
 
SELECT
SUM(NumWebPurchases) AS Web_Purchases,
SUM(NumCatalogPurchases) AS Catalog_Purchases,
SUM(NumStorePurchases) AS Store_Purchases
FROM customer_segments;
 
 -- 6. Build a Customer Segmentation Model
 
SELECT cumstomer_ID, Income, (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Spend,
CASE
WHEN Income >= 70000
AND (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) >= 1500
THEN 'High Value'
WHEN Income >= 40000
THEN  'Medium Value'
ELSE 'Low Value'
END AS Customer_value
FROM customer_segments;
  
 -- 7. Identify At-Risk Customers
 
SELECT cumstomer_ID, Income, Recency, 
 (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Spend,
CASE
WHEN Recency > 70
THEN 'At Risk'
ELSE 'Active'
END Customer_Status
FROM customer_segments
ORDER BY Recency DESC;
 
 -- 8. Which customer segment contributes the highest revenue?
 
WITH consumers_segments AS
(SELECT CASE
WHEN Income >= 70000
AND (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) >= 1500
THEN 'High Value'
WHEN Income >= 40000
THEN  'Medium Value'
ELSE  'Low Value'
END Segment,
(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Spend
FROM customer_segments)
SELECT Segment, COUNT(*) AS Customers,
ROUND(SUM(Total_Spend),2) AS Revenue
FROM consumers_segments
GROUP BY Segment
ORDER BY Revenue DESC;

-- END OF PROJECT
