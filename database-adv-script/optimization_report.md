# Query Performance Analysis: Bookings Query Before and After Indexes

## Execution Plan (Before Indexes)

Sort (cost=120.98..123.28 rows=920 width=866)
Sort Key: b.booking_id
-> Hash Left Join (b.property_id = p.property_id)
-> Hash Left Join (b.user_id = u.user_id)
-> Hash Right Join (py.booking_id = b.booking_id)
-> Seq Scan on payments py
-> Hash -> Seq Scan on bookings b
-> Hash -> Seq Scan on users u
-> Hash -> Seq Scan on properties p

### Observations

- PostgreSQL is performing **sequential scans on all tables** (`bookings`, `users`, `properties`, `payments`).
- Multiple **hash joins** are used to combine tables.
- The final result is **sorted by `b.booking_id`**.

---

### Inefficiencies

1. **Seq Scans on all tables**

   - `Seq Scan on bookings b`
   - `Seq Scan on users u`
   - `Seq Scan on properties p`
   - `Seq Scan on payments py`
   - This means Postgres is reading **every row in all tables**. On small tables, this is fine, but with hundreds of thousands of rows, this is slow.

2. **Hash Right Join on payments**

   - `Hash Right Join` is unusual; often **LEFT JOIN** or **INNER JOIN** is preferred.
   - Right join may force additional memory usage because it builds a hash on the smaller side (`bookings`) and scans the `payments` table.

3. **Multiple hash joins stacked**

   - Each join builds a hash table and consumes memory.
   - With large tables, this can lead to **high memory usage and slower performance**.

4. **Sort operation**
   - Sorting 920 rows may be cheap here, but sorting large results without an index can become a bottleneck.
   - `ORDER BY b.booking_id` could be optimized with an **index on `bookings.booking_id`**.

---

### Recommendations to Improve Performance

1. **Add Indexes**

```sql
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);


bookings.user_id → speeds up join with users

bookings.property_id → speeds up join with properties

payments.booking_id → speeds up join with bookings

Optional: bookings.booking_id → speeds up ORDER BY

Consider Join Order / Type

Prefer LEFT JOIN or INNER JOIN over RIGHT JOIN unless necessary.

Rewrite query so that smaller tables are joined first, reducing hash table size.

Limit columns selected

Only select columns you need. Avoid SELECT * to reduce memory usage.

Pre-aggregate or use CTEs (for large datasets)

If you only need counts or summaries, aggregate before joining.

| Feature                          | Before Indexes         | After Indexes                 | Impact                                  |
| -------------------------------- | ---------------------- | ----------------------------- | --------------------------------------- |
| bookings access                  | Seq Scan               | Index Scan on `booking_id`    | Only relevant rows read → faster        |
| payments access                  | Seq Scan               | Bitmap Index Scan + Heap Scan | Only matching rows read → faster        |
| Join method                      | Hash Joins             | Nested Loop Joins             | Efficient with indexes, less memory     |
| Small tables (users, properties) | Seq Scan + Hash        | Seq Scan + Materialize        | Cached results in memory → faster loops |
| Sorting                          | Sort after aggregation | Not explicitly shown          | Less expensive if already indexed       |
| Overall                          | Reads all rows         | Reads only relevant rows      | **Big performance improvement**         |
```
