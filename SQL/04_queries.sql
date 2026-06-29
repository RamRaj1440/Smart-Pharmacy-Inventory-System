-- =====================================================
-- Smart Pharmacy Inventory & Expiry Management System
-- File: 04_queries.sql
-- Description: Basic SQL queries used for data retrieval,
-- filtering, sorting, grouping, joins and subqueries.
-- =====================================================


 -- "Show me all the medicines available in my pharmacy."
 
 SELECT * FROM medicines;
 
 
 -- "I only need the medicine names and their prices."
SELECT 
       medicine_name,
       unit_price
FROM  medicines;  
  
  -- "Show medicines that cost more than ₹100."
SELECT medicine_name,
       unit_price
 FROM medicines
 WHERE unit_price >100;
 
 -- "List medicines from the most expensive to the least expensive."

SELECT medicine_name,
		unit_price
FROM  medicines
ORDER BY unit_price DESC;        

-- "How many different medicines are available?"

SELECT COUNT(*) AS total_medicines
FROM medicines;

-- "How many medicine units are currently in stock?"

SELECT SUM(quantity_in_stock) AS total_stock
FROM inventory;

-- "What is the average selling price of medicines?"

SELECT AVG(unit_price) AS average_price
FROM medicines;

-- "Which medicine has the lowest unit price?"

SELECT medicine_name,unit_price
FROM medicines
ORDER BY unit_price ASC
LIMIT 1;

-- "Which medicine has the highest unit price?"

SELECT medicine_name,unit_price
FROM medicines
ORDER BY unit_price DESC
LIMIT 1;

-- "How many medicines are there in each category?"

SELECT 
	c.category_name,
	COUNT(m.medicine_id) AS medicine_count
FROM categories c 
JOIN medicines m 
	ON c.category_id = m.category_id
   GROUP BY c.category_id, c.category_name; 
   
   -- "How much inventory is available in each category?"
   
   SELECT 
	c.category_name,
    SUM(i.quantity_in_stock) AS total_stock
    FROM categories c 
    JOIN medicines m 
      ON c.category_id = m.category_id
     JOIN inventory i 
		ON m.medicine_id = i.medicine_id
	GROUP BY c.category_id, c.category_name;


 -- "How much revenue has each medicine generated?"
 
 SELECT
    m.medicine_name,
    SUM(s.quantity * s.selling_price) AS total_revenue
FROM medicines m
JOIN sales s
    ON m.medicine_id = s.medicine_id
GROUP BY m.medicine_id, m.medicine_name
ORDER BY total_revenue DESC;
  
  -- "Show medicines that sold more than 20 units."
  
  SELECT
    m.medicine_name,
    SUM(s.quantity) AS total_units_sold
FROM medicines m
JOIN sales s
    ON m.medicine_id = s.medicine_id
GROUP BY m.medicine_id, m.medicine_name
HAVING SUM(s.quantity) > 20;
  
  
  -- "How many units have been purchased from each supplier?"
  
  SELECT 
   sp.supplier_name,
   SUM(p.quantity) AS total_units_purchased
   FROM suppliers sp
   JOIN purchases p 
		ON sp.supplier_id = p.supplier_id
      GROUP BY sp.supplier_id, sp.supplier_name
      ORDER BY total_units_purchased DESC;
      
      -- WHERE filters individual rows
SELECT *
FROM inventory
WHERE quantity_in_stock > 50;

-- HAVING filters grouped results
SELECT medicine_id, SUM(quantity)
FROM sales
GROUP BY medicine_id
HAVING SUM(quantity) > 20;

-- "Show each medicine along with its category."

SELECT 
		m.medicine_id,
        m.medicine_name,
        c.category_name,
        m.unit_price
     FROM medicines AS m
     INNER JOIN categories AS c 
		ON m.category_id = c.category_id;
        
        -- "Which supplier supplied each purchase?"
        
        SELECT 
        p.purchase_id,
        m.medicine_name,
        s.supplier_name,
        p.quantity,
        p.purchase_price,
        p.purchase_date
       FROM purchases AS p
       INNER JOIN medicines AS m
			ON p.medicine_id = m.medicine_id
           INNER JOIN suppliers AS s
				ON p.supplier_id = s.supplier_id;
                
          -- "List all sales using medicine names instead of IDs."
          
          SELECT 
				s.sale_id,
                m.medicine_name,
                s.sale_date,
                s.quantity,
                s.selling_price
             FROM sales AS s
             INNER JOIN medicines AS m
				ON s.medicine_id = m.medicine_id;
                
	--  "Display inventory using medicine names."
    
    SELECT 
		e.batch_number,
        m.medicine_name,
        e.manufacturing_date,
        e.expiry_date,
        e.quantity
       FROM expiry_batches AS e
       INNER JOIN medicines AS m
			ON e.medicine_id = m.medicine_id;
            
       -- : Show All Categories (Even if They Have No Medicines)
       
       SELECT 
       c.category_name,
       m.medicine_name
      FROM categories AS c
      LEFT JOIN medicines AS m
			ON c.category_id = m.category_id;
            
       -- Show All Medicines (Even if They Have No Sales)
       
       SELECT 
           m.medicine_name,
           s.sale_date,
           s.quantity
          FROM medicines AS m
          LEFT JOIN sales AS s
               ON m.medicine_id = s.medicine_id;
               
         --   Find Medicines with No Sales
         
         SELECT 
         m.medicine_name
        FROM medicines AS m
        LEFT JOIN sales AS s
             ON m.medicine_id = s.medicine_id
         WHERE s.sale_id IS NULL; 
         
         
     -- Show All Suppliers and Their Purchases
     
     SELECT 
          sp.supplier_name,
          p.purchase_id,
          p.purchase_date
       FROM suppliers AS sp
       LEFT JOIN purchases AS p
        ON sp.supplier_id = p.supplier_id;
        
        
       -- Find Suppliers with No Purchases
       
       SELECT 
       sp.supplier_name
      FROM suppliers AS sp
      LEFT JOIN purchases AS p
           ON sp.supplier_id = p.supplier_id
       WHERE p.purchase_id IS NULL;  
       
       SELECT purchase_id, supplier_id  FROM purchases;
       SELECT supplier_id,supplier_name
FROM suppliers;

SELECT
    p.purchase_id,
    p.supplier_id,
    sp.supplier_name
FROM purchases AS p
LEFT JOIN suppliers AS sp
    ON p.supplier_id = sp.supplier_id;
    
-- Check matching records

SELECT
    p.purchase_id,
    p.supplier_id,
    s.supplier_name
FROM purchases p
LEFT JOIN suppliers s
    ON p.supplier_id = s.supplier_id;
    
    
    SELECT
    sp.supplier_id,
    sp.supplier_name,
    p.purchase_id
FROM suppliers AS sp
LEFT JOIN purchases AS p
    ON sp.supplier_id = p.supplier_id
WHERE p.purchase_id IS NULL;

-- Identify Duplicate Suppliers

SELECT 
     supplier_name,
     COUNT(*) AS duplicate_count
    FROM suppliers
    GROUP BY supplier_name
    HAVING COUNT(*) >1;
    
    -- See Which IDs Are Duplicates
    
    SELECT 
       supplier_id,
       supplier_name
     FROM suppliers
     ORDER BY supplier_name, supplier_id;
    
    -- Verify Which Duplicate IDs Are Referenced
    
     SELECT 
     s.supplier_id,
     s.supplier_name,
     COUNT(p.purchase_id) AS purchase_count
     FROM suppliers s 
     LEFT JOIN purchases p 
			ON s.supplier_id = p.supplier_id
         GROUP BY s.supplier_id, s.supplier_name
         ORDER BY s.supplier_name, s.supplier_id;
         
         -- Delete Only the Unused Duplicate Rows
         
         DELETE FROM suppliers 
         WHERE supplier_id IN (6, 7, 8, 9, 10);
         
         -- Verify the Cleanup
         
         SELECT *
         FROM suppliers
         ORDER BY supplier_id;
