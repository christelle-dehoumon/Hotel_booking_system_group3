-- ============================================================
-- CS27 — Hotel Booking System
-- PART 2.4 — SELECT QUERIES
-- ============================================================

USE hotel_booking;

-- ────────────────────────────────────────────────────────────
-- Q1 [1 mark] — Retrieve ALL records from a table
-- ────────────────────────────────────────────────────────────
SELECT * FROM rooms;


-- ────────────────────────────────────────────────────────────
-- Q2 [1 mark] — Specific columns with WHERE condition
-- List first name, last name, email and phone
-- of guests from Burkina Faso only
-- ────────────────────────────────────────────────────────────
SELECT first_name, last_name, email, phone
FROM guests
WHERE nationality = 'Burkinabé';


-- ────────────────────────────────────────────────────────────
-- Q3 [1 mark] — Sorted results using ORDER BY
-- All bookings sorted by total amount (highest first)
-- ────────────────────────────────────────────────────────────
SELECT booking_id, guest_id, room_id, check_in, check_out,
       total_amount, status
FROM bookings
ORDER BY total_amount DESC;


-- ────────────────────────────────────────────────────────────
-- Q4 [1 mark] — Limited results using LIMIT
-- Top 5 most expensive bookings
-- ────────────────────────────────────────────────────────────
SELECT booking_id, guest_id, total_amount, status
FROM bookings
ORDER BY total_amount DESC
LIMIT 5;


-- ────────────────────────────────────────────────────────────
-- Q5 [2 marks] — Filter using BETWEEN, IN, LIKE
-- ────────────────────────────────────────────────────────────

-- Q5a: BETWEEN — bookings between 100,000 and 400,000 FCFA
SELECT booking_id, guest_id, total_amount
FROM bookings
WHERE total_amount BETWEEN 100000 AND 400000;

-- Q5b: IN — rooms located on floor 2 or floor 4
SELECT room_number, floor_number, status
FROM rooms
WHERE floor_number IN (2, 4);

-- Q5c: LIKE — guests whose last name contains 'ou'
SELECT first_name, last_name, nationality
FROM guests
WHERE last_name LIKE '%ou%' OR last_name LIKE '%Ou%';


-- ────────────────────────────────────────────────────────────
-- Q6 [2 marks] — INNER JOIN across two tables
-- Bookings combined with guest full names
-- ────────────────────────────────────────────────────────────
SELECT b.booking_id,
       CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
       b.check_in,
       b.check_out,
       b.total_amount,
       b.status
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id;


-- ────────────────────────────────────────────────────────────
-- Q7 [2 marks] — LEFT JOIN (with explanation)
-- All rooms — including those with NO bookings (NULL)
-- ────────────────────────────────────────────────────────────
SELECT r.room_number, r.status,
       b.booking_id, b.check_in, b.check_out
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id;

/*
  DIFFERENCE BETWEEN INNER JOIN AND LEFT JOIN:
  - INNER JOIN returns only rooms that HAVE at least one booking.
    Rooms that were never booked are EXCLUDED from the result.
  - LEFT JOIN returns ALL rooms from the left table (rooms),
    and fills booking columns with NULL where no booking exists.
  In this query, LEFT JOIN is the right choice because we want
  to see every room, even those that have never been reserved.
*/


-- ────────────────────────────────────────────────────────────
-- Q8 [3 marks] — JOIN across 3 or more tables
-- Full booking report: guest name, room number, room type,
-- price per night, dates, amount and status (4 tables joined)
-- ────────────────────────────────────────────────────────────
SELECT b.booking_id,
       CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
       r.room_number,
       rt.type_name,
       rt.price_per_night,
       b.check_in,
       b.check_out,
       b.total_amount,
       b.status
FROM bookings b
INNER JOIN guests     g  ON b.guest_id = g.guest_id
INNER JOIN rooms      r  ON b.room_id  = r.room_id
INNER JOIN room_types rt ON r.type_id  = rt.type_id
ORDER BY b.booking_id;


-- ────────────────────────────────────────────────────────────
-- Q9 [2 marks] — IS NULL and IS NOT NULL
-- ────────────────────────────────────────────────────────────

-- Q9a: IS NULL — invoices with no payment method (unpaid)
SELECT invoice_id, booking_id, total_due, paid, payment_method
FROM invoices
WHERE payment_method IS NULL;

-- Q9b: IS NOT NULL — invoices with a recorded payment method (paid)
SELECT invoice_id, booking_id, total_due, payment_method
FROM invoices
WHERE payment_method IS NOT NULL;
