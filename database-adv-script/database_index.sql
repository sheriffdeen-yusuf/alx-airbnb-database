-- ==============================
-- Database Indexes for PostgreSQL
-- ==============================

-- Users table
CREATE INDEX idx_users_user_id ON users(user_id);
CREATE INDEX idx_users_email ON users(email);

-- Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Properties table
CREATE INDEX idx_properties_property_id ON properties(property_id);
CREATE INDEX idx_properties_name ON properties(name);


EXPLAIN ANALYZE
SELECT u.email, u.phone_number, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.email, u.phone_number
ORDER BY total_bookings DESC;
