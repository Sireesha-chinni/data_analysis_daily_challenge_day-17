# Day 17 – Customer Orders Analysis (SQL JOINs Challenge)

An e-commerce SQL challenge that analyzes customers, orders, and payments using JOIN operations, aggregation, and filtering.

## Skills Practiced

| Concept | Used For |
|---------|----------|
| `INNER JOIN` | Customers who have orders |
| `LEFT JOIN` | Keeping all customers / orders, even without a match |
| `RIGHT JOIN` | Keeping all rows from the right table |
| `IS NULL` filter | Finding unmatched rows (anti-join pattern) |
| `GROUP BY` + `SUM()` / `MAX()` | Spending and order totals per customer |
| `ORDER BY` + `LIMIT` | Top-N customers |
| Subqueries | Used only where necessary |

## Repository Contents

```
.
├── Day17_Coding_Challenge.pdf                 # Problem statement
├── day_17_data_analytics_daily_challenge.sql  # Schema, sample data, and solutions
└── README.md
```

## Database Schema

**customers**

| Column | Type |
|--------|------|
| `customer_id` | INT (PK) |
| `customer_name` | VARCHAR(100) |
| `city` | VARCHAR(50) |

**orders**

| Column | Type |
|--------|------|
| `order_id` | INT (PK) |
| `customer_id` | INT |
| `order_date` | DATE |
| `amount` | DECIMAL(10,2) |

**payments**

| Column | Type |
|--------|------|
| `payment_id` | INT (PK) |
| `order_id` | INT |
| `payment_status` | VARCHAR(20) |

### Relationships

```
customers (1) ──< orders (1) ──< payments
 customer_id        customer_id    order_id
```

### Intentional edge cases in the sample data

- **Rahul and Priya** have no orders (tests `LEFT JOIN` and "customers without orders").
- **Order 104** belongs to `customer_id = 5`, who does not exist (an invalid/orphan order).
- **Order 104** also has no payment record.
- **Order 102** has a `Pending` payment, so Amit is not "fully paid".

## Tasks & Approach

| # | Task | Approach |
|---|------|----------|
| 1 | Customer name, order ID, amount for customers who placed orders | `INNER JOIN` customers and orders |
| 2 | All customers with their order ID (if any) | `customers LEFT JOIN orders` |
| 3 | Orders with no matching customer | `orders LEFT JOIN customers WHERE c.customer_id IS NULL` |
| 4 | Customer name, order ID, payment status for all orders | `orders LEFT JOIN customers LEFT JOIN payments`, starting from `orders` so no order is dropped |
| 5 | Customers who never placed an order | `customers LEFT JOIN orders WHERE o.order_id IS NULL` |
| 6 | Orders without a payment record | `orders LEFT JOIN payments WHERE p.payment_id IS NULL` |
| 7 | Total amount spent by each customer | `LEFT JOIN` + `SUM(amount)` + `GROUP BY` |
| 8 | Customers whose orders are all `Completed` | Group by customer and make sure no order is non-completed or unpaid |
| 9 | Highest order amount per customer | `MAX(amount)` + `GROUP BY` (not `SUM`) |
| 10 | Top 2 customers by total spending | `SUM(amount)` + `ORDER BY ... DESC LIMIT 2` |

## Expected Results

Based on the sample data:

| Task | Expected Output |
|------|-----------------|
| 1 | Amit (101, 500), Amit (102, 700), Sneha (103, 300) |
| 2 | Amit 101, Amit 102, Sneha 103, Rahul NULL, Priya NULL |
| 3 | Order 104 |
| 4 | 101 Amit Completed, 102 Amit Pending, 103 Sneha Completed, 104 NULL NULL |
| 5 | Rahul, Priya |
| 6 | Order 104 |
| 7 | Amit 1200, Sneha 300, Rahul NULL, Priya NULL |
| 8 | Sneha |
| 9 | Amit 700, Sneha 300 |
| 10 | Amit 1200, Sneha 300 |

## How to Run

1. Open MySQL Workbench (or any MySQL client).
2. Run `day_17_data_analytics_daily_challenge.sql`. It creates the `dailychallenges_2` database, the three tables, the sample data, and then the queries.
3. If you re-run the script, drop the database first (`DROP DATABASE dailychallenges_2;`) to avoid "already exists" errors.

## Key Takeaways

- **INNER JOIN** keeps only matching rows; **LEFT JOIN** keeps every row from the left table and fills `NULL` where there is no match.
- To find unmatched rows, `LEFT JOIN` and then filter on `IS NULL` for a column from the right table.
- When the question says "include all orders", start the query from the `orders` table so nothing is lost.
- "All orders are Completed" needs a check over every order, not just whether one completed order exists.
- `SUM()` gives totals, `MAX()` gives the highest single value. Pick the one the question asks for.

---

Part of my daily data analytics practice series.
