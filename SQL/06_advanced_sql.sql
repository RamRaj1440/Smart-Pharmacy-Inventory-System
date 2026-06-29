-- =====================================================
-- Smart Pharmacy Inventory & Expiry Management System
-- File: 06_advanced_sql.sql
-- Description: Advanced SQL features including
-- Transactions, Window Functions, EXPLAIN,
-- and Data Validation queries.
-- =====================================================

USE smart_pharmacy_inventory;
     -- Transactions (START TRANSACTION, COMMIT, ROLLBACK)
        -- Start a Transaction
        
       START TRANSACTION;   
       -- Check Current Stock
       SELECT 
            medicine_id,
            quantity_in_stock
         FROM inventory
         WHERE medicine_id =2;
         
         -- Update Stock
        UPDATE inventory
        SET quantity_in_stock = quantity_in_stock - 10
        WHERE medicine_id= 2;
        
        ROLLBACK;
        
        -- Start a Transaction
        
         START TRANSACTION;  
         
           -- Check Current Stock
       SELECT 
            medicine_id,
            quantity_in_stock
         FROM inventory
         WHERE medicine_id =2;
         
         -- Update Stock
        UPDATE inventory
        SET quantity_in_stock = quantity_in_stock - 5
        WHERE medicine_id= 2;
        
         SELECT 
            medicine_id,
            quantity_in_stock
         FROM inventory
         WHERE medicine_id =2;
        
        ROLLBACK;
        
         SELECT 
            medicine_id,
            quantity_in_stock
         FROM inventory
         WHERE medicine_id =2;
         
         
      --   Rank Medicines by Revenue (RANK())
      
      SELECT 
      m.medicine_name,
      SUM(s.quantity * s.selling_price) AS total_revenue,
      RANK() OVER (
			ORDER BY SUM(s.quantity * s.selling_price) DESC
		)AS revenue_rank
        FROM medicines AS m
        JOIN sales AS s
           ON m.medicine_id = s.medicine_id
         GROUP BY
         m.medicine_id,
         m.medicine_name;
            
            
            -- Sequential Numbering (ROW_NUMBER())
            
        SELECT 
            medicine_name,
            unit_price,
            ROW_NUMBER() OVER (
					ORDER BY unit_price DESC
                    ) AS row_num
                 FROM medicines; 
                 
	-- Dense Ranking (DENSE_RANK())
    
    SELECT 
        medicine_name,
        unit_price,
        DENSE_RANK() OVER (
             ORDER BY unit_price DESC
             ) ASdense_rank
           FROM medicines;  
           
-- Compare the Three Ranking Functions

SELECT 
medicine_name,
unit_price,
ROW_NUMBER() OVER (ORDER BY unit_price DESC) ASrow_number,
RANK() OVER(ORDER BY unit_price DESC) AS rank_number,
DENSE_RANK() OVER (ORDER BY unit_price DESC) AS dense_rank_number
FROM medicines;


-- Check for Duplicate Medicine Names

SELECT 
	medicine_name,
    COUNT(*) AS duplicate_count
  FROM medicines
  GROUP BY medicine_name
  HAVING COUNT(*)>1;
  
  -- Find Medicines with Invalid Prices
  
  SELECT 
      medicine_id,
      medicine_name,
      unit_price
    FROM medicines
    WHERE unit_price <=0;
       
       -- Find Negative Inventory
       
       SELECT 
          inventory_id,
          medicine_id,
          quantity_in_stock
        FROM inventory
        WHERE quantity_in_stock < 0;
        
        -- Expiry Date Before Manufacturing Date
SELECT
	batch_id,
    batch_number,
    manufacturing_date,
    expiry_date
   FROM expiry_batches
   WHERE expiry_date <= manufacturing_date;
   
   -- Orphan Purchase Records
   
   SELECT 
		p.purchase_id,
        p.medicine_id
     FROM purchases AS p
     LEFT JOIN medicines AS m
			ON p.medicine_id = m.medicine_id
     WHERE m.medicine_id IS NULL;       
     
     -- Orphan Sales Records
     
     SELECT 
       s.sale_id,
       s.medicine_id
    FROM sales AS s
    LEFT JOIN medicines AS m
			ON s.medicine_id = m.medicine_id
   WHERE m.medicine_id IS NULL;   
   
   -- Inventory Below Reorder Level
   
   SELECT 
        m.medicine_name,
        i.quantity_in_stock,
        i.reorder_level
   FROM inventory AS i
   JOIN medicines AS m
			ON i.medicine_id = m.medicine_id
        WHERE i.quantity_in_stock <= i.reorder_level;    
        
