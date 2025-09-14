# Query Optimization Report

## Objective

The goal of this exercise was to **improve query performance** on the `bookings` table by implementing:

1. **Indexes** on high-usage columns.
2. **Table partitioning** based on the `start_date` column.

---

## 1. Indexing Improvements

**Before Indexes:**

- Queries used **sequential scans** on `bookings`, `users`, `properties`, and `payments`.
- Multiple **hash joins** were used, consuming memory.
- Sorting on `booking_id` was performed on the entire dataset.
- Performance bottleneck observed on large tables.

**After Indexes:**

- `Index Scan` on `bookings.booking_id` and `Bitmap Index Scan` on `payments.booking_id`.
- Joins changed from hash joins to **nested loop joins**, reducing memory usage.
- Only relevant rows were scanned rather than full tables.
- Execution time improved significantly, especially on larger datasets.

**Observations:**

| Metric              | Before Index           | After Index        |
| ------------------- | ---------------------- | ------------------ |
| Table scans         | Seq Scans              | Index/Bitmap Scans |
| Join method         | Hash Joins             | Nested Loops       |
| Memory usage        | Higher                 | Lower              |
| Rows read           | All rows               | Only relevant rows |
| Overall performance | Slow on large datasets | Much faster        |

---

## 2. Partitioning Improvements

**Problem:** Queries filtering by `start_date` on a very large `bookings` table were slow.

**Solution:** Implemented **range partitioning** by `start_date`:

- Each year has its own partition (e.g., `bookings_2024`, `bookings_2025`).
- Queries automatically scan only relevant partitions.

**Example Query:**

```sql
SELECT *
FROM bookings_partitioned
WHERE start_date >= '2025-03-01'
  AND start_date < '2025-04-01';
```
