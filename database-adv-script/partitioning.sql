-- ===============================================
-- Partitioning the bookings table by start_date
-- ===============================================

-- 1. Create the main partitioned table
CREATE TABLE bookings_partitioned (
    booking_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    property_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price NUMERIC(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
) PARTITION BY RANGE (start_date);

-- 2. Create partitions for different date ranges
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE bookings_2026 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- 3. Optional: Indexes on each partition for faster queries
CREATE INDEX idx_bookings_2024_user_id ON bookings_2024(user_id);
CREATE INDEX idx_bookings_2025_user_id ON bookings_2025(user_id);
CREATE INDEX idx_bookings_2026_user_id ON bookings_2026(user_id);

CREATE INDEX idx_bookings_2024_property_id ON bookings_2024(property_id);
CREATE INDEX idx_bookings_2025_property_id ON bookings_2025(property_id);
CREATE INDEX idx_bookings_2026_property_id ON bookings_2026(property_id);

-- ===============================================
-- Example query on partitioned table
-- ===============================================
-- This query will automatically hit only relevant partitions
SELECT *
FROM bookings_partitioned
WHERE start_date >= '2025-03-01'
  AND start_date < '2025-04-01';
