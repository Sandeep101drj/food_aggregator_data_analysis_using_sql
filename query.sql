
/* Question 1 : Find customers who have never ordered */
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
)
;

/* Question 2 : What is the average price per dish? */
SELECT 
    food.f_name, AVG(price) AS average_price
FROM
    menu INNER JOIN food ON menu.f_id=food.f_id
GROUP BY 
    food.f_name
ORDER BY 
    average_price DESC
;

/* Question 3: Find top resturant in terms of number of orders for the month of June */
SELECT TOP 1
    orders.r_id,resturants.r_name,COUNT(orders.r_id) as number_of_orders
FROM
    orders INNER JOIN resturants ON orders.r_id=resturants.r_id
WHERE
    MONTH(orders.date)=6
GROUP BY 
    orders.r_id,resturants.r_name    
ORDER BY 
    number_of_orders DESC;


/* Question 4: Which are the resturants with monthly sales > 500 for the month of June */
SELECT 
    orders.r_id,resturants.r_name,SUM(orders.amount) as Total_revenue
FROM
    orders INNER JOIN resturants ON orders.r_id=resturants.r_id
WHERE
    MONTH(orders.date)=6
GROUP BY
    orders.r_id,resturants.r_name
HAVING
    SUM(orders.amount) > 500
ORDER BY
    Total_revenue DESC;


/* Question 5: Show all orders with order details of user Ankit between 15th may to 15th june date range */
SELECT
    orders.date,users.user_id,users.name,orders.order_id,food.f_name,orders.amount
FROM
    users INNER JOIN orders ON users.user_id=orders.user_id
    INNER JOIN order_details ON orders.order_id=order_details.order_id
    INNER JOIN food ON order_details.f_id=food.f_id
WHERE
    users.name LIKE 'Ankit' AND orders.date BETWEEN '2022-05-15'AND '2022-06-15';

/* Question 6: Find resturant with maximum repeat customers */
SELECT TOP 1
     x.r_id,resturants.r_name,COUNT(*) AS Loyal_customers
FROM (
    SELECT
        orders.r_id,orders.user_id,COUNT(*) AS Number_of_orders
    FROM 
        orders
    WHERE orders.r_id IS NOT NULL
    GROUP BY
        orders.r_id,orders.user_id 
    HAVING 
        COUNT(*) >1) x
    INNER JOIN resturants ON x.r_id=resturants.r_id
GROUP BY x.r_id,resturants.r_name
ORDER BY Loyal_customers DESC;

/* Question 7: Month over month revenue growht of business */
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
    Month_number;

/* Question 8: Favourite food of customer */
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
    COUNT(*)>1
ORDER BY 
    order_count DESC;


