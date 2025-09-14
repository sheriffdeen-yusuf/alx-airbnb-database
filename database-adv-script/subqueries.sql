-- Objective: Write both correlated and non-correlated subqueries.

-- Instructions:

-- Write a query to find all properties where the average rating is greater than 4.0 using a subquery.

-- Write a correlated subquery to find users who have made more than 3 bookings.


SELECT *
FROM properties
WHERE property_id IN (
    SELECT property_id
    FROM reviews
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
)
ORDER BY name;



SELECT u.email, u.phone_number, b.status
FROM users u
JOIN bookings b ON b.user_id = u.user_id
WHERE u.user_id IN (
    SELECT user_id
    FROM bookings
    GROUP BY user_id
    HAVING COUNT(*) > 3
)
ORDER BY b.status;
