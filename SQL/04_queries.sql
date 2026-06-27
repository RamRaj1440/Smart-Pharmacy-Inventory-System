-- =====================================================
-- Smart Pharmacy Inventory & Expiry Management System
-- File: 04_queries.sql
-- Description: Basic SQL queries used for data retrieval,
-- filtering, sorting, grouping, joins and subqueries.
-- =====================================================

USE smart_pharmacy_inventory;

-- =====================================================
-- SECTION 1: SELECT Queries
-- =====================================================

SELECT * FROM medicines;

SELECT medicine_name, unit_price
FROM medicines;

-- =====================================================
-- SECTION 2: WHERE Clause
-- =====================================================

SELECT *
FROM medicines
WHERE unit_price > 100;

-- =====================================================
-- SECTION 3: ORDER BY
-- =====================================================

SELECT *
FROM medicines
ORDER BY unit_price DESC;

-- =====================================================
-- SECTION 4: Aggregate Functions
-- =====================================================

SELECT COUNT(*) FROM medicines;

SELECT AVG(unit_price) FROM medicines;

-- =====================================================
-- SECTION 5: GROUP BY
-- =====================================================

SELECT
    category_id,
    COUNT(*) AS total_medicines
FROM medicines
GROUP BY category_id;

-- =====================================================
-- SECTION 6: HAVING
-- =====================================================

SELECT
    supplier_id,
    SUM(quantity) AS total_quantity
FROM purchases
GROUP BY supplier_id
HAVING SUM(quantity) > 295;

-- =====================================================
-- SECTION 7: JOINS
-- =====================================================

-- INNER JOIN
-- LEFT JOIN

-- =====================================================
-- SECTION 8: Subqueries
-- =====================================================

-- Scalar Subqueries
-- Correlated Subqueries
-- Derived Tables
