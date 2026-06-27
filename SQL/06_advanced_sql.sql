-- =====================================================
-- Smart Pharmacy Inventory & Expiry Management System
-- File: 06_advanced_sql.sql
-- Description: Advanced SQL features including
-- Transactions, Window Functions, EXPLAIN,
-- and Data Validation queries.
-- =====================================================

USE smart_pharmacy_inventory;

START TRANSACTION;

UPDATE inventory
SET quantity_in_stock = quantity_in_stock - 10
WHERE medicine_id = 2;

ROLLBACK;

START TRANSACTION;

UPDATE inventory
SET quantity_in_stock = quantity_in_stock - 10
WHERE medicine_id = 2;

COMMIT;
  Section 2 — Window Functions
ROW_NUMBER()
RANK()
DENSE_RANK()
Section 3 — EXPLAIN
EXPLAIN
SELECT *
FROM medicines
WHERE medicine_name = 'Paracetamol 500mg';


Section 4 — Data Validation

Include your validation queries such as:

Duplicate medicine names
Invalid prices
Negative inventory
Invalid expiry dates
Orphan purchase records
Orphan sales records
Inventory below reorder level
