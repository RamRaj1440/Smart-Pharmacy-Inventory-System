-- =====================================================
-- Smart Pharmacy Inventory & Expiry Management System
-- File: 07_business_reports.sql
-- Description: Business reporting queries for inventory,
-- sales, suppliers, revenue and pharmacy analytics.
-- =====================================================

 -- Business Dashboard Queries
       
       -- Report 1: Top 5 Selling Medicines
       
       SELECT 
			m.medicine_name,
            SUM(s.quantity) AS total_units_sold,
            SUM(s.quantity * s.selling_price) AS tatal_revenue
            FROM medicines m
            JOIN sales s 
            ON m.medicine_id = s.medicine_id
            GROUP BY
				m.medicine_id,
				m.medicine_name
            ORDER BY total_units_sold DESC
            LIMIT 5;
        
        
        -- Report 2: Revenue by Category
        
        SELECT 
			c.category_name,
            SUM(s.quantity *s.selling_price) AS total_revenue
          FROM categories c 
          JOIN medicines m 
          ON c.category_id = m.category_id
          JOIN sales s 
          ON m.medicine_id = s.medicine_id
          GROUP BY
                c.category_id,
                c.category_name
           ORDER BY total_revenue DESC;     
          
          
          -- Report 3: Supplier Performance
          
          SELECT 
              sp.supplier_name,
              COUNT(p.purchase_id) AS total_orders,
              SUM(p.quantity) AS total_quantity
           FROM suppliers sp
           JOIN purchases p 
           ON sp.supplier_id = p.supplier_id
           GROUP BY 
				sp.supplier_id,
                sp.supplier_name
            ORDER BY total_quantity DESC;    
            
            -- Report 4: Current Inventory Status
            
            SELECT 
            m.medicine_name,
            i.quntity_in_stock,
            i.reorder_level,
            CASE 
				WHEN i.quantity_in_stock <= i.reorder_level
                THEN 'Reorder Required'
                ELSE 'Stock Available'
			END AS stock_status
        FROM inventory i 
        JOIN medicines m 
        ON i.medicine_id = m.medicine_id;
        
        -- Report 5: Medicines Expiring Within 180 Days
        
        SELECT
    m.medicine_name,
    e.batch_number,
    e.expiry_date
FROM expiry_batches e
JOIN medicines m
ON e.medicine_id = m.medicine_id
WHERE e.expiry_date <= CURDATE() + INTERVAL 180 DAY
ORDER BY e.expiry_date;

 -- Report 6: Monthly Sales Revenue
 
 SELECT
    YEAR(s.sale_date) AS sales_year,
    MONTH(s.sale_date) AS sales_month,
    SUM(s.quantity * s.selling_price) AS monthly_revenue
FROM sales s
GROUP BY
    YEAR(s.sale_date),
    MONTH(s.sale_date)
ORDER BY
    sales_year,
    sales_month;
    
    -- Report 7: Highest Revenue Medicine
    
    SELECT
    medicine_name,
    total_revenue
FROM
(
    SELECT
        m.medicine_name,
        SUM(s.quantity * s.selling_price) AS total_revenue
    FROM medicines m
    JOIN sales s
    ON m.medicine_id = s.medicine_id
    GROUP BY
        m.medicine_id,
        m.medicine_name
) revenue_summary
ORDER BY total_revenue DESC
LIMIT 1;
