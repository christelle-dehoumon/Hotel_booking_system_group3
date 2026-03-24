-- ============================================================
-- CS27 — Hotel Booking System
-- PART 3 — AGGREGATE FUNCTIONS & REPORTING
-- ============================================================

USE hotel_booking;

-- ────────────────────────────────────────────────────────────
-- [2 marks] — COUNT: total records in a table
-- ────────────────────────────────────────────────────────────
SELECT COUNT(*) AS total_bookings FROM bookings;


-- ────────────────────────────────────────────────────────────
-- [2 marks] — MAX and MIN of a numeric column
-- Most and least expensive booking amounts
-- ────────────────────────────────────────────────────────────
SELECT MAX(total_amount) AS most_expensive_booking,
       MIN(total_amount) AS least_expensive_booking
FROM bookings;


-- ────────────────────────────────────────────────────────────
-- [2 marks] — AVG of a numeric column
-- Average nightly price across all room types
-- ────────────────────────────────────────────────────────────
SELECT AVG(price_per_night) AS average_room_price
FROM room_types;


-- ────────────────────────────────────────────────────────────
-- [3 marks] — GROUP BY with an aggregate function
-- Number of bookings per status
-- ────────────────────────────────────────────────────────────
SELECT status,
       COUNT(*) AS number_of_bookings
FROM bookings
GROUP BY status;


-- ────────────────────────────────────────────────────────────
-- [3 marks] — HAVING to filter grouped results
-- Room types that have more than 1 booking
-- ────────────────────────────────────────────────────────────
SELECT rt.type_name,
       COUNT(b.booking_id) AS booking_count
FROM room_types rt
INNER JOIN rooms    r ON rt.type_id = r.type_id
INNER JOIN bookings b ON r.room_id  = b.room_id
GROUP BY rt.type_name
HAVING COUNT(b.booking_id) > 1;


-- ────────────────────────────────────────────────────────────
-- [3 marks] — Summary report: JOIN + GROUP BY + HAVING
-- Revenue per room type — only types exceeding 200,000 FCFA
-- Uses: COUNT, SUM, AVG, MAX, GROUP BY, HAVING, ORDER BY
-- ────────────────────────────────────────────────────────────
SELECT rt.type_name,
       COUNT(b.booking_id)  AS total_bookings,
       SUM(b.total_amount)  AS total_revenue,
       AVG(b.total_amount)  AS avg_booking_value,
       MAX(b.total_amount)  AS highest_booking
FROM room_types rt
INNER JOIN rooms    r ON rt.type_id = r.type_id
INNER JOIN bookings b ON r.room_id  = b.room_id
GROUP BY rt.type_name
HAVING SUM(b.total_amount) > 200000
ORDER BY total_revenue DESC;
