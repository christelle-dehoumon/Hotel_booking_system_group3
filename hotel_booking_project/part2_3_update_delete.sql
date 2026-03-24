-- ============================================================
-- CS27 — Hotel Booking System
-- PART 2.3 — UPDATE AND DELETE STATEMENTS
-- ============================================================

USE hotel_booking;

-- ============================================================
-- UPDATE STATEMENTS (5 total — minimum 3 required)
-- ============================================================

-- UPDATE 1: Guest changed email address
UPDATE guests
SET email = 'aminata.ouedraogo.new@email.bf'
WHERE guest_id = 1;

-- UPDATE 2: Room 203 repaired — back to available
UPDATE rooms
SET status = 'available'
WHERE room_number = '203';

-- UPDATE 3: Increase Standard room price by 10%
UPDATE room_types
SET price_per_night = price_per_night * 1.10
WHERE type_name = 'Standard';

-- UPDATE 4: Mark booking 11 invoice as paid
UPDATE invoices
SET paid = 1, payment_method = 'Cash'
WHERE booking_id = 11;

-- UPDATE 5: Update guest phone number
UPDATE guests
SET phone = '+22670088881'
WHERE guest_id = 8;


-- ============================================================
-- DELETE STATEMENTS (2 total — minimum 2 required)
-- ============================================================

-- DELETE 1: Remove a booking_service (guest removed spa from booking 2)
DELETE FROM booking_services
WHERE booking_id = 2 AND service_id = 4;

-- DELETE 2: Remove unpaid cancelled invoice for booking 8
DELETE FROM invoices
WHERE booking_id = 8 AND paid = 0;


-- ============================================================
-- REFERENTIAL INTEGRITY VIOLATION DEMO
-- ============================================================
-- Attempting to delete a guest who has active bookings will
-- FAIL because of ON DELETE RESTRICT on bookings.guest_id.
--
-- Uncomment the line below to see the error in MySQL:
-- DELETE FROM guests WHERE guest_id = 1;
--
-- ERROR 1451 (23000): Cannot delete or update a parent row:
-- a foreign key constraint fails
-- (`hotel_booking`.`bookings`, CONSTRAINT `bookings_ibfk_1`
--  FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`))
--
-- This proves that referential integrity is correctly enforced.
-- ============================================================
