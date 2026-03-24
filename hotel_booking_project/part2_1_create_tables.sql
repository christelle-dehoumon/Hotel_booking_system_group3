-- ============================================================
-- CS27 — Hotel Booking System
-- PART 2.1 — CREATE DATABASE AND TABLES
-- ============================================================
-- All tables with correct data types and constraints:
-- PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, DEFAULT, ENUM
-- Referential integrity enforced throughout.
-- ============================================================

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
    type_id         INT AUTO_INCREMENT PRIMARY KEY,
    type_name       VARCHAR(50)   NOT NULL UNIQUE,
    description     TEXT,
    price_per_night DECIMAL(10,2) NOT NULL,
    capacity        INT           NOT NULL DEFAULT 2
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
    guest_id     INT           NOT NULL,
    room_id      INT           NOT NULL,
    check_in     DATE          NOT NULL,
    check_out    DATE          NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status       ENUM('confirmed','cancelled','completed') NOT NULL DEFAULT 'confirmed',
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
    service_name VARCHAR(100)  NOT NULL UNIQUE,
    category     VARCHAR(50)   NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL
);

-- TABLE 6: invoices  (1:1 with bookings via UNIQUE)
CREATE TABLE invoices (
    invoice_id     INT AUTO_INCREMENT PRIMARY KEY,
    booking_id     INT           NOT NULL UNIQUE,
    issued_date    DATE          NOT NULL,
    total_due      DECIMAL(10,2) NOT NULL,
    paid           TINYINT(1)    NOT NULL DEFAULT 0,  -- 0=unpaid, 1=paid
    payment_method VARCHAR(50)   DEFAULT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- TABLE 7: booking_services  (M:N junction table)
CREATE TABLE booking_services (
    bs_id      INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity   INT NOT NULL DEFAULT 1,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
