# Data Analysis Project Using SQL : Sales Analysis

## Objective
The objective of this project is to perform a detailed analysis of sales data for a fictional chocolate business. The analysis aims to identify trends in sales performance, product popularity, and salesperson effectiveness over specified periods. By utilizing SQL queries to extract and analyze data from the sales, products, people, and geographic tables, the insights gained will support strategic decisions to enhance sales operations and marketing initiatives.

## Analysis
The analysis uses a series of SQL queries that extract relevant data from various tables, including sales, products, people, and geo. Each query focuses on specific business questions, such as identifying high-volume shipments, comparing product sales, and assessing salesperson performance. This approach enables a comprehensive understanding of sales dynamics, helping to uncover patterns in customer preferences and operational efficiency.

## Tools Used
This project was developed using Microsoft SQL Server and Visual Studio Code. 

- **Microsoft SQL Server**: A robust relational database management system that facilitated the creation, management, and analysis of the sales data. SQL Server's powerful querying capabilities enabled efficient data extraction and manipulation, allowing for comprehensive insights into sales performance.

- **Visual Studio Code**: A lightweight and versatile code editor that provided a user-friendly environment for writing and executing SQL queries. Its integrated terminal and extensions enhanced productivity by enabling seamless database interaction and code management.



## Queries and Results
The flat files used for creating the database are included in the project folder. It is recommended to go through these datasets first.

1. **Details of Shipments Over 2,000 with Fewer than 100 Boxes**
   ```sql
   SELECT *
   FROM 
      sales
   WHERE 
      Amount > 2000 AND Boxes < 100;
   ```
- Result : Retrieves all shipments where the amount exceeds 2,000 and the number of boxes is less than 100.

2. **Total Shipments by Salesperson in January 2022**
   ```sql
   SELECT 
      people.Sales_person,
      SUM(Boxes) AS Total_Shipments
   FROM 
      sales JOIN people ON people.SP_ID = sales.Sales_Person
   WHERE
      MONTH(Date) = 1
   GROUP BY 
      people.Sales_person
   ORDER BY 
      Total_Shipments DESC;
   ```
- Result : Provides the total number of shipments made by each salesperson in January 2022, sorted by the number of shipments.

3. **Comparison of Box Sales: Milk Bars vs. Eclairs**
   ```sql
   SELECT 
      products.Product,
      SUM(sales.Boxes) AS Total_Boxes_Sold
   FROM 
      sales JOIN products ON products.Product_ID = sales.Product
   WHERE 
      products.Product IN ('Eclairs', 'Milk Bars')
   GROUP BY 
      products.Product
   ORDER BY 
      Total_Boxes_Sold DESC;
   ```
- Result : Identifies which product sold more boxes between Milk Bars and Eclairs.

4. **Product Sales in the First 7 Days of February 2022**
   ```sql
   SELECT 
      products.Product, SUM(sales.Boxes) AS Total_Boxes_Sold
   FROM 
      sales JOIN products ON products.Product_ID = sales.Product
   WHERE 
      sales.Date BETWEEN '2022-02-01' AND '2022-02-07'
   GROUP BY 
      products.Product
   ORDER BY 
      Total_Boxes_Sold DESC;
   ```
- Result : Shows which product had the highest sales in boxes during the specified timeframe.

5. **Milk Bars vs. Eclairs Sales in Early February 2022**
   ```sql
   SELECT 
      products.Product, 
      SUM(sales.Boxes) AS Total_Boxes_Sold
   FROM 
      sales JOIN products ON products.Product_ID = sales.Product
   WHERE 
      sales.Date BETWEEN '2022-02-01' AND '2022-02-07' AND products.Product IN ('Eclairs', 'Milk Bars')
   GROUP BY 
      products.Product
   ORDER BY 
      Total_Boxes_Sold DESC;
   ```
- Result : Compares the box sales of Milk Bars and Eclairs in the first week of February 2022.

6. **Shipments with Fewer than 100 Customers and Boxes**
   ```sql
   SELECT *
   FROM 
      sales
   WHERE 
      Customers < 100 AND Boxes < 100;
   ```
- Result : Lists shipments that had fewer than 100 customers and boxes.

7. **Wednesday Shipments with Under 100 Customers and Boxes**
   ```sql
   SELECT *, DAY(Date) AS Day
   FROM 
      sales
   WHERE 
      Customers < 100 AND Boxes < 100 AND DAY(Date) = 3; 
   ```
- Result : Filters for shipments on Wednesdays that had fewer than 100 customers and boxes.




8. **Salespersons with Shipments in Early January 2022**
   ```sql
   SELECT people.Sales_person, 
       SUM(sales.Amount) AS Total_Amount,
       SUM(sales.Customers) AS Total_Customers, 
       SUM(sales.Boxes) AS Total_Boxes
   FROM 
      sales JOIN people ON people.SP_ID = sales.Sales_Person
   WHERE 
      sales.Date BETWEEN '2022-01-01' AND '2022-01-07'
   GROUP BY 
      people.Sales_person; 
   ```
- Result : Lists salespersons who made at least one shipment in the first week of January 2022, along with total amounts, customers, and boxes.

9. **Salespersons with No Shipments in Early January 2022**
   ```sql
   SELECT 
      Sales_person
   FROM 
      people
   EXCEPT
   SELECT DISTINCT 
      people.Sales_person
   FROM 
      sales JOIN people ON people.SP_ID = sales.Sales_Person
   WHERE 
      sales.Date BETWEEN '2022-01-01' AND '2022-01-07'; 
   ```
- Result : Identifies salespersons who did not have any shipments during the specified timeframe.

10. **Monthly Shipments Over 1,000 Boxes**
   ```sql
   SELECT 
      FORMAT(sales.Date, 'yyyy-MM') AS Month,
      COUNT(sales.Boxes) AS Shipments_Greater_Than_1000_Boxes
   FROM 
      sales
   WHERE 
      sales.Boxes > 1000
   GROUP BY 
      FORMAT(sales.Date, 'yyyy-MM')
   ORDER BY 
      FORMAT(sales.Date, 'yyyy-MM'); 
   ```
- Result : Counts how many times shipments exceeded 1,000 boxes each month.

11. **Monthly Shipments of ‘After Nines’ to ‘New Zealand’**
   ```sql
   SELECT 
      FORMAT(sales.Date, 'yyyy-MM') AS Month, 
      products.Product, 
      geo.Geo, *
   FROM 
      sales JOIN products ON products.Product_ID = sales.Product JOIN geo ON geo.GeoID = sales.Geo
   WHERE 
      products.Product = 'After Nines' AND geo.Geo = 'New Zealand'
   ORDER BY 
      Month DESC; 
   ```
- Result : Lists months in which at least one box of ‘After Nines’ was shipped to ‘New Zealand’.

12. **Months without Shipments of ‘After Nines’ to ‘New Zealand’**
   ```sql
   SELECT 
      FORMAT(sales.Date, 'yyyy-MM') AS Month
   FROM 
      sales
   EXCEPT
   SELECT 
      FORMAT(sales.Date, 'yyyy-MM') AS Month
   FROM 
      sales JOIN products ON products.Product_ID = sales.Product JOIN geo ON geo.GeoID = sales.Geo
   WHERE 
      products.Product = 'After Nines' AND geo.Geo = 'New Zealand'; 
   ```
- Result : Identifies months where no shipments of ‘After Nines’ to ‘New Zealand’ occurred. An empty result indicates shipments were made in all months.

13. **Monthly Chocolate Box Purchases: India vs. Australia**
   ```sql
   SELECT 
      FORMAT(s.Date, 'yyyy-MM') AS Month, 
      g.Geo, 
      SUM(s.Boxes) AS Total_Boxes
   FROM 
      sales s JOIN geo g ON s.Geo = g.GeoID
   WHERE 
      g.Geo IN ('India', 'Australia')
   GROUP BY 
      FORMAT(s.Date, 'yyyy-MM'), g.Geo
   ORDER BY 
      Month; 
   ```
- Result : Compares monthly chocolate box purchases between India and Australia.

## Conclusion
This sales analysis project offers valuable insights into the performance of the chocolate business by examining various dimensions of sales data. The analysis highlights significant trends in product popularity, reveals patterns in sales across different time periods, and evaluates the effectiveness of individual salespersons. By identifying key metrics and trends, this project provides actionable recommendations for optimizing sales strategies, enhancing product offerings, and improving overall customer satisfaction. The findings underscore the importance of data-driven decision-making in driving business growth and adapting to changing market conditions.

