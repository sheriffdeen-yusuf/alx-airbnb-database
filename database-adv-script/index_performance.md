# Query Performance Analysis: Effect of Indexes

## Objective

Measure the performance of a query that counts total bookings per user **before and after adding indexes** in PostgreSQL.

---

## 1. Query Used

```sql
SELECT u.email, u.phone_number, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.email, u.phone_number
ORDER BY total_bookings DESC;
```

## 2. Performance Before Indexes

**Command Used:**

```sql
EXPLAIN ANALYZE
SELECT u.email, u.phone_number, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.email, u.phone_number
ORDER BY total_bookings DESC;

Execution Plan Summary:

PostgreSQL used sequential scans on both users and bookings tables:

Seq Scan on users u

Seq Scan on bookings b

A hash join was used to join users and bookings.

HashAggregate was used to calculate total bookings per user.

Sort was used to order results by total_bookings DESC.

Execution Time: 0.089 ms (very fast because dataset is small)

Memory usage: ~25 KB

Observations:

No indexes are used.

For small datasets, sequential scans are efficient.

For larger datasets, this approach would become slow.



-- Users table
CREATE INDEX idx_users_user_id ON users(user_id);

-- Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);



EXPLAIN ANALYZE
SELECT u.email, u.phone_number, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.email, u.phone_number
ORDER BY total_bookings DESC;

Expected Improvements:

PostgreSQL may use Index Scan or Bitmap Index Scan instead of sequential scans.

Hash join may require fewer resources.

Execution time will decrease on larger datasets
```
