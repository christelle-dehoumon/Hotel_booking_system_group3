-- ============================================================
-- CS27 — Hotel Booking System
-- PART 1 — DATABASE DESIGN
-- ============================================================
-- Scenario 5: Hotel Booking System
-- Entities: guests, room_types, rooms, bookings,
--           services, invoices, booking_services
-- ============================================================


-- ============================================================
-- 1.1 — ENTITIES (7 tables, minimum 5 required)
-- ============================================================
-- Each entity is listed with its name, attributes,
-- primary key choice and reason.
-- ============================================================

/*
ENTITY 1 : guests
  Attributes : guest_id, first_name, last_name, email, phone,
               nationality, created_at
  Primary Key: guest_id (INT AUTO_INCREMENT)
  Reason     : A surrogate integer key avoids relying on personal
               data (e.g., email) which can change over time.

ENTITY 2 : room_types
  Attributes : type_id, type_name, description, price_per_night, capacity
  Primary Key: type_id (INT AUTO_INCREMENT)
  Reason     : Centralises pricing per category; avoids repeating
               price_per_night in every room row (3NF fix).

ENTITY 3 : rooms
  Attributes : room_id, room_number, floor_number, type_id (FK), status
  Primary Key: room_id (INT AUTO_INCREMENT)
  Reason     : Each physical room needs a unique identifier independent
               of its number (room numbers can be reassigned).

ENTITY 4 : bookings
  Attributes : booking_id, guest_id (FK), room_id (FK), check_in,
               check_out, total_amount, status, created_at
  Primary Key: booking_id (INT AUTO_INCREMENT)
  Reason     : One guest can have multiple bookings — a surrogate key
               avoids composite key complexity.

ENTITY 5 : services
  Attributes : service_id, service_name, category, unit_price
  Primary Key: service_id (INT AUTO_INCREMENT)
  Reason     : Services are reusable across many bookings; isolating
               them avoids duplication and eases price updates.

ENTITY 6 : invoices
  Attributes : invoice_id, booking_id (FK/UNIQUE), issued_date,
               total_due, paid, payment_method
  Primary Key: invoice_id (INT AUTO_INCREMENT)
  Reason     : UNIQUE on booking_id enforces the strict 1:1 relationship
               between a booking and its invoice.

ENTITY 7 : booking_services  [junction table]
  Attributes : bs_id, booking_id (FK), service_id (FK), quantity
  Primary Key: bs_id (INT AUTO_INCREMENT)
  Reason     : Resolves the M:N relationship between bookings and
               services; quantity allows ordering multiple units.
*/


-- ============================================================
-- 1.2 — RELATIONSHIPS
-- ============================================================
-- For each pair: type (1:1 / 1:M / M:N),
-- plain English explanation, and where the FK goes.
-- ============================================================

/*
RELATIONSHIP 1 : room_types ↔ rooms
  Type       : 1 : M  (one to many)
  Explanation: One room type (e.g. "Deluxe") can apply to many
               individual rooms, but each room belongs to exactly
               one type.
  FK         : rooms.type_id → room_types.type_id

RELATIONSHIP 2 : guests ↔ bookings
  Type       : 1 : M  (one to many)
  Explanation: One guest can make many bookings over time, but
               each booking is associated with exactly one guest.
  FK         : bookings.guest_id → guests.guest_id

RELATIONSHIP 3 : rooms ↔ bookings
  Type       : 1 : M  (one to many)
  Explanation: One room can be booked many times on different dates,
               but each booking concerns exactly one room.
  FK         : bookings.room_id → rooms.room_id

RELATIONSHIP 4 : bookings ↔ invoices
  Type       : 1 : 1  (one to one)
  Explanation: Each booking generates exactly one invoice, and each
               invoice belongs to exactly one booking.
  FK         : invoices.booking_id → bookings.booking_id
  Note       : UNIQUE constraint on invoices.booking_id enforces 1:1.

RELATIONSHIP 5 : bookings ↔ services  (via booking_services)
  Type       : M : N  (many to many)
  Explanation: A booking can include many services (breakfast, spa…),
               and a service can appear in many different bookings.
  Resolution : Junction table booking_services holds booking_id (FK)
               and service_id (FK) plus a quantity column.
  FK         : booking_services.booking_id → bookings.booking_id
               booking_services.service_id → services.service_id
*/


-- ============================================================
-- 1.4 — NORMALIZATION (UNF → 1NF → 2NF → 3NF)
-- ============================================================

/*
════════════════════════════════════════════════════
STEP 0 — UNNORMALIZED FORM (UNF)
════════════════════════════════════════════════════
One large flat table mixing all data:

  Booking(
    booking_id, guest_name, guest_email, guest_phone,
    room_number, room_type, price_per_night,
    check_in, check_out, total_amount,
    services_used,        ← multi-valued!
    invoice_total, paid
  )

Example row:
  1 | Aminata Ouédraogo | aminata@email.bf | +226... |
    101 | Standard | 25000 | 2025-01-10 | 2025-01-14 |
    100000 | "Breakfast, Shuttle, Spa" | 110000 | 0


════════════════════════════════════════════════════
STEP 1 — 1NF VIOLATION & FIX
════════════════════════════════════════════════════
VIOLATION : services_used is a multi-valued attribute.
  A guest can use several services in one booking. Storing
  them as a comma-separated string violates atomicity — each
  cell must hold one and only one value.

BEFORE (violates 1NF):
  booking_id | services_used
  1          | "Breakfast, Airport Shuttle, Spa"

FIX : Extract each service into a separate row.
  Create a junction table: booking_services(bs_id, booking_id,
  service_id, quantity)

AFTER (1NF satisfied):
  bs_id | booking_id | service_id | quantity
  1     | 1          | 1          | 4         ← 4 breakfasts
  2     | 1          | 3          | 1         ← 1 shuttle
  3     | 1          | 4          | 2         ← 2 spa sessions


════════════════════════════════════════════════════
STEP 2 — 2NF VIOLATION & FIX
════════════════════════════════════════════════════
VIOLATION : Partial dependency on a composite key.
  After 1NF, a combined key (booking_id, service_id) could
  identify rows. But guest_email and guest_phone depend only
  on booking_id — not on the full composite key.

BEFORE (violates 2NF):
  booking_id | service_id | guest_email      | guest_phone
  1          | 1          | aminata@email.bf | +22670001111
  1          | 3          | aminata@email.bf | +22670001111  ← duplicated!
  1          | 4          | aminata@email.bf | +22670001111  ← duplicated!

FIX : Move guest data to its own table; bookings reference
  guests via a FK.

AFTER (2NF satisfied):
  guests  : guest_id | first_name | last_name | email | phone | ...
  bookings: booking_id | guest_id(FK) | room_id(FK) | check_in | ...
  services: service_id | service_name | category | unit_price


════════════════════════════════════════════════════
STEP 3 — 3NF VIOLATION & FIX
════════════════════════════════════════════════════
VIOLATION : Transitive dependency.
  price_per_night depends on room_type, not on room_id directly.
  Dependency chain: room_id → room_type → price_per_night

BEFORE (violates 3NF):
  room_id | room_number | room_type | price_per_night
  1       | 101         | Standard  | 25000
  2       | 102         | Standard  | 25000   ← duplicated
  3       | 103         | Standard  | 25000   ← duplicated
  4       | 201         | Deluxe    | 45000

FIX : Extract room_types into its own table; rooms reference
  it via type_id (FK). Price is stored once per type.

AFTER (3NF satisfied):
  room_types: type_id | type_name | description | price_per_night | capacity
              1       | Standard  | Comfortable | 25000           | 2
              2       | Deluxe    | City view   | 45000           | 2

  rooms:      room_id | room_number | floor_number | type_id(FK) | status
              1       | 101         | 1            | 1           | available
              2       | 102         | 1            | 1           | occupied


════════════════════════════════════════════════════
FINAL SCHEMA — 3NF ✓
════════════════════════════════════════════════════
Every non-key attribute depends on:
  • the WHOLE key (not just part of it)        → 2NF satisfied
  • and NOTHING BUT the key (no transitivity)  → 3NF satisfied

Final tables: guests | room_types | rooms | bookings |
              services | invoices | booking_services
*/
