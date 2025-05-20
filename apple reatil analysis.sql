SELECT * FROM category;
SELECT COUNT(*) AS total_sales FROM sales;

WITH product_rank AS(
SELECT 
st.country, 
EXTRACT(YEAR FROM sale_date) AS sale_year, 
p.product_name, 
SUM(quantity) AS total_unit_sold,
RANK() OVER(PARTITION BY country, EXTRACT(YEAR FROM sale_date) ORDER BY SUM(quantity)) AS least_sold_product
FROM products AS p
JOIN sales AS s
ON p.product_id = s.product_id
JOIN stores AS st
ON st.store_id = s.store_id
GROUP BY st.country, EXTRACT(YEAR FROM sale_date), p.product_name
)
SELECT * FROM product_rank
WHERE least_sold_product = 1;

 SELECT  country,
    total_sold,
    total_claim,
    ROUND((total_claim::numeric) / (total_sold::numeric) * 100, 2) AS percentage_of_risk
FROM (
    SELECT
        st.country,
        SUM(s.quantity) AS total_sold,
        COUNT(w.claim_id) AS total_claim
    FROM stores AS st
    JOIN sales AS s
        ON s.store_id = st.store_id
    JOIN warranty AS w
        ON s.sale_id = w.sale_id
    GROUP BY st.country
) AS subquery
ORDER BY percentage_of_risk DESC;

WITH yearly_sale AS (
    SELECT 
        st.store_id,
        st.store_name,
        EXTRACT(YEAR FROM s.sale_date) AS year_of_sale,
        SUM(s.quantity * p.price) AS total_sale
    FROM stores AS st
    JOIN sales AS s
        ON s.store_id = st.store_id
    JOIN products AS p
        ON p.product_id = s.product_id
    GROUP BY st.store_id, st.store_name, year_of_sale
    ORDER BY st.store_id, year_of_sale
),
growth_ratio AS (
    SELECT 
        store_name,
        year_of_sale,
        total_sale,
        LAG(total_sale) OVER (PARTITION BY store_name ORDER BY year_of_sale) AS prev_sale
    FROM yearly_sale
)
SELECT
    store_name,
    year_of_sale,
    prev_sale,
    total_sale AS curr_sale,
    ROUND(((total_sale - prev_sale)::numeric /prev_sale::numeric) * 100, 2) AS growth_ratio_YOY
FROM growth_ratio
WHERE prev_sale IS NOT NULL
ORDER BY store_name, year_of_sale;

SELECT 
    CASE 
        WHEN p.price < 500 THEN 'Low Cost'
        WHEN p.price BETWEEN 500 AND 1000 THEN 'Moderate Cost'
        ELSE 'High Cost'
    END AS price_segment,
    c.category_name,
    COUNT(w.claim_id) AS total_claims,
    COUNT(s.sale_id) AS total_sales,
    ROUND((COUNT(w.claim_id)::NUMERIC / NULLIF(COUNT(s.sale_id), 0)) * 100, 2) AS claim_rate_percentage,
    ROUND(AVG(p.price)::NUMERIC, 2) AS avg_price_in_segment
FROM products AS p
JOIN sales AS s
    ON p.product_id = s.product_id
LEFT JOIN warranty AS w
    ON w.sale_id = s.sale_id
JOIN category AS c
    ON p.category_id = c.category_id
WHERE s.sale_date >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY price_segment, c.category_name
ORDER BY claim_rate_percentage DESC;

WITH monthly_sales AS (
    SELECT
        s.store_id,
        EXTRACT(YEAR FROM s.sale_date) AS year,
        EXTRACT(MONTH FROM s.sale_date) AS month,
        SUM(p.price * s.quantity) AS total_sales
    FROM sales AS s
    JOIN products AS p
        ON s.product_id = p.product_id
    WHERE s.sale_date >= CURRENT_DATE - INTERVAL '4 years'
    GROUP BY s.store_id, year, month
    ORDER BY s.store_id, year, month
)
SELECT
    store_id, 
    year, 
    month, 
    total_sales, 
    SUM(total_sales) OVER(PARTITION BY store_id ORDER BY year, month) AS running_total
FROM monthly_sales
ORDER BY store_id, year, month;