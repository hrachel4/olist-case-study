-- AUDIT 1: Identifying Missing or Zero-Price Values
-- Business Impact: Ensures revenue reporting isn't under-counted.
SELECT 
    order_id, 
    product_id, 
    price 
FROM olist_order_items_dataset
WHERE price IS NULL OR price <= 0;
-- FINDING: No Missing or Zero-Price Values

-- AUDIT 2: Checking for Duplicate Order Items
-- Business Impact: Prevents over-counting sales volume.
SELECT 
    order_id, 
    order_item_id, 
    COUNT(*) as duplicate_count
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING duplicate_count > 1;
-- FINDING: No Duplicate Order Items

-- AUDIT 3: Price Variance by Product Category
-- Business Impact: Identifies potential data entry errors or extreme luxury outliers.
SELECT 
    p.product_category_name,
    COUNT(oi.product_id) AS total_units_sold,
    ROUND(AVG(oi.price), 2) AS avg_category_price,
    ROUND(MIN(oi.price), 2) AS min_price,
    ROUND(MAX(oi.price), 2) AS max_price,
    ROUND(MAX(oi.price) - AVG(oi.price), 2) AS price_gap
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY price_gap DESC
LIMIT 10;
-- FINDINGS SUMMARY:
-- 1. DATA INTEGRITY: 1,603 units sold with NULL category names. Needs investigation to prevent "Uncategorized" revenue in final dashboard.
-- 2. EXTREME OUTLIERS: 'utilidades_domesticas' (Gap: 6,644) and 'artes' (Gap: 6,383) identified as top candidates for data cleaning.
-- 3. VALID HIGH VARIANCE: 'pcs' and 'consoles_games' show high variance consistent with tech hardware pricing tiers.

-- STEP 2: Get to the 'root cause' of the missing data
-- INVESTIGATION: Identifying the specific Product IDs with NULL categories
-- Business Impact: Finding the "root cause" of the 1,603 missing records.
SELECT
	oi.product_id,
    COUNT(oi.order_id) AS sales_count,
    p.product_category_name
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL OR p.product_category_name = ''
GROUP BY oi.product_id, p.product_category_name
ORDER BY sales_count DESC;
-- FIXED: Added p.product_category_name to GROUP BY to resolve Error 1055
-- FINDING: 610 products are missing 'product_category_name' repeatedly throughout dataset, causing the 1,603 missing records found in previous step

-- STEP 3: Final Data Validation for Visualization
-- GOAL: Categorize the 610 'orphan' products so they aren't lost in reporting.
-- We use COALESCE to replace NULLs/Blanks with 'Uncategorized' for a cleaner UI.
SELECT
	CASE
		WHEN p.product_category_name IS NULL OR p.product_category_name = '' THEN 'Uncategorized'
        ELSE p.product_category_name
	END AS final_category,
	COUNT(oi.product_id) AS total_units_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY final_category
ORDER BY total_units_sold DESC;


/* PHASE 2 CONCLUSION:
The audit successfully identified data integrity issues regarding 'orphan' product IDs 
and extreme price outliers in specific categories. 

NEXT STEPS FOR PHASE 3 (Data Cleaning & Visualization):
1. Apply the COALESCE/CASE logic to handle the 610 orphan products identified in Step 2.
2. Investigate the 'utilidades_domesticas' price outliers (Gap: 6,644) to determine if records should be excluded or capped to prevent skewed dashboard averages.
3. Prepare the final SQL View for Power BI import.
*/