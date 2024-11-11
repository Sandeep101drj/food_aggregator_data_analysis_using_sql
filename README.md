#  Data Analysis Project Using SQL : Food Aggregator Data Analysis



## Objective
The objective of this project is to conduct a comprehensive data analysis of a food aggregator platform using synthetic data. By using SQL queries on the underlying database, I aim to uncover insights related to customer behavior, restaurant performance, and overall business metrics. These insights will help stakeholders make informed decisions regarding marketing strategies, menu optimization, and customer engagement initiatives.

## Findings and Insights
This analysis provides various insights that can be instrumental for the food aggregator business:
1. **Customer Behavior**: Identifying customers who have never placed an order can help in targeting marketing efforts to convert them into active users.
2. **Pricing Strategy**: Understanding the average price per dish assists in positioning the menu competitively.
3. **Restaurant Performance**: Insights into top-performing restaurants and those exceeding specific sales thresholds can guide promotional efforts.
4. **Order Trends**: Analyzing order trends over time provides insights into revenue growth, assisting with forecasting and budgeting.
5. **Customer Loyalty**: Recognizing restaurants with maximum repeat customers aids in developing loyalty programs and improving customer retention.

## Tools Used
This project was developed using Microsoft SQL Server and Visual Studio Code. 

- **Microsoft SQL Server**: A robust relational database management system that facilitated the creation, management, and analysis of the sales data. SQL Server's powerful querying capabilities enabled efficient data extraction and manipulation, allowing for comprehensive insights into sales performance.

- **Visual Studio Code**: A lightweight and versatile code editor that provided a user-friendly environment for writing and executing SQL queries. Its integrated terminal and extensions enhanced productivity by enabling seamless database interaction and code management.




## Queries and Explanations
Flatfiles used to create database are included in the project folder. It is recommened to go through these datasets first.

### 1. Find Customers Who Have Never Ordered
```sql
SELECT 
    users.user_id, users.name as user_name 
FROM
    users
WHERE user_id IN (
    SELECT
        user_id
    FROM
        users
    EXCEPT
    SELECT
        user_id 
    FROM
        orders
);
```
- Result : This query identifies users in the users table who do not have any associated records in the orders table, indicating that they have never placed an order.

### 2. What is the Average Price Per Dish?
```sql
SELECT 
    food.f_name, AVG(price) AS average_price
FROM
    menu INNER JOIN food ON menu.f_id=food.f_id
GROUP BY 
    food.f_name
ORDER BY 
    average_price DESC
;
```
- Result : This query calculates the average price of each dish by joining the menu and food tables, allowing for insights into pricing strategies for different food items.

### 3. Find Top Restaurant in Terms of Number of Orders for the Month of June
```sql
SELECT TOP 1
    orders.r_id, resturants.r_name, COUNT(orders.r_id) as number_of_orders
FROM
    orders INNER JOIN resturants ON orders.r_id=resturants.r_id
WHERE
    MONTH(orders.date)=6
GROUP BY 
    orders.r_id, resturants.r_name    
ORDER BY 
    number_of_orders DESC
;
```
- Result : This query identifies the restaurant with the highest number of orders in June, which helps in understanding seasonal trends and popularity.

### 4. Restaurants with Monthly Sales Greater than 500 for June
```sql
SELECT 
    orders.r_id, resturants.r_name, SUM(orders.amount) as Total_revenue
FROM
    orders INNER JOIN resturants ON orders.r_id=resturants.r_id
WHERE
    MONTH(orders.date)=6
GROUP BY
    orders.r_id, resturants.r_name
HAVING
    SUM(orders.amount) > 500
ORDER BY
    Total_revenue DESC
;
```
- Result : This query identifies restaurants that achieved significant sales during June, which is useful for assessing financial performance.

### 5. Show All Orders with Order Details of User Ankit Between May 15 and June 15
```sql
SELECT
    orders.date, users.user_id, users.name, orders.order_id, food.f_name, orders.amount
FROM
    users INNER JOIN orders ON users.user_id=orders.user_id
    INNER JOIN order_details ON orders.order_id=order_details.order_id
    INNER JOIN food ON order_details.f_id=food.f_id
WHERE
    users.name LIKE 'Ankit' AND orders.date BETWEEN '2022-05-15' AND '2022-06-15'
;
```
- Result : This query retrieves all order details for a specific user named Ankit, allowing for personalized insights into customer preferences.

### 6. Find Restaurant with Maximum Repeat Customers
```sql
SELECT TOP 1
     x.r_id, resturants.r_name, COUNT(*) AS Loyal_customers
FROM (
    SELECT
        orders.r_id, orders.user_id, COUNT(*) AS Number_of_orders
    FROM 
        orders
    WHERE orders.r_id IS NOT NULL
    GROUP BY
        orders.r_id, orders.user_id 
    HAVING 
        COUNT(*) > 1
) x
INNER JOIN resturants ON x.r_id=resturants.r_id
GROUP BY x.r_id, resturants.r_name
ORDER BY Loyal_customers DESC
;
```
- Result : This query identifies the restaurant with the highest number of loyal customers, aiding in the development of loyalty programs.

### 7. Month-over-Month Revenue Growth of Business
```sql
WITH revenue AS (
    SELECT 
        MONTH(date) AS Month_number,
        FORMAT(date, 'MMM') AS Month_name,
        SUM(amount) AS Total_revenue
    FROM
        orders
    WHERE
        MONTH(date) IS NOT NULL
    GROUP BY 
        MONTH(date), FORMAT(date, 'MMM')
)
SELECT
    Month_name,
    Total_revenue,
    LAG(Total_revenue, 1) OVER (ORDER BY Month_number) AS prev_revenue,
    ((Total_revenue - LAG(Total_revenue, 1) OVER (ORDER BY Month_number)) * 100.0) /
    NULLIF(LAG(Total_revenue, 1) OVER (ORDER BY Month_number), 0) AS MoM_growth_percentage
FROM
    revenue
ORDER BY 
    Month_number
;
```
- Result : This query identifies the restaurant with the highest number of loyal customers, aiding in the development of loyalty programs.

### 8.  Favorite Food of Customer
```sql
SELECT 
    users.name AS user_name,
    food.f_name AS favourite_food,
    COUNT(*) AS order_count
FROM 
    orders
JOIN 
    order_details ON orders.order_id = order_details.order_id
JOIN 
    users ON orders.user_id = users.user_id
JOIN 
    food ON order_details.f_id = food.f_id
GROUP BY 
    users.name, food.f_name
HAVING
    COUNT(*) > 1
ORDER BY 
    order_count DESC
;
```
- Result : This query identifies each user's favorite food based on the frequency of orders, providing insights for personalized marketing strategies.

## Conclusion
This data analysis project aims to provide actionable insights to stakeholders in the food aggregation industry. The findings from the SQL queries can help in making data-driven decisions for marketing, pricing, and customer engagement. Future enhancements could include visualizing these insights with graphs and dashboards to better communicate trends and performance metrics.
