-- QUESTIONS
-- Retrieve the total number of orders placed according to order_details
SELECT 
    COUNT(ORDER_ID) AS TOTAL_ORDERS
FROM
    orders_details;
    
-- Calculate the total revenue generated from pizza sales.
select round(sum(orders_details.quantity*pizzas.price),2) as Revenue
from orders_details join pizzas on pizzas.pizza_id = orders_details.pizza_id

-- List the top 5 most ordered pizza types along with their quantities.
 select pizza_types.name , sum(orders_details.QUANTITY) as quantity
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details on orders_details.PIZZA_ID = pizzas.pizza_id
group by pizza_types.name order by QUANTITY desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(orders_details.QUANTITY) as quantity from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details on orders_details.PIZZA_ID= pizzas.pizza_id
group by pizza_types.category order by QUANTITY desc;

-- Determine the distribution of orders by hour of the day.
select hour(order_time) as hour , count(OERDER_ID) as order_count from orders
group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(QUANTITY),0) from
(select orders.ORDER_DATE, sum(orders_details.QUANTITY) as quantity from orders
join orders_details on orders.OERDER_ID=orders_details.ORDER_ID
group by orders.ORDER_DATE) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, sum(orders_details.QUANTITY*pizzas.price) as Revenue
from pizza_types join pizzas on pizzas.pizza_type_id= pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by Revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, round(sum(orders_details.QUANTITY*pizzas.price) /
 ( select round(sum(orders_details.quantity*pizzas.price),2) as total_Revenue
from orders_details join pizzas on pizzas.pizza_id = orders_details.pizza_id) * 100,2 )as Revenue
from pizza_types join pizzas on pizzas.pizza_type_id= pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by Revenue desc;

-- Analyze the cumulative revenue generated over time.
select ORDER_DATE, sum(revenue) over (order by ORDER_DATE) as cum_revenue
from
(select orders.ORDER_DATE, sum(orders_details.quantity*pizzas.price) as Revenue
from orders_details join pizzas on orders_details.pizza_id= pizzas.pizza_id
join orders on orders.OERDER_ID= orders_details.order_id
group by orders.ORDER_DATE) as sales;

