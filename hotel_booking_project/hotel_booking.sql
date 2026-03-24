DROP DATABASE IF EXISTS hotel_booking;
CREATE DATABASE hotel_booking
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hotel_booking;

-- TABLE 1: guests
CREATE TABLE guests (
    guest_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone        VARCHAR(20)  NOT NULL,
    nationality  VARCHAR(50)  DEFAULT 'Unknown',
    created_at   DATE         NOT NULL
);

-- TABLE 2: room_types
CREATE TABLE room_types (
    type_id      INT AUTO_INCREMENT PRIMARY KEY,
    type_name    VARCHAR(50)  NOT NULL UNIQUE,   -- e.g. 'Standard', 'Deluxe', 'Suite'
    description  TEXT,
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity     INT          NOT NULL DEFAULT 2
);

-- TABLE 3: rooms
CREATE TABLE rooms (
    room_id      INT AUTO_INCREMENT PRIMARY KEY,
    room_number  VARCHAR(10)  NOT NULL UNIQUE,
    floor_number INT          NOT NULL,
    type_id      INT          NOT NULL,
    status       ENUM('available','occupied','maintenance') NOT NULL DEFAULT 'available',
    FOREIGN KEY (type_id) REFERENCES room_types(type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- TABLE 4: bookings
CREATE TABLE bookings (
    booking_id   INT AUTO_INCREMENT PRIMARY KEY,
    guest_id     INT          NOT NULL,
    room_id      INT          NOT NULL,
    check_in     DATE         NOT NULL,
    check_out    DATE         NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status       ENUM('confirmed','cancelled','completed') NOT NULL DEFAULT 'confirmed',
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (room_id)  REFERENCES rooms(room_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- TABLE 5: services
CREATE TABLE services (
    service_id   INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    category     VARCHAR(50)  NOT NULL,           -- e.g. 'Food', 'Spa', 'Transport'
    unit_price   DECIMAL(10,2) NOT NULL
);

-- TABLE 6: invoices
CREATE TABLE invoices (
    invoice_id   INT AUTO_INCREMENT PRIMARY KEY,
    booking_id   INT          NOT NULL UNIQUE,
    issued_date  DATE         NOT NULL,
    total_due    DECIMAL(10,2) NOT NULL,
    paid         TINYINT(1)   NOT NULL DEFAULT 0,  -- 0 = unpaid, 1 = paid
    payment_method VARCHAR(50) DEFAULT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- TABLE 7: booking_services  (junction table — M:N between bookings & services)
CREATE TABLE booking_services (
    bs_id        INT AUTO_INCREMENT PRIMARY KEY,
    booking_id   INT          NOT NULL,
    service_id   INT          NOT NULL,
    quantity     INT          NOT NULL DEFAULT 1,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


-- ============================================================
-- PART 2.2 — POPULATE DATABASE (minimum 10 rows per table)
-- ============================================================

-- Room types (10 rows)
INSERT INTO room_types (type_name, description, price_per_night, capacity) VALUES
('Standard',    'Comfortable room with basic amenities',                    25000.00, 2),
('Deluxe',      'Spacious room with city view and mini-bar',                45000.00, 2),
('Suite',       'Luxury suite with separate living area',                   90000.00, 3),
('Family',      'Large room designed for families up to 4',                 60000.00, 4),
('Presidential','Top-floor suite with panoramic view & butler',            150000.00, 2),
('Economy',     'Budget-friendly room with essential amenities',            18000.00, 1),
('Junior Suite','Mid-range suite with sitting area and kitchenette',        70000.00, 2),
('Twin',        'Room with two separate beds, ideal for colleagues',        30000.00, 2),
('Penthouse',   'Exclusive top-floor penthouse with private terrace',      200000.00, 4),
('Studio',      'Open-plan room with kitchenette, ideal for long stays',    35000.00, 2);

-- Rooms (12 rows)
INSERT INTO rooms (room_number, floor_number, type_id, status) VALUES
('101', 1, 1, 'available'),
('102', 1, 1, 'occupied'),
('103', 1, 1, 'available'),
('201', 2, 2, 'available'),
('202', 2, 2, 'occupied'),
('203', 2, 2, 'maintenance'),
('301', 3, 3, 'available'),
('302', 3, 3, 'occupied'),
('401', 4, 4, 'available'),
('402', 4, 4, 'available'),
('501', 5, 5, 'available'),
('104', 1, 1, 'available');

-- Guests (12 rows)
INSERT INTO guests (first_name, last_name, email, phone, nationality, created_at) VALUES
('Aminata',   'Ouédraogo', 'aminata.ouedraogo@email.bf',  '+22670001111', 'Burkinabé',  '2024-01-10'),
('Kofi',      'Mensah',    'kofi.mensah@email.gh',        '+23320002222', 'Ghanaian',   '2024-02-14'),
('Marie',     'Traoré',    'marie.traore@email.bf',       '+22670003333', 'Burkinabé',  '2024-03-05'),
('Pierre',    'Dubois',    'pierre.dubois@email.fr',      '+33600004444', 'French',     '2024-03-20'),
('Fatima',    'Ba',        'fatima.ba@email.sn',          '+22170005555', 'Senegalese', '2024-04-01'),
('Emmanuel',  'Kone',      'emmanuel.kone@email.ci',      '+22507006666', 'Ivorian',    '2024-04-15'),
('Sophie',    'Weber',     'sophie.weber@email.de',       '+49170007777', 'German',     '2024-05-10'),
('Ibrahim',   'Sawadogo',  'ibrahim.sawadogo@email.bf',   '+22670008888', 'Burkinabé',  '2024-05-22'),
('Lucie',     'Martin',    'lucie.martin@email.fr',       '+33650009999', 'French',     '2024-06-01'),
('Adama',     'Diallo',    'adama.diallo@email.bf',       '+22670010000', 'Burkinabé',  '2024-06-18'),
('Carlos',    'Gomez',     'carlos.gomez@email.es',       '+34620011111', 'Spanish',    '2024-07-05'),
('Nadia',     'Compaoré',  'nadia.compaore@email.bf',     '+22670012222', 'Burkinabé',  '2024-07-20');

-- Bookings (12 rows)
INSERT INTO bookings (guest_id, room_id, check_in, check_out, total_amount, status) VALUES
(1,  2,  '2025-01-10', '2025-01-14', 100000.00, 'completed'),
(2,  5,  '2025-01-20', '2025-01-23', 135000.00, 'completed'),
(3,  1,  '2025-02-05', '2025-02-08',  75000.00, 'completed'),
(4,  8,  '2025-02-15', '2025-02-20', 450000.00, 'completed'),
(5,  4,  '2025-03-01', '2025-03-03',  90000.00, 'completed'),
(6,  9,  '2025-03-10', '2025-03-14', 240000.00, 'completed'),
(7,  7,  '2025-04-01', '2025-04-05', 360000.00, 'completed'),
(8,  2,  '2025-04-20', '2025-04-22',  50000.00, 'cancelled'),
(9,  5,  '2025-05-10', '2025-05-15', 225000.00, 'completed'),
(10,11,  '2025-06-01', '2025-06-04', 450000.00, 'completed'),
(11, 1,  '2025-06-20', '2025-06-22',  50000.00, 'confirmed'),
(12, 4,  '2025-07-01', '2025-07-05', 180000.00, 'confirmed');

-- Services (10 rows)
INSERT INTO services (service_name, category, unit_price) VALUES
('Breakfast Buffet',    'Food',      5000.00),
('Room Service',        'Food',      3500.00),
('Airport Shuttle',     'Transport', 15000.00),
('Spa & Massage',       'Wellness',  20000.00),
('Laundry',             'Housekeeping', 2500.00),
('Mini-bar Refill',     'Food',      8000.00),
('City Tour Guide',     'Transport', 25000.00),
('Pool Access (daily)', 'Leisure',   3000.00),
('Business Center',     'Business',  5000.00),
('Late Checkout',       'Housekeeping',7500.00);

-- Invoices (12 rows)
INSERT INTO invoices (booking_id, issued_date, total_due, paid, payment_method) VALUES
(1,  '2025-01-14', 110000.00, 1, 'Credit Card'),
(2,  '2025-01-23', 145000.00, 1, 'Cash'),
(3,  '2025-02-08',  85000.00, 1, 'Mobile Money'),
(4,  '2025-02-20', 470000.00, 1, 'Bank Transfer'),
(5,  '2025-03-03',  95000.00, 1, 'Credit Card'),
(6,  '2025-03-14', 255000.00, 1, 'Cash'),
(7,  '2025-04-05', 380000.00, 1, 'Credit Card'),
(8,  '2025-04-22',  50000.00, 0,  NULL),
(9,  '2025-05-15', 235000.00, 1, 'Mobile Money'),
(10, '2025-06-04', 465000.00, 1, 'Bank Transfer'),
(11, '2025-06-22',  50000.00, 0,  NULL),
(12, '2025-07-05', 190000.00, 0,  NULL);

-- Booking services (10+ rows)
INSERT INTO booking_services (booking_id, service_id, quantity) VALUES
(1, 1, 4),  -- booking 1: 4 breakfasts
(1, 3, 1),  -- booking 1: airport shuttle
(2, 1, 3),  -- booking 2: 3 breakfasts
(2, 4, 1),  -- booking 2: spa
(3, 1, 3),  -- booking 3: 3 breakfasts
(4, 1, 5),  -- booking 4: 5 breakfasts
(4, 4, 2),  -- booking 4: 2 spa sessions
(4, 7, 1),  -- booking 4: city tour
(5, 1, 2),  -- booking 5: 2 breakfasts
(6, 8, 4),  -- booking 6: pool access 4 days
(7, 4, 2),  -- booking 7: spa
(9, 1, 5),  -- booking 9: 5 breakfasts
(10,4, 1),  -- booking 10: spa
(10,7, 1);  -- booking 10: city tour


-- ============================================================
-- PART 2.3 — UPDATE AND DELETE STATEMENTS
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

-- UPDATE 5: Cancel booking 8 status already 'cancelled' — update guest phone
UPDATE guests
SET phone = '+22670088881'
WHERE guest_id = 8;

-- DELETE 1: Remove a booking_service (guest removed spa from booking 2)
DELETE FROM booking_services
WHERE booking_id = 2 AND service_id = 4;

-- DELETE 2: Remove unpaid, cancelled invoice placeholder (booking 8 cancelled)
-- First remove from booking_services if any (none for 8, safe to proceed)
DELETE FROM invoices
WHERE booking_id = 8 AND paid = 0;

-- REFERENTIAL INTEGRITY VIOLATION DEMO:
-- Attempting to delete a guest who has bookings will fail due to FOREIGN KEY constraint.
-- Uncomment the line below to see the error:
-- DELETE FROM guests WHERE guest_id = 1;
-- ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails
-- (`hotel_booking`.`bookings`, CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`guest_id`)
-- REFERENCES `guests` (`guest_id`))


-- ============================================================
-- PART 2.4 — SELECT QUERIES
-- ============================================================

-- Q1 [1 mark]: Retrieve all records from the rooms table
SELECT * FROM rooms;

-- Q2 [1 mark]: Specific columns — guests from Burkina Faso
SELECT first_name, last_name, email, phone
FROM guests
WHERE nationality = 'Burkinabé';

-- Q3 [1 mark]: All bookings sorted by total_amount descending
SELECT booking_id, guest_id, room_id, check_in, check_out, total_amount, status
FROM bookings
ORDER BY total_amount DESC;

-- Q4 [1 mark]: Top 5 most expensive bookings (LIMIT)
SELECT booking_id, guest_id, total_amount, status
FROM bookings
ORDER BY total_amount DESC
LIMIT 5;

-- Q5 [2 marks]: Bookings with total between 100 000 and 400 000 FCFA (BETWEEN)
SELECT booking_id, guest_id, total_amount
FROM bookings
WHERE total_amount BETWEEN 100000 AND 400000;

-- Q5b: Rooms on floors 2 or 4 (IN)
SELECT room_number, floor_number, status
FROM rooms
WHERE floor_number IN (2, 4);

-- Q5c: Guest names containing 'ou' (LIKE)
SELECT first_name, last_name, nationality
FROM guests
WHERE last_name LIKE '%ou%' OR last_name LIKE '%Ou%';

-- Q6 [2 marks]: INNER JOIN — bookings with guest names
SELECT b.booking_id,
       CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
       b.check_in,
       b.check_out,
       b.total_amount,
       b.status
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id;

-- Q7 [2 marks]: LEFT JOIN — all rooms, including those with no bookings
-- (shows NULL for rooms never booked)
SELECT r.room_number, r.status, b.booking_id, b.check_in, b.check_out
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id;
-- INNER JOIN would only return rooms that HAVE at least one booking.
-- LEFT JOIN returns ALL rooms, with NULLs where no booking exists.

-- Q8 [3 marks]: JOIN across 3 tables — booking details with guest name and room type
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
INNER JOIN guests g       ON b.guest_id  = g.guest_id
INNER JOIN rooms  r       ON b.room_id   = r.room_id
INNER JOIN room_types rt  ON r.type_id   = rt.type_id
ORDER BY b.booking_id;

-- Q9 [2 marks]: IS NULL — find unpaid invoices (payment_method is NULL)
SELECT i.invoice_id, i.booking_id, i.total_due, i.paid, i.payment_method
FROM invoices i
WHERE i.payment_method IS NULL;

-- Q9b: IS NOT NULL — paid invoices with a payment method recorded
SELECT i.invoice_id, i.booking_id, i.total_due, i.payment_method
FROM invoices i
WHERE i.payment_method IS NOT NULL;


-- ============================================================
-- PART 3 — AGGREGATE FUNCTIONS & REPORTING
-- ============================================================

-- [2 marks] COUNT total records in bookings
SELECT COUNT(*) AS total_bookings FROM bookings;

-- [2 marks] MAX and MIN booking amount
SELECT MAX(total_amount) AS most_expensive_booking,
       MIN(total_amount) AS least_expensive_booking
FROM bookings;

-- [2 marks] AVG nightly price per room type
SELECT AVG(price_per_night) AS average_room_price FROM room_types;

-- [3 marks] GROUP BY — number of bookings per status
SELECT status, COUNT(*) AS number_of_bookings
FROM bookings
GROUP BY status;

-- [3 marks] GROUP BY + HAVING — room types with more than 1 booking
SELECT rt.type_name,
       COUNT(b.booking_id) AS booking_count
FROM room_types rt
INNER JOIN rooms r    ON rt.type_id = r.type_id
INNER JOIN bookings b ON r.room_id  = b.room_id
GROUP BY rt.type_name
HAVING COUNT(b.booking_id) > 1;

-- [3 marks] SUMMARY REPORT: Revenue per room type (JOIN + GROUP BY + HAVING)
-- Shows only room types that generated more than 200 000 FCFA total revenue
SELECT rt.type_name,
       COUNT(b.booking_id)     AS total_bookings,
       SUM(b.total_amount)     AS total_revenue,
       AVG(b.total_amount)     AS avg_booking_value,
       MAX(b.total_amount)     AS highest_booking
FROM room_types rt
INNER JOIN rooms    r ON rt.type_id = r.type_id
INNER JOIN bookings b ON r.room_id  = b.room_id
GROUP BY rt.type_name
HAVING SUM(b.total_amount) > 200000
ORDER BY total_revenue DESC;
