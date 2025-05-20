# Apple Retail Sales SQL Project Analyzing
![banner](https://github.com/Ahasanul-Hossain/Apple-Retail-Sales-Analysis/blob/main/background.jpg)

### Overview
This project involves analyzing millions of rows of sales data for Apple retail stores to derive actionable insights, optimize queries, and improve data performance using SQL. The dataset is designed to simulate a realistic sales environment, encompassing stores, products, categories, sales, and warranty claims.

### The project includes:

1. Data schema design and table creation.
2. Exploratory Data Analysis (EDA).
3. Query optimizations using indexing to enhance performance.
4. Solving key business problems through SQL queries.

## Key Features
- **Database Schema:** A well-structured relational database comprising five tables: stores, products, categories, sales, and warranty.
- **Performance Optimization:** Created indexes on frequently queried columns, improving query execution time significantly for large datasets.
- **Business Problem Analysis:** Tackles real-world business scenarios like sales trends, warranty claims analysis, and product performance.
- **Advanced Querying:** Includes window functions, subqueries, Common Table Expressions (CTEs), and aggregate functions.

## Database Schema
 ![Database Schema](https://github.com/Ahasanul-Hossain/Apple-Retail-Sales-Analysis/blob/main/erd.jpg)

### Tables
1. `stores`: Contains information about store locations, including `store_id`, `store_name`, `city`, and `country`.
2. `category`: Represents product categories, identified by `category_id` and `category_name`.
3. `products`: Stores product details like `product_id`, `product_name`, `category_id`, `launch_date`, and `price`.
4. `sales`: Tracks sales transactions with details like `sale_id`, `sale_date`, `store_id`, `product_id`, and `quantity`.
5. `warranty`: Logs warranty claims with `claim_id`, c`laim_date`, `sale_id`, and `repair_status`.


## Performance Optimization
To handle millions of rows and ensure high performance, indexes were created on the following columns:

1. `sales(product_id)`: Improved query execution time for product-based sales analysis.
2. `sales(store_id)`: Enhanced performance when filtering sales by store.
3. `sales(sale_date)`: Accelerated date-based queries for identifying trends and seasonal patterns.
4. `sales(quantity)`: Boosted queries requiring analysis of sales volume thresholds.


## Example Performance Improvement

#### Filtering by Product ID
- Query: `SELECT * FROM sales WHERE product_id = 'P-40'; `

  - **Without Index:** Execution Time ~260 ms
  - **With Index:** Execution Time ~161 ms

#### Filtering by Sale Date
- Query: `SELECT * FROM sales WHERE sale_date = '2020-04-18'; `

  - **Without Index:** Execution Time ~133 ms
  - **With Index:** Execution Time ~0.9 ms
   
Indexes significantly reduced execution time, ensuring scalable performance for large datasets.

## Business Problems Solved
Here are some of the key questions and insights derived:

1. **Stores by Country:** Identify the number of stores in each country.
2. **Total Units Sold by Store:** Calculate the total sales volume per store.
3. **Seasonal Sales Trends:** Analyze sales patterns in December 2023.
4. **Warranty Claims Analysis:**
   - Percentage of rejected claims.
   - Claims filed within 180 days of product sale.
   - Products with the highest claims in the last two years.

5. **Sales Performance:**
   - Best-selling day for each store.
   - Year-over-year growth ratio for each store.
   - Monthly running totals over four years.
     
6. **Product Analysis:**
   - Average price per category.
   - Least-selling products by country and year.
   - Correlation between product price and warranty claims.



The project is split into three tiers of questions to test SQL skills of increasing complexity:

### Easy to Medium (10 Questions)
1. Find the number of stores in each country.
2. Calculate the total number of units sold by each store.
3. Identify how many sales occurred in December 2023.
4. Determine how many stores have never had a warranty claim filed.
5. Calculate the percentage of warranty claims marked as "Warranty Void".
6. Identify which store had the highest total units sold in the last year.
7. Count the number of unique products sold in the last year.
8. Find the average price of products in each category.
9. How many warranty claims were filed in 2020?
10. For each store, identify the best-selling day based on highest quantity sold.
### Medium to Hard (5 Questions)
11. Identify the least selling product in each country for each year based on total units sold.
12. Calculate how many warranty claims were filed within 180 days of a product sale.
13. Determine how many warranty claims were filed for products launched in the last two years.
14. List the months in the last three years where sales exceeded 5,000 units in the USA.
15. Identify the product category with the most warranty claims filed in the last two years.
### Complex (5 Questions)
16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
17. Analyze the year-by-year growth ratio for each store.
18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
19. Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
20. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.

## SQL Queries and Analysis
This project contains a variety of SQL queries structured around Exploratory Data Analysis (EDA) and Business Problem Solving. Some of the key SQL queries include:

### Exploratory Data Analysis

```sql

SELECT DISTINCT repair_status FROM warranty;
SELECT DISTINCT store_name FROM stores;
SELECT DISTINCT category_name FROM category;
```

Count of Total Sales:

```sql
SELECT COUNT(*) AS total_sales FROM sales;
```
Execution Plan Optimization: Using EXPLAIN ANALYZE to optimize query performance by creating necessary indexes:

```sql
CREATE INDEX sales_product_id ON sales(product_id);
EXPLAIN ANALYZE `SELECT * FROM sales WHERE product_id = 'P-40';`
```

## Business Problem Queries

**Identify the least selling product in each country for each year based on total units sold.**

```sql
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

```
#### Result:
|country       |sale_year|product_name                 |total_unit_sold|least_sold_product|
|--------------|---------|-----------------------------|---------------|------------------|
|Australia     |2,020    |MagSafe Charger              |988            |1                 |
|Australia     |2,021    |Mac Mini (M2)                |994            |1                 |
|Australia     |2,022    |MacBook Air (M1)             |1,017          |1                 |
|Australia     |2,023    |AirPods (3rd Generation)     |1,037          |1                 |
|Australia     |2,024    |iPhone 14 Pro                |880            |1                 |
|Austria       |2,020    |Mac Pro (2023)               |97             |1                 |
|Austria       |2,021    |Apple Arcade                 |116            |1                 |
|Austria       |2,022    |Apple Pencil (2nd Generation)|100            |1                 |
|Austria       |2,023    |Apple One                    |79             |1                 |
|Austria       |2,024    |Apple Watch Series 7         |62             |1                 |
|Canada        |2,020    |Apple One                    |652            |1                 |
|Canada        |2,021    |Beats Solo Pro               |709            |1                 |
|Canada        |2,021    |AirTag                       |709            |1                 |
|Canada        |2,022    |iMac with Retina Display     |689            |1                 |
|Canada        |2,023    |HomePod                      |729            |1                 |
|Canada        |2,024    |Beats Solo Pro               |564            |1                 |
|China         |2,020    |iPhone 12                    |922            |1                 |
|China         |2,021    |Apple Arcade                 |1,001          |1                 |
|China         |2,022    |AirPods Max                  |1,032          |1                 |
|China         |2,023    |Apple TV 4K                  |1,041          |1                 |
|China         |2,024    |iPhone 13                    |867            |1                 |
|Colombia      |2,020    |Beats Studio Buds            |244            |1                 |
|Colombia      |2,021    |Beats Solo Pro               |224            |1                 |
|Colombia      |2,022    |AirPods Pro (2nd Generation) |259            |1                 |
|Colombia      |2,023    |Beats Studio Buds            |253            |1                 |
|Colombia      |2,023    |iPhone 13 Pro                |253            |1                 |
|Colombia      |2,024    |Smart Keyboard Folio         |181            |1                 |
|France        |2,020    |iPad (9th Generation)        |518            |1                 |
|France        |2,021    |Leather Case for iPhone      |507            |1                 |
|France        |2,022    |MacBook Pro 14-inch          |498            |1                 |
|France        |2,023    |iPhone SE (3rd Generation)   |529            |1                 |
|France        |2,024    |iPad Pro (M2)                |486            |1                 |
|France        |2,024    |iCloud                       |486            |1                 |
|Germany       |2,020    |iPad Pro (M2)                |389            |1                 |
|Germany       |2,021    |MacBook (Early 2015)         |416            |1                 |
|Germany       |2,022    |MacBook Pro (Touch Bar)      |342            |1                 |
|Germany       |2,023    |iPhone 13 Pro                |336            |1                 |
|Germany       |2,024    |Apple Arcade                 |346            |1                 |
|Italy         |2,020    |iPad mini (6th Generation)   |192            |1                 |
|Italy         |2,021    |iPad (10th Generation)       |243            |1                 |
|Italy         |2,022    |iPhone 13 mini               |248            |1                 |
|Italy         |2,023    |Apple Watch Series 8         |254            |1                 |
|Italy         |2,024    |iMac 24-inch                 |215            |1                 |
|Japan         |2,020    |Mac Mini (M2)                |832            |1                 |
|Japan         |2,021    |MagSafe Charger              |858            |1                 |
|Japan         |2,022    |Mac Studio                   |886            |1                 |
|Japan         |2,023    |iPhone 13 Pro                |886            |1                 |
|Japan         |2,024    |iPhone 12 Pro Max            |686            |1                 |
|Mexico        |2,020    |Apple Watch Hermès           |335            |1                 |
|Mexico        |2,021    |Apple News+                  |387            |1                 |
|Mexico        |2,022    |Apple Fitness+               |368            |1                 |
|Mexico        |2,023    |AirPods (3rd Generation)     |387            |1                 |
|Mexico        |2,024    |iPhone 12 mini               |336            |1                 |
|Netherlands   |2,020    |iPhone 14 Plus               |109            |1                 |
|Netherlands   |2,021    |iPad (9th Generation)        |102            |1                 |
|Netherlands   |2,022    |Apple Watch Series 8         |102            |1                 |
|Netherlands   |2,023    |Apple Watch Series 6         |111            |1                 |
|Netherlands   |2,024    |MacBook Pro 13-inch          |71             |1                 |
|Singapore     |2,020    |iPad (9th Generation)        |414            |1                 |
|Singapore     |2,021    |iMac Pro                     |385            |1                 |
|Singapore     |2,022    |Apple Arcade                 |388            |1                 |
|Singapore     |2,023    |Apple Watch Series 7         |342            |1                 |
|Singapore     |2,024    |Lightning to USB Cable       |331            |1                 |
|South Korea   |2,020    |iPhone 12                    |268            |1                 |
|South Korea   |2,021    |MacBook Pro 13-inch          |243            |1                 |
|South Korea   |2,022    |iPhone 12 mini               |234            |1                 |
|South Korea   |2,023    |iPhone 14 Pro                |229            |1                 |
|South Korea   |2,023    |Apple Watch Hermès           |229            |1                 |
|South Korea   |2,024    |iPhone 14 Pro Max            |222            |1                 |
|Spain         |2,020    |AirPods (3rd Generation)     |93             |1                 |
|Spain         |2,021    |Mac Studio                   |90             |1                 |
|Spain         |2,022    |iPhone 12 mini               |99             |1                 |
|Spain         |2,023    |iMac 24-inch                 |102            |1                 |
|Spain         |2,024    |Magic Keyboard with Touch ID |86             |1                 |
|Taiwan        |2,020    |iPhone 14                    |101            |1                 |
|Taiwan        |2,021    |iPhone 14 Pro                |102            |1                 |
|Taiwan        |2,022    |Apple News+                  |108            |1                 |
|Taiwan        |2,023    |iPhone 13 Pro                |109            |1                 |
|Taiwan        |2,023    |Apple Watch Ultra            |109            |1                 |
|Taiwan        |2,024    |Apple Watch Series 5         |86             |1                 |
|Thailand      |2,020    |iMac 27-inch                 |376            |1                 |
|Thailand      |2,021    |iPhone 12 Pro                |371            |1                 |
|Thailand      |2,022    |iPad Pro (M1)                |365            |1                 |
|Thailand      |2,023    |Magic Trackpad               |375            |1                 |
|Thailand      |2,024    |MacBook (Early 2015)         |355            |1                 |
|UAE           |2,020    |MacBook Air (M2)             |729            |1                 |
|UAE           |2,021    |Apple Music                  |690            |1                 |
|UAE           |2,022    |Beats Fit Pro                |693            |1                 |
|UAE           |2,023    |Beats Solo Pro               |672            |1                 |
|UAE           |2,024    |MacBook Pro 16-inch          |550            |1                 |
|United Kingdom|2,020    |iPhone 13                    |589            |1                 |
|United Kingdom|2,020    |Apple Fitness+               |589            |1                 |
|United Kingdom|2,021    |MacBook Pro 13-inch          |569            |1                 |
|United Kingdom|2,022    |Apple One                    |533            |1                 |
|United Kingdom|2,023    |MacBook Pro (Touch Bar)      |506            |1                 |
|United Kingdom|2,024    |Apple Fitness+               |454            |1                 |
|United States |2,020    |Mac Studio                   |2,231          |1                 |
|United States |2,021    |Magic Keyboard               |2,250          |1                 |
|United States |2,022    |Mac Pro (2023)               |2,309          |1                 |
|United States |2,023    |iPhone 14 Pro                |2,287          |1                 |
|United States |2,024    |Beats Powerbeats Pro         |1,976          |1                 |


**Determine the percentage chance of receiving warranty claims after each purchase for each country.**

```sql
SELECT 
    country,
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
```

#### Result:
|country       |total_sold|total_claim|percentage_of_risk|
|--------------|----------|-----------|------------------|
|Taiwan        |2,211     |419        |18.95             |
|Netherlands   |2,279     |428        |18.78             |
|Austria       |2,399     |448        |18.67             |
|Spain         |1,833     |340        |18.55             |
|United Kingdom|8,779     |1,624      |18.5              |
|Canada        |11,007    |2,035      |18.49             |
|UAE           |11,089    |2,046      |18.45             |
|Germany       |6,522     |1,201      |18.41             |
|United States |33,257    |6,086      |18.3              |
|Colombia      |4,122     |752        |18.24             |
|Singapore     |6,588     |1,198      |18.18             |
|Thailand      |6,390     |1,159      |18.14             |
|Italy         |4,159     |754        |18.13             |
|Australia     |15,614    |2,827      |18.11             |
|China         |14,997    |2,713      |18.09             |
|Mexico        |6,559     |1,186      |18.08             |
|France        |8,766     |1,585      |18.08             |
|Japan         |13,411    |2,417      |18.02             |
|South Korea   |4,377     |782        |17.87             |


**Analyze the year-by-year growth ratio for each store.**

```sql
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
```
#### Result:
|store_name                 |year_of_sale|prev_sale |curr_sale |growth_ratio_yoy|
|---------------------------|------------|----------|----------|----------------|
|Apple Ala Moana            |2,021       |16,736,679|16,351,838|-2.3            |
|Apple Ala Moana            |2,022       |16,351,838|16,679,728|2.01            |
|Apple Ala Moana            |2,023       |16,679,728|17,286,752|3.64            |
|Apple Ala Moana            |2,024       |17,286,752|15,215,747|-11.98          |
|Apple Andino               |2,021       |15,873,867|16,657,275|4.94            |
|Apple Andino               |2,022       |16,657,275|16,807,255|0.9             |
|Apple Andino               |2,023       |16,807,255|16,452,478|-2.11           |
|Apple Andino               |2,024       |16,452,478|14,591,539|-11.31          |
|Apple Antara               |2,021       |16,614,977|16,516,324|-0.59           |
|Apple Antara               |2,022       |16,516,324|16,625,607|0.66            |
|Apple Antara               |2,023       |16,625,607|15,789,600|-5.03           |
|Apple Antara               |2,024       |15,789,600|14,795,003|-6.3            |
|Apple Beijing SKP          |2,021       |17,004,025|16,967,537|-0.21           |
|Apple Beijing SKP          |2,022       |16,967,537|17,293,828|1.92            |
|Apple Beijing SKP          |2,023       |17,293,828|16,793,173|-2.89           |
|Apple Beijing SKP          |2,024       |16,793,173|14,943,387|-11.02          |
|Apple Beverly Center       |2,021       |16,876,768|16,086,769|-4.68           |
|Apple Beverly Center       |2,022       |16,086,769|16,653,180|3.52            |
|Apple Beverly Center       |2,023       |16,653,180|16,945,007|1.75            |
|Apple Beverly Center       |2,024       |16,945,007|14,566,532|-14.04          |
|Apple Bondi                |2,021       |16,887,187|16,883,063|-0.02           |
|Apple Bondi                |2,022       |16,883,063|17,019,946|0.81            |
|Apple Bondi                |2,023       |17,019,946|17,071,375|0.3             |
|Apple Bondi                |2,024       |17,071,375|14,609,316|-14.42          |
|Apple Brisbane             |2,021       |16,595,011|16,631,907|0.22            |
|Apple Brisbane             |2,022       |16,631,907|17,331,952|4.21            |
|Apple Brisbane             |2,023       |17,331,952|16,535,603|-4.59           |
|Apple Brisbane             |2,024       |16,535,603|14,848,573|-10.2           |
|Apple Brompton Road        |2,021       |16,543,572|16,817,041|1.65            |
|Apple Brompton Road        |2,022       |16,817,041|17,268,520|2.68            |
|Apple Brompton Road        |2,023       |17,268,520|17,274,012|0.03            |
|Apple Brompton Road        |2,024       |17,274,012|14,829,268|-14.15          |
|Apple Causeway Bay         |2,021       |16,217,564|16,329,794|0.69            |
|Apple Causeway Bay         |2,022       |16,329,794|16,556,057|1.39            |
|Apple Causeway Bay         |2,023       |16,556,057|16,338,141|-1.32           |
|Apple Causeway Bay         |2,024       |16,338,141|15,128,546|-7.4            |
|Apple Central World        |2,020       |16,900,783|16,737,584|-0.97           |
|Apple Central World        |2,021       |16,737,584|17,587,247|5.08            |
|Apple Central World        |2,021       |17,587,247|16,521,137|-6.06           |
|Apple Central World        |2,022       |16,521,137|16,552,500|0.19            |
|Apple Central World        |2,022       |16,552,500|16,757,899|1.24            |
|Apple Central World        |2,023       |16,757,899|16,178,600|-3.46           |
|Apple Central World        |2,023       |16,178,600|16,293,686|0.71            |
|Apple Central World        |2,024       |16,293,686|14,664,121|-10             |
|Apple Central World        |2,024       |14,664,121|14,358,652|-2.08           |
|Apple Chadstone            |2,020       |17,194,561|16,641,988|-3.21           |
|Apple Chadstone            |2,021       |16,641,988|17,077,403|2.62            |
|Apple Chadstone            |2,021       |17,077,403|17,576,467|2.92            |
|Apple Chadstone            |2,022       |17,576,467|16,503,668|-6.1            |
|Apple Chadstone            |2,022       |16,503,668|17,086,781|3.53            |
|Apple Chadstone            |2,023       |17,086,781|16,496,988|-3.45           |
|Apple Chadstone            |2,023       |16,496,988|16,681,479|1.12            |
|Apple Chadstone            |2,024       |16,681,479|14,768,814|-11.47          |
|Apple Chadstone            |2,024       |14,768,814|15,191,874|2.86            |
|Apple Champs-Elysees       |2,020       |16,220,268|16,193,935|-0.16           |
|Apple Champs-Elysees       |2,021       |16,193,935|17,783,250|9.81            |
|Apple Champs-Elysees       |2,021       |17,783,250|16,197,630|-8.92           |
|Apple Champs-Elysees       |2,022       |16,197,630|16,262,504|0.4             |
|Apple Champs-Elysees       |2,022       |16,262,504|17,002,218|4.55            |
|Apple Champs-Elysees       |2,023       |17,002,218|16,443,884|-3.28           |
|Apple Champs-Elysees       |2,023       |16,443,884|16,682,533|1.45            |
|Apple Champs-Elysees       |2,024       |16,682,533|14,210,184|-14.82          |
|Apple Champs-Elysees       |2,024       |14,210,184|14,724,024|3.62            |
|Apple Cotai Central        |2,021       |16,509,235|16,287,979|-1.34           |
|Apple Cotai Central        |2,022       |16,287,979|17,030,008|4.56            |
|Apple Cotai Central        |2,023       |17,030,008|16,982,928|-0.28           |
|Apple Cotai Central        |2,024       |16,982,928|14,628,580|-13.86          |
|Apple Covent Garden        |2,020       |17,173,470|17,843,504|3.9             |
|Apple Covent Garden        |2,021       |17,843,504|16,422,867|-7.96           |
|Apple Covent Garden        |2,021       |16,422,867|17,599,849|7.17            |
|Apple Covent Garden        |2,022       |17,599,849|16,181,356|-8.06           |
|Apple Covent Garden        |2,022       |16,181,356|17,161,737|6.06            |
|Apple Covent Garden        |2,023       |17,161,737|16,390,635|-4.49           |
|Apple Covent Garden        |2,023       |16,390,635|16,953,194|3.43            |
|Apple Covent Garden        |2,024       |16,953,194|15,124,787|-10.79          |
|Apple Covent Garden        |2,024       |15,124,787|14,324,761|-5.29           |
|Apple Downtown Brooklyn    |2,021       |16,463,899|16,777,417|1.9             |
|Apple Downtown Brooklyn    |2,022       |16,777,417|17,309,222|3.17            |
|Apple Downtown Brooklyn    |2,023       |17,309,222|16,812,155|-2.87           |
|Apple Downtown Brooklyn    |2,024       |16,812,155|14,368,054|-14.54          |
|Apple Dubai Mall           |2,021       |17,296,938|17,527,392|1.33            |
|Apple Dubai Mall           |2,022       |17,527,392|17,374,781|-0.87           |
|Apple Dubai Mall           |2,023       |17,374,781|17,679,302|1.75            |
|Apple Dubai Mall           |2,024       |17,679,302|14,599,613|-17.42          |
|Apple Eaton Centre         |2,021       |17,091,740|17,371,424|1.64            |
|Apple Eaton Centre         |2,022       |17,371,424|17,201,648|-0.98           |
|Apple Eaton Centre         |2,023       |17,201,648|16,436,396|-4.45           |
|Apple Eaton Centre         |2,024       |16,436,396|14,362,857|-12.62          |
|Apple Fifth Avenue         |2,021       |17,410,280|16,879,172|-3.05           |
|Apple Fifth Avenue         |2,022       |16,879,172|17,265,607|2.29            |
|Apple Fifth Avenue         |2,023       |17,265,607|17,075,387|-1.1            |
|Apple Fifth Avenue         |2,024       |17,075,387|14,930,907|-12.56          |
|Apple Fukuoka              |2,021       |17,076,767|16,776,096|-1.76           |
|Apple Fukuoka              |2,022       |16,776,096|17,143,882|2.19            |
|Apple Fukuoka              |2,023       |17,143,882|16,989,876|-0.9            |
|Apple Fukuoka              |2,024       |16,989,876|15,589,787|-8.24           |
|Apple Galeries Lafayette   |2,021       |16,730,483|16,479,199|-1.5            |
|Apple Galeries Lafayette   |2,022       |16,479,199|16,259,933|-1.33           |
|Apple Galeries Lafayette   |2,023       |16,259,933|17,035,781|4.77            |
|Apple Galeries Lafayette   |2,024       |17,035,781|15,111,612|-11.29          |
|Apple Gangnam              |2,021       |17,541,273|17,242,674|-1.7            |
|Apple Gangnam              |2,022       |17,242,674|17,045,905|-1.14           |
|Apple Gangnam              |2,023       |17,045,905|16,623,645|-2.48           |
|Apple Gangnam              |2,024       |16,623,645|15,027,720|-9.6            |
|Apple Grand Central        |2,021       |16,946,762|16,928,986|-0.1            |
|Apple Grand Central        |2,022       |16,928,986|17,360,439|2.55            |
|Apple Grand Central        |2,023       |17,360,439|16,304,186|-6.08           |
|Apple Grand Central        |2,024       |16,304,186|14,459,254|-11.32          |
|Apple Highpoint            |2,021       |17,380,551|16,582,128|-4.59           |
|Apple Highpoint            |2,022       |16,582,128|17,452,044|5.25            |
|Apple Highpoint            |2,023       |17,452,044|16,654,028|-4.57           |
|Apple Highpoint            |2,024       |16,654,028|14,691,566|-11.78          |
|Apple Iconsiam             |2,021       |17,045,677|16,818,971|-1.33           |
|Apple Iconsiam             |2,022       |16,818,971|17,150,593|1.97            |
|Apple Iconsiam             |2,023       |17,150,593|16,885,294|-1.55           |
|Apple Iconsiam             |2,024       |16,885,294|14,465,213|-14.33          |
|Apple Jewel Changi Airport |2,021       |17,146,316|16,802,031|-2.01           |
|Apple Jewel Changi Airport |2,022       |16,802,031|17,048,626|1.47            |
|Apple Jewel Changi Airport |2,023       |17,048,626|16,511,663|-3.15           |
|Apple Jewel Changi Airport |2,024       |16,511,663|14,704,999|-10.94          |
|Apple Kaerntner Strasse    |2,021       |16,846,043|17,216,199|2.2             |
|Apple Kaerntner Strasse    |2,022       |17,216,199|17,028,772|-1.09           |
|Apple Kaerntner Strasse    |2,023       |17,028,772|16,474,436|-3.26           |
|Apple Kaerntner Strasse    |2,024       |16,474,436|14,533,694|-11.78          |
|Apple Kumamoto             |2,021       |17,444,853|17,115,364|-1.89           |
|Apple Kumamoto             |2,022       |17,115,364|16,930,806|-1.08           |
|Apple Kumamoto             |2,023       |16,930,806|16,669,947|-1.54           |
|Apple Kumamoto             |2,024       |16,669,947|14,325,652|-14.06          |
|Apple Kurfuerstendamm      |2,021       |16,862,712|17,512,571|3.85            |
|Apple Kurfuerstendamm      |2,022       |17,512,571|17,172,236|-1.94           |
|Apple Kurfuerstendamm      |2,023       |17,172,236|17,029,194|-0.83           |
|Apple Kurfuerstendamm      |2,024       |17,029,194|14,800,362|-13.09          |
|Apple Kyoto                |2,021       |17,173,564|17,369,410|1.14            |
|Apple Kyoto                |2,022       |17,369,410|17,026,079|-1.98           |
|Apple Kyoto                |2,023       |17,026,079|17,269,888|1.43            |
|Apple Kyoto                |2,024       |17,269,888|14,867,652|-13.91          |
|Apple Leidseplein          |2,021       |17,127,930|17,113,108|-0.09           |
|Apple Leidseplein          |2,022       |17,113,108|16,877,865|-1.37           |
|Apple Leidseplein          |2,023       |16,877,865|16,898,708|0.12            |
|Apple Leidseplein          |2,024       |16,898,708|14,980,859|-11.35          |
|Apple Mall of the Emirates |2,021       |16,456,278|16,884,111|2.6             |
|Apple Mall of the Emirates |2,022       |16,884,111|17,015,788|0.78            |
|Apple Mall of the Emirates |2,023       |17,015,788|16,447,670|-3.34           |
|Apple Mall of the Emirates |2,024       |16,447,670|14,392,289|-12.5           |
|Apple Marunouchi           |2,021       |17,430,041|16,621,733|-4.64           |
|Apple Marunouchi           |2,022       |16,621,733|16,154,549|-2.81           |
|Apple Marunouchi           |2,023       |16,154,549|17,409,118|7.77            |
|Apple Marunouchi           |2,024       |17,409,118|14,627,741|-15.98          |
|Apple Metrotown            |2,021       |17,036,656|16,905,882|-0.77           |
|Apple Metrotown            |2,022       |16,905,882|16,899,010|-0.04           |
|Apple Metrotown            |2,023       |16,899,010|16,457,709|-2.61           |
|Apple Metrotown            |2,024       |16,457,709|14,810,061|-10.01          |
|Apple Michigan Avenue      |2,021       |17,274,370|17,252,405|-0.13           |
|Apple Michigan Avenue      |2,022       |17,252,405|16,825,554|-2.47           |
|Apple Michigan Avenue      |2,023       |16,825,554|16,707,540|-0.7            |
|Apple Michigan Avenue      |2,024       |16,707,540|14,309,824|-14.35          |
|Apple Nanjing East         |2,021       |17,085,255|16,703,293|-2.24           |
|Apple Nanjing East         |2,022       |16,703,293|16,642,690|-0.36           |
|Apple Nanjing East         |2,023       |16,642,690|17,559,103|5.51            |
|Apple Nanjing East         |2,024       |17,559,103|15,152,839|-13.7           |
|Apple North Michigan Avenue|2,021       |16,604,969|16,470,223|-0.81           |
|Apple North Michigan Avenue|2,022       |16,470,223|17,255,693|4.77            |
|Apple North Michigan Avenue|2,023       |17,255,693|16,811,782|-2.57           |
|Apple North Michigan Avenue|2,024       |16,811,782|15,655,964|-6.88           |
|Apple Omotesando           |2,021       |17,517,498|16,916,480|-3.43           |
|Apple Omotesando           |2,022       |16,916,480|16,495,738|-2.49           |
|Apple Omotesando           |2,023       |16,495,738|17,489,807|6.03            |
|Apple Omotesando           |2,024       |17,489,807|14,649,450|-16.24          |
|Apple Opera                |2,021       |16,881,427|17,407,636|3.12            |
|Apple Opera                |2,022       |17,407,636|16,758,812|-3.73           |
|Apple Opera                |2,023       |16,758,812|16,358,819|-2.39           |
|Apple Opera                |2,024       |16,358,819|14,915,636|-8.82           |
|Apple Orchard Road         |2,020       |16,745,965|17,615,953|5.2             |
|Apple Orchard Road         |2,021       |17,615,953|16,486,113|-6.41           |
|Apple Orchard Road         |2,021       |16,486,113|16,389,576|-0.59           |
|Apple Orchard Road         |2,022       |16,389,576|17,105,598|4.37            |
|Apple Orchard Road         |2,022       |17,105,598|16,630,334|-2.78           |
|Apple Orchard Road         |2,023       |16,630,334|16,420,009|-1.26           |
|Apple Orchard Road         |2,023       |16,420,009|16,533,503|0.69            |
|Apple Orchard Road         |2,024       |16,533,503|14,424,546|-12.76          |
|Apple Orchard Road         |2,024       |14,424,546|14,357,778|-0.46           |
|Apple Park Visitor Center  |2,021       |16,260,968|16,299,826|0.24            |
|Apple Park Visitor Center  |2,022       |16,299,826|17,203,458|5.54            |
|Apple Park Visitor Center  |2,023       |17,203,458|17,371,700|0.98            |
|Apple Park Visitor Center  |2,024       |17,371,700|14,137,274|-18.62          |
|Apple Parque La Colina     |2,021       |16,481,821|17,128,899|3.93            |
|Apple Parque La Colina     |2,022       |17,128,899|16,400,079|-4.25           |
|Apple Parque La Colina     |2,023       |16,400,079|16,778,869|2.31            |
|Apple Parque La Colina     |2,024       |16,778,869|14,800,544|-11.79          |
|Apple Passeig de Gracia    |2,021       |16,866,798|16,645,771|-1.31           |
|Apple Passeig de Gracia    |2,022       |16,645,771|16,184,317|-2.77           |
|Apple Passeig de Gracia    |2,023       |16,184,317|16,421,506|1.47            |
|Apple Passeig de Gracia    |2,024       |16,421,506|14,619,388|-10.97          |
|Apple Piazza Liberty       |2,021       |16,533,884|16,301,733|-1.4            |
|Apple Piazza Liberty       |2,022       |16,301,733|16,621,413|1.96            |
|Apple Piazza Liberty       |2,023       |16,621,413|16,411,640|-1.26           |
|Apple Piazza Liberty       |2,024       |16,411,640|14,630,790|-10.85          |
|Apple Pioneer Place        |2,021       |17,075,552|16,765,756|-1.81           |
|Apple Pioneer Place        |2,022       |16,765,756|17,071,551|1.82            |
|Apple Pioneer Place        |2,023       |17,071,551|16,766,619|-1.79           |


 
**Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.**

```sql
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
```

#### Result:
|price_segment|category_name       |total_claims|total_sales|claim_rate_percentage|avg_price_in_segment|
|-------------|--------------------|------------|-----------|---------------------|--------------------|
|Low Cost     |Smartphone          |335         |10,684     |3.14                 |308                 |
|High Cost    |Smart Speaker       |339         |10,890     |3.11                 |1,202               |
|Moderate Cost|Audio               |1,319       |43,170     |3.06                 |662.28              |
|Moderate Cost|Tablet              |658         |21,596     |3.05                 |761.46              |
|Low Cost     |Laptop              |325         |10,816     |3                    |231                 |
|Low Cost     |Subscription Service|961         |32,036     |3                    |381.07              |
|Low Cost     |Audio               |324         |10,822     |2.99                 |438                 |
|Moderate Cost|Smartphone          |1,586       |53,997     |2.94                 |717.11              |
|Moderate Cost|Desktop             |1,257       |43,037     |2.92                 |680.14              |
|High Cost    |Desktop             |941         |32,179     |2.92                 |1,475.1             |
|High Cost    |Accessories         |2,524       |86,372     |2.92                 |1,337.23            |
|High Cost    |Laptop              |2,171       |74,903     |2.9                  |1,456.28            |
|Moderate Cost|Laptop              |618         |21,381     |2.89                 |754.49              |
|High Cost    |Tablet              |2,490       |86,204     |2.89                 |1,657.35            |
|High Cost    |Smartphone          |2,158       |75,037     |2.88                 |1,370.31            |
|High Cost    |Subscription Service|624         |21,650     |2.88                 |1,570.54            |
|High Cost    |Audio               |1,848       |64,461     |2.87                 |1,547.22            |
|Low Cost     |Accessories         |613         |21,417     |2.86                 |340.29              |
|Low Cost     |Wearable            |616         |21,673     |2.84                 |403.65              |
|Moderate Cost|Wearable            |306         |10,829     |2.83                 |884                 |
|Low Cost     |Smart Speaker       |305         |10,823     |2.82                 |266                 |
|Low Cost     |Desktop             |913         |32,426     |2.82                 |415.95              |
|High Cost    |Wearable            |1,808       |64,701     |2.79                 |1,436.98            |
|Moderate Cost|Subscription Service|587         |21,408     |2.74                 |736.66              |
|Moderate Cost|Accessories         |1,175       |43,118     |2.73                 |760.81              |
|High Cost    |Streaming Device    |584         |21,392     |2.73                 |1,256.51            |
|Low Cost     |Streaming Device    |284         |10,807     |2.63                 |477                 |

 
**Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.**

```sql
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
```
#### Result:
|store_id|year |month|total_sales|running_total|
|--------|-----|-----|-----------|-------------|
|ST-1    |2,021|5    |480,619    |480,619      |
|ST-1    |2,021|6    |1,380,019  |1,860,638    |
|ST-1    |2,021|7    |1,318,086  |3,178,724    |
|ST-1    |2,021|8    |1,271,789  |4,450,513    |
|ST-1    |2,021|9    |1,296,530  |5,747,043    |
|ST-1    |2,021|10   |1,606,143  |7,353,186    |
|ST-1    |2,021|11   |1,476,165  |8,829,351    |
|ST-1    |2,021|12   |1,481,015  |10,310,366   |
|ST-1    |2,022|1    |1,469,377  |11,779,743   |
|ST-1    |2,022|2    |1,370,718  |13,150,461   |
|ST-1    |2,022|3    |1,294,805  |14,445,266   |
|ST-1    |2,022|4    |1,240,299  |15,685,565   |
|ST-1    |2,022|5    |1,534,922  |17,220,487   |
|ST-1    |2,022|6    |1,587,339  |18,807,826   |
|ST-1    |2,022|7    |1,423,418  |20,231,244   |
|ST-1    |2,022|8    |1,381,683  |21,612,927   |
|ST-1    |2,022|9    |1,584,850  |23,197,777   |
|ST-1    |2,022|10   |1,315,100  |24,512,877   |
|ST-1    |2,022|11   |1,430,156  |25,943,033   |
|ST-1    |2,022|12   |1,632,940  |27,575,973   |
|ST-1    |2,023|1    |1,602,612  |29,178,585   |
|ST-1    |2,023|2    |1,301,856  |30,480,441   |
|ST-1    |2,023|3    |1,475,547  |31,955,988   |
|ST-1    |2,023|4    |1,638,956  |33,594,944   |
|ST-1    |2,023|5    |1,103,570  |34,698,514   |
|ST-1    |2,023|6    |1,446,671  |36,145,185   |
|ST-1    |2,023|7    |1,593,767  |37,738,952   |
|ST-1    |2,023|8    |1,448,332  |39,187,284   |
|ST-1    |2,023|9    |1,245,181  |40,432,465   |
|ST-1    |2,023|10   |1,577,354  |42,009,819   |
|ST-1    |2,023|11   |1,299,646  |43,309,465   |
|ST-1    |2,023|12   |1,341,895  |44,651,360   |
|ST-1    |2,024|1    |1,320,377  |45,971,737   |
|ST-1    |2,024|2    |1,349,218  |47,320,955   |
|ST-1    |2,024|3    |1,455,335  |48,776,290   |
|ST-1    |2,024|4    |1,447,359  |50,223,649   |
|ST-1    |2,024|5    |1,284,718  |51,508,367   |
|ST-1    |2,024|6    |1,394,606  |52,902,973   |
|ST-1    |2,024|7    |1,552,433  |54,455,406   |
|ST-1    |2,024|8    |1,359,214  |55,814,620   |
|ST-1    |2,024|9    |1,457,734  |57,272,354   |
|ST-1    |2,024|10   |1,291,399  |58,563,753   |
|ST-1    |2,024|11   |502,841    |59,066,594   |
|ST-1    |2,024|12   |515,673    |59,582,267   |
|ST-10   |2,021|5    |550,933    |550,933      |
|ST-10   |2,021|6    |1,241,164  |1,792,097    |
|ST-10   |2,021|7    |1,315,259  |3,107,356    |
|ST-10   |2,021|8    |1,599,700  |4,707,056    |
|ST-10   |2,021|9    |1,362,893  |6,069,949    |
|ST-10   |2,021|10   |1,393,487  |7,463,436    |
|ST-10   |2,021|11   |1,566,031  |9,029,467    |
|ST-10   |2,021|12   |1,367,718  |10,397,185   |
|ST-10   |2,022|1    |1,500,446  |11,897,631   |
|ST-10   |2,022|2    |1,443,230  |13,340,861   |
|ST-10   |2,022|3    |1,421,788  |14,762,649   |
|ST-10   |2,022|4    |1,541,442  |16,304,091   |
|ST-10   |2,022|5    |1,244,951  |17,549,042   |
|ST-10   |2,022|6    |1,339,197  |18,888,239   |
|ST-10   |2,022|7    |1,402,083  |20,290,322   |
|ST-10   |2,022|8    |1,424,013  |21,714,335   |
|ST-10   |2,022|9    |1,505,615  |23,219,950   |
|ST-10   |2,022|10   |1,469,620  |24,689,570   |
|ST-10   |2,022|11   |1,549,198  |26,238,768   |
|ST-10   |2,022|12   |1,456,523  |27,695,291   |
|ST-10   |2,023|1    |1,240,106  |28,935,397   |
|ST-10   |2,023|2    |1,257,541  |30,192,938   |
|ST-10   |2,023|3    |1,475,229  |31,668,167   |
|ST-10   |2,023|4    |1,436,120  |33,104,287   |
|ST-10   |2,023|5    |1,463,263  |34,567,550   |
|ST-10   |2,023|6    |1,180,039  |35,747,589   |
|ST-10   |2,023|7    |1,506,083  |37,253,672   |
|ST-10   |2,023|8    |1,495,124  |38,748,796   |
|ST-10   |2,023|9    |1,230,911  |39,979,707   |
|ST-10   |2,023|10   |1,386,769  |41,366,476   |
|ST-10   |2,023|11   |1,402,405  |42,768,881   |
|ST-10   |2,023|12   |1,329,367  |44,098,248   |
|ST-10   |2,024|1    |1,252,241  |45,350,489   |
|ST-10   |2,024|2    |1,421,757  |46,772,246   |
|ST-10   |2,024|3    |1,163,174  |47,935,420   |
|ST-10   |2,024|4    |1,468,453  |49,403,873   |
|ST-10   |2,024|5    |1,472,390  |50,876,263   |
|ST-10   |2,024|6    |1,102,938  |51,979,201   |
|ST-10   |2,024|7    |1,450,904  |53,430,105   |
|ST-10   |2,024|8    |1,489,612  |54,919,717   |
|ST-10   |2,024|9    |1,176,080  |56,095,797   |
|ST-10   |2,024|10   |1,194,312  |57,290,109   |
|ST-10   |2,024|11   |413,660    |57,703,769   |
|ST-10   |2,024|12   |501,401    |58,205,170   |
|ST-11   |2,021|5    |552,220    |552,220      |
|ST-11   |2,021|6    |1,382,715  |1,934,935    |
|ST-11   |2,021|7    |1,448,650  |3,383,585    |
|ST-11   |2,021|8    |1,366,006  |4,749,591    |
|ST-11   |2,021|9    |1,350,611  |6,100,202    |
|ST-11   |2,021|10   |1,454,387  |7,554,589    |
|ST-11   |2,021|11   |1,325,436  |8,880,025    |
|ST-11   |2,021|12   |1,406,248  |10,286,273   |
|ST-11   |2,022|1    |1,477,978  |11,764,251   |
|ST-11   |2,022|2    |1,097,507  |12,861,758   |
|ST-11   |2,022|3    |1,439,740  |14,301,498   |
|ST-11   |2,022|4    |1,556,588  |15,858,086   |
|ST-11   |2,022|5    |1,339,589  |17,197,675   |
|ST-11   |2,022|6    |1,360,835  |18,558,510   |
|ST-11   |2,022|7    |1,547,734  |20,106,244   |
|ST-11   |2,022|8    |1,403,943  |21,510,187   |
|ST-11   |2,022|9    |1,424,250  |22,934,437   |
|ST-11   |2,022|10   |1,360,286  |24,294,723   |
|ST-11   |2,022|11   |1,354,849  |25,649,572   |
|ST-11   |2,022|12   |1,316,429  |26,966,001   |
|ST-11   |2,023|1    |1,498,490  |28,464,491   |
|ST-11   |2,023|2    |1,449,243  |29,913,734   |
|ST-11   |2,023|3    |1,270,654  |31,184,388   |
|ST-11   |2,023|4    |1,350,272  |32,534,660   |
|ST-11   |2,023|5    |1,626,088  |34,160,748   |
|ST-11   |2,023|6    |1,169,388  |35,330,136   |
|ST-11   |2,023|7    |1,588,149  |36,918,285   |
|ST-11   |2,023|8    |1,585,716  |38,504,001   |
|ST-11   |2,023|9    |1,445,113  |39,949,114   |
|ST-11   |2,023|10   |1,381,614  |41,330,728   |
|ST-11   |2,023|11   |1,336,720  |42,667,448   |
|ST-11   |2,023|12   |1,585,305  |44,252,753   |
|ST-11   |2,024|1    |1,558,951  |45,811,704   |
|ST-11   |2,024|2    |1,268,207  |47,079,911   |
|ST-11   |2,024|3    |1,343,297  |48,423,208   |
|ST-11   |2,024|4    |1,363,384  |49,786,592   |
|ST-11   |2,024|5    |1,461,762  |51,248,354   |
|ST-11   |2,024|6    |1,424,015  |52,672,369   |
|ST-11   |2,024|7    |1,398,402  |54,070,771   |
|ST-11   |2,024|8    |1,582,498  |55,653,269   |
|ST-11   |2,024|9    |1,333,965  |56,987,234   |
|ST-11   |2,024|10   |1,372,339  |58,359,573   |
|ST-11   |2,024|11   |577,989    |58,937,562   |
|ST-11   |2,024|12   |530,938    |59,468,500   |
|ST-12   |2,021|5    |530,251    |530,251      |
|ST-12   |2,021|6    |1,390,938  |1,921,189    |
|ST-12   |2,021|7    |1,447,851  |3,369,040    |
|ST-12   |2,021|8    |1,362,507  |4,731,547    |
|ST-12   |2,021|9    |1,509,544  |6,241,091    |
|ST-12   |2,021|10   |1,262,552  |7,503,643    |
|ST-12   |2,021|11   |1,314,016  |8,817,659    |
|ST-12   |2,021|12   |1,610,516  |10,428,175   |
|ST-12   |2,022|1    |1,300,822  |11,728,997   |
|ST-12   |2,022|2    |1,424,732  |13,153,729   |
|ST-12   |2,022|3    |1,487,966  |14,641,695   |
|ST-12   |2,022|4    |1,283,337  |15,925,032   |
|ST-12   |2,022|5    |1,376,057  |17,301,089   |
|ST-12   |2,022|6    |1,672,209  |18,973,298   |
|ST-12   |2,022|7    |1,617,426  |20,590,724   |
|ST-12   |2,022|8    |1,335,568  |21,926,292   |
|ST-12   |2,022|9    |1,232,366  |23,158,658   |
|ST-12   |2,022|10   |1,576,656  |24,735,314   |
|ST-12   |2,022|11   |1,465,785  |26,201,099   |
|ST-12   |2,022|12   |1,482,769  |27,683,868   |
|ST-12   |2,023|1    |1,379,385  |29,063,253   |
|ST-12   |2,023|2    |1,445,976  |30,509,229   |
|ST-12   |2,023|3    |1,330,346  |31,839,575   |
|ST-12   |2,023|4    |1,314,205  |33,153,780   |
|ST-12   |2,023|5    |1,530,515  |34,684,295   |
|ST-12   |2,023|6    |1,308,337  |35,992,632   |
|ST-12   |2,023|7    |1,548,155  |37,540,787   |
|ST-12   |2,023|8    |1,469,246  |39,010,033   |
|ST-12   |2,023|9    |1,430,479  |40,440,512   |
|ST-12   |2,023|10   |1,393,566  |41,834,078   |
|ST-12   |2,023|11   |1,304,224  |43,138,302   |
|ST-12   |2,023|12   |1,357,348  |44,495,650   |
|ST-12   |2,024|1    |1,418,536  |45,914,186   |
|ST-12   |2,024|2    |1,409,056  |47,323,242   |
|ST-12   |2,024|3    |1,610,159  |48,933,401   |
|ST-12   |2,024|4    |1,517,381  |50,450,782   |
|ST-12   |2,024|5    |1,517,987  |51,968,769   |
|ST-12   |2,024|6    |1,495,364  |53,464,133   |
|ST-12   |2,024|7    |1,350,782  |54,814,915   |
|ST-12   |2,024|8    |1,460,156  |56,275,071   |
|ST-12   |2,024|9    |1,401,347  |57,676,418   |
|ST-12   |2,024|10   |1,365,004  |59,041,422   |
|ST-12   |2,024|11   |576,013    |59,617,435   |
|ST-12   |2,024|12   |534,179    |60,151,614   |
|ST-13   |2,021|5    |498,529    |498,529      |
|ST-13   |2,021|6    |1,284,188  |1,782,717    |
|ST-13   |2,021|7    |1,217,890  |3,000,607    |
|ST-13   |2,021|8    |1,326,242  |4,326,849    |
|ST-13   |2,021|9    |1,259,893  |5,586,742    |
|ST-13   |2,021|10   |1,555,086  |7,141,828    |
|ST-13   |2,021|11   |1,410,743  |8,552,571    |
|ST-13   |2,021|12   |1,475,308  |10,027,879   |
|ST-13   |2,022|1    |1,277,025  |11,304,904   |
|ST-13   |2,022|2    |1,417,656  |12,722,560   |
|ST-13   |2,022|3    |1,570,728  |14,293,288   |
|ST-13   |2,022|4    |1,369,393  |15,662,681   |
|ST-13   |2,022|5    |1,354,512  |17,017,193   |
|ST-13   |2,022|6    |1,519,957  |18,537,150   |
|ST-13   |2,022|7    |1,501,616  |20,038,766   |
|ST-13   |2,022|8    |1,466,037  |21,504,803   |
|ST-13   |2,022|9    |1,330,834  |22,835,637   |
|ST-13   |2,022|10   |1,458,480  |24,294,117   |
|ST-13   |2,022|11   |1,550,439  |25,844,556   |
|ST-13   |2,022|12   |1,452,504  |27,297,060   |
|ST-13   |2,023|1    |1,367,908  |28,664,968   |
|ST-13   |2,023|2    |1,148,343  |29,813,311   |
|ST-13   |2,023|3    |1,206,666  |31,019,977   |
|ST-13   |2,023|4    |1,336,610  |32,356,587   |


## Technologies Used
- Database: PostgreSQL
- SQL Concepts:
    - Window Functions
    - Common Table Expressions (CTEs)
    - Indexing
    - Subqueries and Joins
    - Aggregate Functions


## How to Use
1. Clone the repository to your local machine.
2. Execute the SQL script to create the database schema and populate tables.
3. Run the provided queries to explore insights and solve business problems.

## Future Improvements
- Automate indexing based on query logs.
- Implement partitioning for the sales table to further enhance performance.
- Integrate visualizations to represent trends and insights.


## Key Learnings
- **SQL Performance Optimization:** How to use indexing and EXPLAIN ANALYZE to speed up query execution.
- **Business Problem Solving with SQL:** Applying SQL to solve real-world business questions related to sales performance, warranty claims, and product analysis.
- **Data Insights:** Extracting actionable insights from large datasets to drive decisions in retail management.

## Contributions
Contributions are welcome! If you find any improvements or issues, feel free to fork this repository and submit a pull request.
