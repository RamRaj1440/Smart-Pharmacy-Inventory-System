-- =====================================================
-- Smart Pharmacy Inventory & Expiry Management System
-- File: 02_create_tables.sql
-- Description: Creates all database tables with
--              primary keys, foreign keys and constraints.
-- =====================================================


CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

SHOW TABLES;

DESCRIBE categories;

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    city VARCHAR(100)
);

SHOW TABLES;

DESCRIBE suppliers;


CREATE TABLE medicines (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    manufacturer VARCHAR(150),
    
    CONSTRAINT chk_unit_price
        CHECK (unit_price > 0),

    CONSTRAINT fk_medicine_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

SHOW TABLES;

DESCRIBE medicines;


CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_quantity_non_negative
        CHECK (quantity_in_stock >= 0),

    CONSTRAINT chk_reorder_non_negative
        CHECK (reorder_level >= 0),

    CONSTRAINT fk_inventory_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id),

    CONSTRAINT uq_inventory_medicine
        UNIQUE (medicine_id)
);


SELECT *
FROM inventory
WHERE quantity_in_stock <= reorder_level;


 SHOW TABLES;
 
 DESCRIBE inventory;
 
 
 CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    supplier_id INT NOT NULL,
    purchase_date DATE NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_purchase_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_purchase_price
        CHECK (purchase_price > 0),

    CONSTRAINT fk_purchase_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id),

    CONSTRAINT fk_purchase_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

DESCRIBE purchases;


CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_sale_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_selling_price
        CHECK (selling_price > 0),

    CONSTRAINT fk_sale_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id)
);

DESCRIBE sales;


CREATE TABLE expiry_batches (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_id INT NOT NULL,
    batch_number VARCHAR(50) NOT NULL UNIQUE,
    manufacturing_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT chk_batch_quantity
        CHECK (quantity >= 0),

    CONSTRAINT chk_batch_dates
        CHECK (expiry_date > manufacturing_date),

    CONSTRAINT fk_batch_medicine
        FOREIGN KEY (medicine_id)
        REFERENCES medicines(medicine_id)
);

DESCRIBE expiry_batches;
