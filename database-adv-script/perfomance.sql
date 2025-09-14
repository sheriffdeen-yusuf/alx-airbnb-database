-- Retrieve all bookings along with user, property, and payment detail
SELECT 
    b.booking_id,
    b.total_price,
    b.status,
    u.email AS user_email,
    u.phone_number AS user_phone,
    p.name AS property_name,
    p.description AS property_description,
    py.payment_method
FROM bookings b
LEFT JOIN users u ON u.user_id = b.user_id
LEFT JOIN properties p ON p.property_id = b.property_id
LEFT JOIN payments py ON py.booking_id = b.booking_id
ORDER BY b.booking_id;


-- Retrieve all bookings along with user, property, and payment details
EXPLAIN
SELECT 
    b.booking_id,
    b.total_price,
    b.status,
    u.email AS user_email,
    u.phone_number AS user_phone,
    p.name AS property_name,
    p.description AS property_description,
    py.payment_method
FROM bookings b
LEFT JOIN users u ON u.user_id = b.user_id
LEFT JOIN properties p ON p.property_id = b.property_id
LEFT JOIN payments py ON py.booking_id = b.booking_id
ORDER BY b.booking_id;
