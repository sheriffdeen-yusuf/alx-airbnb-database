-- =======================================
-- Airbnb Database Seed Script (PostgreSQL)
-- =======================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================
-- Insert Users
-- ============================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
(gen_random_uuid(), 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw1', '08012345678', 'guest'::user_role),
(gen_random_uuid(), 'Bob', 'Smith', 'bob@example.com', 'hashed_pw2', '08087654321', 'host'::user_role),
(gen_random_uuid(), 'Charlie', 'Adams', 'charlie@example.com', 'hashed_pw3', '08011223344', 'host'::user_role),
(gen_random_uuid(), 'Diana', 'Moses', 'diana@example.com', 'hashed_pw4', '08099887766', 'guest'::user_role),
(gen_random_uuid(), 'Admin', 'User', 'admin@example.com', 'hashed_pw5', NULL, 'admin'::user_role),
(gen_random_uuid(), 'Emily', 'Brown', 'emily@example.com', 'hashed_pw6', '08055554444', 'guest'),
(gen_random_uuid(), 'Frank', 'Taylor', 'frank@example.com', 'hashed_pw7', '08066667777', 'guest'),
(gen_random_uuid(), 'Grace', 'Williams', 'grace@example.com', 'hashed_pw8', '08077778888', 'guest');

-- ============================
-- Insert Properties (extended)
-- ============================
INSERT INTO properties (property_id, host_id, name, description, location, pricepernight)
SELECT 
    gen_random_uuid(), user_id, 'Cozy Apartment', 
    '2-bedroom apartment in Lagos, close to city center', 
    'Lagos, Nigeria', 20000.00
FROM users WHERE email = 'bob@example.com'

UNION ALL
SELECT 
    gen_random_uuid(), user_id, 'Beachfront Villa', 
    'Luxury villa near the beach with private pool', 
    'Accra, Ghana', 80000.00
FROM users WHERE email = 'charlie@example.com'

UNION ALL
SELECT 
    gen_random_uuid(), user_id, 'Mountain Cabin', 
    'Secluded wooden cabin with fireplace and scenic views', 
    'Jos, Nigeria', 15000.00
FROM users WHERE email = 'bob@example.com'

UNION ALL
SELECT 
    gen_random_uuid(), user_id, 'City Loft', 
    'Modern loft apartment near downtown with rooftop access', 
    'Nairobi, Kenya', 30000.00
FROM users WHERE email = 'charlie@example.com'

UNION ALL
SELECT 
    gen_random_uuid(), user_id, 'Desert Retreat', 
    'Quiet desert home perfect for stargazing and meditation', 
    'Sahara, Morocco', 25000.00
FROM users WHERE email = 'bob@example.com';


-- ============================
-- Insert Bookings
-- ============================
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT gen_random_uuid(), p.property_id, u.user_id, DATE '2025-09-01', DATE '2025-09-05', 80000.00, 'confirmed'::booking_status
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'Cozy Apartment'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, DATE '2025-09-11', DATE '2025-09-15', 80000.00, 'confirmed'::booking_status
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'Beachfront Villa'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, DATE '2025-09-11', DATE '2025-09-15', 80000.00, 'confirmed'::booking_status
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'Beachfront Villa'
UNION ALL 
SELECT gen_random_uuid(), p.property_id, u.user_id, DATE '2025-10-10', DATE '2025-10-15', 400000.00, 'pending'::booking_status
FROM users u, properties p
WHERE u.email = 'diana@example.com' AND p.name = 'Beachfront Villa';
SELECT gen_random_uuid(), p.property_id, u.user_id, DATE '2025-10-10', DATE '2025-10-15', 400000.00, 'pending'::booking_status
FROM users u, properties p
WHERE u.email = 'grace@example.com' AND p.name = 'Desert Retreat';

-- ============================
-- Insert Payments
-- ============================
INSERT INTO payments (payment_id, booking_id, amount, payment_method, payment_date)
SELECT gen_random_uuid(), b.booking_id, b.total_price, 'credit_card'::payment_method, NOW()
FROM bookings b
JOIN users u ON b.user_id = u.user_id
WHERE u.email = 'alice@example.com'
UNION ALL
SELECT gen_random_uuid(), b.booking_id, b.total_price, 'paypal'::payment_method, NOW()
FROM bookings b
JOIN users u ON b.user_id = u.user_id
WHERE u.email = 'diana@example.com';

-- ============================
-- Insert Reviews
-- ============================
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
SELECT gen_random_uuid(), p.property_id, u.user_id, 5, 'Amazing stay, highly recommend!'
FROM users u, properties p
WHERE u.email = 'alice@example.com' AND p.name = 'Cozy Apartment'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, 4, 'Great location but could improve amenities'
FROM users u, properties p
WHERE u.email = 'diana@example.com' AND p.name = 'City Loft';
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, 2, 'Not as expected, needs maintenance'
FROM users u, properties p
WHERE u.email = 'emily@example.com' AND p.name = 'Mountain Cabin'
UNION ALL
SELECT gen_random_uuid(), p.property_id, u.user_id, 3, 'Decent stay, average experience'
FROM users u, properties p
WHERE u.email = 'grace@example.com' AND p.name = 'Cozy Apartment';
-- ============================
-- Insert Messages
-- ============================
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
SELECT gen_random_uuid(), u1.user_id, u2.user_id, 'Hi Bob, I am interested in booking your apartment.'
FROM users u1, users u2
WHERE u1.email = 'alice@example.com' AND u2.email = 'bob@example.com'
UNION ALL
SELECT gen_random_uuid(), u1.user_id, u2.user_id, 'Thanks Diana, happy to host you!'
FROM users u1, users u2
WHERE u1.email = 'charlie@example.com' AND u2.email = 'diana@example.com';
