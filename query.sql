/* BASIC ANALYSIS */

/* 1. Retrieve details of shipments (sales) where the amounts exceed 2,000 and the number of boxes is fewer than 100. */
SELECT *
FROM sales
WHERE Amount > 2000 AND Boxes < 100;

/* 2. What is the total number of shipments (sales) made by each salesperson during January 2022? */
SELECT people.Sales_person, SUM(Boxes) AS Total_Shipments
FROM sales
JOIN people ON people.SP_ID = sales.Sales_Person
WHERE MONTH(Date) = 1
GROUP BY people.Sales_person
ORDER BY Total_Shipments DESC;

/* 3. Which product has the highest sales volume in terms of boxes sold: Milk Bars or Eclairs? */
SELECT products.Product, SUM(sales.Boxes) AS Total_Boxes_Sold
FROM sales
JOIN products ON products.Product_ID = sales.Product
WHERE products.Product IN ('Eclairs', 'Milk Bars')
GROUP BY products.Product
ORDER BY Total_Boxes_Sold DESC;

/* 4. Which product sold the most boxes during the first seven days of February 2022? */
SELECT products.Product, SUM(sales.Boxes) AS Total_Boxes_Sold
FROM sales
JOIN products ON products.Product_ID = sales.Product
WHERE sales.Date BETWEEN '2022-02-01' AND '2022-02-07'
GROUP BY products.Product
ORDER BY Total_Boxes_Sold DESC;

/* 5. In the first seven days of February 2022, which product sold more boxes: Milk Bars or Eclairs? */
SELECT products.Product, SUM(sales.Boxes) AS Total_Boxes_Sold
FROM sales
JOIN products ON products.Product_ID = sales.Product
WHERE sales.Date BETWEEN '2022-02-01' AND '2022-02-07'
  AND products.Product IN ('Eclairs', 'Milk Bars')
GROUP BY products.Product
ORDER BY Total_Boxes_Sold DESC;

/* 6. Identify shipments with fewer than 100 customers and fewer than 100 boxes. */
SELECT *
FROM sales
WHERE Customers < 100 AND Boxes < 100;

/* 7. Which shipments had fewer than 100 customers and fewer than 100 boxes, and did any of them occur on a Wednesday? */
SELECT *, DAY(Date) AS Day
FROM sales
WHERE Customers < 100 AND Boxes < 100
  AND DAY(Date) = 3;


/* COMPLEX ANALYSIS */

/* 1. List the names of salespersons who had at least one shipment during the first seven days of January 2022. */
SELECT people.Sales_person, 
       SUM(sales.Amount) AS Total_Amount,
       SUM(sales.Customers) AS Total_Customers, 
       SUM(sales.Boxes) AS Total_Boxes
FROM sales
JOIN people ON people.SP_ID = sales.Sales_Person
WHERE sales.Date BETWEEN '2022-01-01' AND '2022-01-07'
GROUP BY people.Sales_person;

/* An alternate approach to obtain the above information; however, this will only display the salesperson names. */
SELECT DISTINCT people.Sales_person
FROM sales
JOIN people ON people.SP_ID = sales.Sales_Person
WHERE sales.Date BETWEEN '2022-01-01' AND '2022-01-07';

/* 2. Identify salespersons who did not make any shipments during the first seven days of January 2022. */
SELECT Sales_person
FROM people
EXCEPT
SELECT DISTINCT people.Sales_person
FROM sales
JOIN people ON people.SP_ID = sales.Sales_Person
WHERE sales.Date BETWEEN '2022-01-01' AND '2022-01-07';

/* 3. How many times did we ship more than 1,000 boxes in each month? */
SELECT FORMAT(sales.Date, 'yyyy-MM') AS Month,
       COUNT(sales.Boxes) AS Shipments_Greater_Than_1000_Boxes
FROM sales
WHERE sales.Boxes > 1000
GROUP BY FORMAT(sales.Date, 'yyyy-MM')
ORDER BY FORMAT(sales.Date, 'yyyy-MM');

/* 4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ in every month? */
SELECT FORMAT(sales.Date, 'yyyy-MM') AS Month, 
       products.Product, 
       geo.Geo, *
FROM sales
JOIN products ON products.Product_ID = sales.Product
JOIN geo ON geo.GeoID = sales.Geo
WHERE products.Product = 'After Nines'
  AND geo.Geo = 'New Zealand'
ORDER BY Month DESC;

/* The previous method lists all months where at least one box of ‘After Nines’ was shipped to ‘New Zealand’. 
   To find out which months did not have any shipments, we can use the following method. If the result is empty, 
   it indicates that 'After Nines' was shipped to 'New Zealand' in every month. */
SELECT FORMAT(sales.Date, 'yyyy-MM') AS Month
FROM sales
EXCEPT
SELECT FORMAT(sales.Date, 'yyyy-MM') AS Month
FROM sales
JOIN products ON products.Product_ID = sales.Product
JOIN geo ON geo.GeoID = sales.Geo
WHERE products.Product = 'After Nines'
  AND geo.Geo = 'New Zealand';

/* 5. Between India and Australia, which country purchases more chocolate boxes on a monthly basis? */
SELECT FORMAT(s.Date, 'yyyy-MM') AS Month, 
       g.Geo, 
       SUM(s.Boxes) AS Total_Boxes
FROM sales s
JOIN geo g ON s.Geo = g.GeoID
WHERE g.Geo IN ('India', 'Australia')
GROUP BY FORMAT(s.Date, 'yyyy-MM'), g.Geo
ORDER BY Month;
