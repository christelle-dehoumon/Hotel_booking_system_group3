-- ============================================================
-- CS27 — Hotel Booking System
-- PART 1.3 — SCHEMA DIAGRAM
-- ============================================================
-- This file documents the complete database schema:
-- all tables, attributes, primary keys, foreign keys
-- and the relationships between them.
-- The visual ERD diagram is provided in: schema_diagram.png
-- ============================================================

USE hotel_booking;

-- ============================================================
-- SCHEMA OVERVIEW — 7 TABLES
-- ============================================================

/*
┌─────────────────────────────────────────────────────────────┐
│  TABLE 1 : guests                                           │
├──────────────────┬────────────────┬────────────────────────┤
│  Column          │  Type          │  Constraints           │
├──────────────────┼────────────────┼────────────────────────┤
│  guest_id        │  INT           │  PK, AUTO_INCREMENT    │
│  first_name      │  VARCHAR(50)   │  NOT NULL              │
│  last_name       │  VARCHAR(50)   │  NOT NULL              │
│  email           │  VARCHAR(100)  │  NOT NULL, UNIQUE      │
│  phone           │  VARCHAR(20)   │  NOT NULL              │
│  nationality     │  VARCHAR(50)   │  DEFAULT 'Unknown'     │
│  created_at      │  DATE          │  NOT NULL              │
└──────────────────┴────────────────┴────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TABLE 2 : room_types                                       │
├──────────────────┬────────────────┬────────────────────────┤
│  Column          │  Type          │  Constraints           │
├──────────────────┼────────────────┼────────────────────────┤
│  type_id         │  INT           │  PK, AUTO_INCREMENT    │
│  type_name       │  VARCHAR(50)   │  NOT NULL, UNIQUE      │
│  description     │  TEXT          │                        │
│  price_per_night │  DECIMAL(10,2) │  NOT NULL              │
│  capacity        │  INT           │  NOT NULL, DEFAULT 2   │
└──────────────────┴────────────────┴────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TABLE 3 : rooms                                            │
├──────────────────┬───────────────────────┬─────────────────┤
│  Column          │  Type                 │  Constraints    │
├──────────────────┼───────────────────────┼─────────────────┤
│  room_id         │  INT                  │  PK, AUTO_INC   │
│  room_number     │  VARCHAR(10)          │  NOT NULL,UNIQUE │
│  floor_number    │  INT                  │  NOT NULL       │
│  type_id         │  INT                  │  FK → room_types│
│  status          │  ENUM(available,      │  NOT NULL       │
│                  │    occupied,          │  DEFAULT        │
│                  │    maintenance)       │  'available'    │
└──────────────────┴───────────────────────┴─────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TABLE 4 : bookings                                         │
├──────────────────┬────────────────┬────────────────────────┤
│  Column          │  Type          │  Constraints           │
├──────────────────┼────────────────┼────────────────────────┤
│  booking_id      │  INT           │  PK, AUTO_INCREMENT    │
│  guest_id        │  INT           │  FK → guests           │
│  room_id         │  INT           │  FK → rooms            │
│  check_in        │  DATE          │  NOT NULL              │
│  check_out       │  DATE          │  NOT NULL              │
│  total_amount    │  DECIMAL(10,2) │  NOT NULL              │
│  status          │  ENUM(confirm, │  NOT NULL              │
│                  │  cancelled,    │  DEFAULT 'confirmed'   │
│                  │  completed)    │                        │
│  created_at      │  DATETIME      │  DEFAULT CURRENT_TS    │
└──────────────────┴────────────────┴────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TABLE 5 : services                                         │
├──────────────────┬────────────────┬────────────────────────┤
│  Column          │  Type          │  Constraints           │
├──────────────────┼────────────────┼────────────────────────┤
│  service_id      │  INT           │  PK, AUTO_INCREMENT    │
│  service_name    │  VARCHAR(100)  │  NOT NULL, UNIQUE      │
│  category        │  VARCHAR(50)   │  NOT NULL              │
│  unit_price      │  DECIMAL(10,2) │  NOT NULL              │
└──────────────────┴────────────────┴────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TABLE 6 : invoices                                         │
├──────────────────┬────────────────┬────────────────────────┤
│  Column          │  Type          │  Constraints           │
├──────────────────┼────────────────┼────────────────────────┤
│  invoice_id      │  INT           │  PK, AUTO_INCREMENT    │
│  booking_id      │  INT           │  FK → bookings, UNIQUE │
│  issued_date     │  DATE          │  NOT NULL              │
│  total_due       │  DECIMAL(10,2) │  NOT NULL              │
│  paid            │  TINYINT(1)    │  NOT NULL, DEFAULT 0   │
│  payment_method  │  VARCHAR(50)   │  DEFAULT NULL          │
└──────────────────┴────────────────┴────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  TABLE 7 : booking_services  [M:N junction table]           │
├──────────────────┬────────────────┬────────────────────────┤
│  Column          │  Type          │  Constraints           │
├──────────────────┼────────────────┼────────────────────────┤
│  bs_id           │  INT           │  PK, AUTO_INCREMENT    │
│  booking_id      │  INT           │  FK → bookings         │
│  service_id      │  INT           │  FK → services         │
│  quantity        │  INT           │  NOT NULL, DEFAULT 1   │
└──────────────────┴────────────────┴────────────────────────┘
*/


-- ============================================================
-- FOREIGN KEY RELATIONSHIPS SUMMARY
-- ============================================================

/*
  rooms.type_id         →  room_types.type_id     (1:M)
       ON UPDATE CASCADE
       ON DELETE RESTRICT

  bookings.guest_id     →  guests.guest_id         (1:M)
       ON UPDATE CASCADE
       ON DELETE RESTRICT

  bookings.room_id      →  rooms.room_id           (1:M)
       ON UPDATE CASCADE
       ON DELETE RESTRICT

  invoices.booking_id   →  bookings.booking_id     (1:1)
       ON UPDATE CASCADE
       ON DELETE RESTRICT
       [UNIQUE constraint enforces 1:1]

  booking_services.booking_id  →  bookings.booking_id  (M:N)
       ON UPDATE CASCADE
       ON DELETE CASCADE

  booking_services.service_id  →  services.service_id  (M:N)
       ON UPDATE CASCADE
       ON DELETE RESTRICT
*/


-- ============================================================
-- VERIFY SCHEMA — show all tables and their columns
-- ============================================================

-- List all tables in the database
SHOW TABLES;

-- Show structure of each table
DESCRIBE guests;
DESCRIBE room_types;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE services;
DESCRIBE invoices;
DESCRIBE booking_services;

-- Show all foreign keys defined in the database
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_NAME IS NOT NULL
  AND TABLE_SCHEMA = 'hotel_booking'
ORDER BY TABLE_NAME;
