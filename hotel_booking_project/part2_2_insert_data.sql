-- ============================================================
-- CS27 — Hotel Booking System
-- PART 2.2 — POPULATE DATABASE (minimum 10 rows per table)
-- ============================================================

USE hotel_booking;

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
(10, 11, '2025-06-01', '2025-06-04', 450000.00, 'completed'),
(11, 1,  '2025-06-20', '2025-06-22',  50000.00, 'confirmed'),
(12, 4,  '2025-07-01', '2025-07-05', 180000.00, 'confirmed');

-- Services (10 rows)
INSERT INTO services (service_name, category, unit_price) VALUES
('Breakfast Buffet',    'Food',         5000.00),
('Room Service',        'Food',         3500.00),
('Airport Shuttle',     'Transport',   15000.00),
('Spa & Massage',       'Wellness',    20000.00),
('Laundry',             'Housekeeping', 2500.00),
('Mini-bar Refill',     'Food',         8000.00),
('City Tour Guide',     'Transport',   25000.00),
('Pool Access (daily)', 'Leisure',      3000.00),
('Business Center',     'Business',     5000.00),
('Late Checkout',       'Housekeeping', 7500.00);

-- Invoices (12 rows)
INSERT INTO invoices (booking_id, issued_date, total_due, paid, payment_method) VALUES
(1,  '2025-01-14', 110000.00, 1, 'Credit Card'),
(2,  '2025-01-23', 145000.00, 1, 'Cash'),
(3,  '2025-02-08',  85000.00, 1, 'Mobile Money'),
(4,  '2025-02-20', 470000.00, 1, 'Bank Transfer'),
(5,  '2025-03-03',  95000.00, 1, 'Credit Card'),
(6,  '2025-03-14', 255000.00, 1, 'Cash'),
(7,  '2025-04-05', 380000.00, 1, 'Credit Card'),
(8,  '2025-04-22',  50000.00, 0, NULL),
(9,  '2025-05-15', 235000.00, 1, 'Mobile Money'),
(10, '2025-06-04', 465000.00, 1, 'Bank Transfer'),
(11, '2025-06-22',  50000.00, 0, NULL),
(12, '2025-07-05', 190000.00, 0, NULL);

-- Booking services (14 rows)
INSERT INTO booking_services (booking_id, service_id, quantity) VALUES
(1,  1, 4),  -- booking 1: 4 breakfasts
(1,  3, 1),  -- booking 1: airport shuttle
(2,  1, 3),  -- booking 2: 3 breakfasts
(2,  4, 1),  -- booking 2: spa
(3,  1, 3),  -- booking 3: 3 breakfasts
(4,  1, 5),  -- booking 4: 5 breakfasts
(4,  4, 2),  -- booking 4: 2 spa sessions
(4,  7, 1),  -- booking 4: city tour
(5,  1, 2),  -- booking 5: 2 breakfasts
(6,  8, 4),  -- booking 6: pool access 4 days
(7,  4, 2),  -- booking 7: spa
(9,  1, 5),  -- booking 9: 5 breakfasts
(10, 4, 1),  -- booking 10: spa
(10, 7, 1);  -- booking 10: city tour
