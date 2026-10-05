create database dailychallenges_2;

use dailychallenges_2;

CREATE TABLE customers (
 customer_id INT PRIMARY KEY,
 customer_name VARCHAR(100),
 city VARCHAR(50)
);


INSERT INTO customers VALUES
(1, 'Amit', 'Bangalore'),
(2, 'Sneha', 'Mumbai'),
(3, 'Rahul', 'Delhi'),
(4, 'Priya', 'Chennai');


CREATE TABLE orders (
 order_id INT PRIMARY KEY,
 customer_id INT,
 order_date DATE,
 amount DECIMAL(10,2)
);

INSERT INTO orders VALUES
(101, 1, '2024-01-10', 500),
(102, 1, '2024-02-15', 700),
(103, 2, '2024-03-01', 300),
(104, 5, '2024-03-05', 900);


CREATE TABLE payments (
 payment_id INT PRIMARY KEY,
 order_id INT,
 payment_status VARCHAR(20)
);


INSERT INTO payments VALUES
(1, 101, 'Completed'),
(2, 102, 'Pending'),
(3, 103, 'Completed');


-- Task 1: Customer Orders
-- Write a query to display:
-- • customer_name
-- • order_id
-- • amount
-- Include only customers who placed orders.

select c.customer_name , o.order_id, o.amount
from customers c
join orders o 
on c.customer_id = o.customer_id;

-- Task 2: All Customers
-- Write a query to display:
-- • all customers
-- • their order_id (if any)
-- Customers without orders should still appear.

select c.customer_name, o.order_id 
from customers c 
left join orders o
on c.customer_id = o.customer_id;


-- Task 3: Invalid Orders
-- Write a query to find:
-- • orders that do NOT have a matching customer 

select o.order_id from
orders o left join 
customers c
on c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;


-- Task 4: Order Payment Status
-- Write a query to display:
-- • customer_name
-- • order_id
-- • payment_status
-- Include all orders, even if payment is missing.

select c.customer_name, o.order_id, p.payment_status
from orders o
left join customers c on c.customer_id = o.customer_id
left join payments p on p.order_id = o.order_id;

-- Task 5: Customers Without Orders
-- Find customers who have never placed an order.

select c.*  from customers c
left join orders o 
on c.customer_id = o.customer_id
where o.order_id is null;

-- Task 6: Orders Without Payment
-- Find all orders that do not have a payment record.

select o.* from orders o
left join payments p 
on p.order_id = o.order_id
where p.payment_id is null;

-- Task 7: Total Spending
-- Write a query to calculate:
-- • total amount spent by each customer 

select c.customer_name , sum(o.amount) from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_name;

-- Task 8: Fully Paid Customers
-- Find customers whose all orders are marked as 'Completed'.

select c.customer_name
from customers c
join orders o on o.customer_id = c.customer_id
left join payments p on p.order_id = o.order_id
group by c.customer_id, c.customer_name
having sum(case when p.payment_status = 'Completed' then 0 else 1 end) = 0;



-- Task 9: Highest Order Per Customer
-- Display:
-- • customer_name
-- • highest order amount 

select c.customer_name , max(o.amount) from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_name
order by max(o.amount) desc;

-- Task 10: Top Customers
-- Find top 2 customers based on total spending.

select c.customer_name , sum(o.amount) from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_name
order by sum(o.amount) desc
limit 2;


