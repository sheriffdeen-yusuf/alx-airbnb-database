
-- Write a query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings.
SELECT  u.first_name, u.last_name, u.email
FROM Users u
INNER JOIN bookings b 
ON b.user_id = u.user_id;


-- Write a query using aLEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.
SELECT 
	r.comment,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight
   
FROM properties p
LEFT JOIN reviews r
    ON r.property_id = p.property_id;


-- Write a query using a FULL OUTER JOIN to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
SELECT u.first_name, u.last_name, b.total_price, b.status, b.booking_id 
FROM users u 
FULL JOIN bookings b
ON b.user_id = u.user_id;
