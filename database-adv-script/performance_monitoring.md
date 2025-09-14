# Continuous Database Performance Monitoring

## Objective

Continuously monitor and refine database performance by analyzing **query execution plans** and making **schema adjustments** such as indexing, partitioning, or query refactoring.

---

## 1. Monitoring Queries

In PostgreSQL, the main tools for monitoring query performance are:

- **EXPLAIN**: Shows the query execution plan without running the query.
- **EXPLAIN ANALYZE**: Executes the query and shows actual execution time and row counts.
- **pg_stat_statements**: Tracks execution statistics for all queries in the database.

---

## 2. Using EXPLAIN ANALYZE

### Example: Check a frequently used bookings query

```sql
EXPLAIN ANALYZE
SELECT u.email, u.phone_number, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.email, u.phone_number
ORDER BY total_bookings DESC;
```
