SELECT current_database();
CREATE TABLE supermarket_analysis (
    invoice_id VARCHAR(30),
    branch VARCHAR(5),
    city VARCHAR(50),
    customer_type VARCHAR(30),
    gender VARCHAR(20),
    product_line VARCHAR(100),
    unit_price NUMERIC(10, 2),
    quantity INTEGER,
    tax_5 NUMERIC(10, 4),
    sales NUMERIC(12, 4),
    sale_date DATE,
    sale_time TIME,
    payment VARCHAR(30),
    cogs NUMERIC(12, 4),
    gross_margin_percentage NUMERIC(10, 6),
    gross_income NUMERIC(12, 4),
    rating NUMERIC(4, 2)
);

SELECT table_catalog, table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'supermarket_analysis';

SELECT COUNT(*) FROM supermarket_analysis;

SELECT *
FROM supermarket_analysis
LIMIT 10;

SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'supermarket_analysis'
ORDER BY ordinal_position;


SELECT
    COUNT(*) AS total_rows,
    COUNT(invoice_id) AS invoice_id_present,
    COUNT(branch) AS branch_present,
    COUNT(city) AS city_present,
    COUNT(customer_type) AS customer_type_present,
    COUNT(gender) AS gender_present,
    COUNT(product_line) AS product_line_present,
    COUNT(unit_price) AS unit_price_present,
    COUNT(quantity) AS quantity_present,
    COUNT(tax_5) AS tax_5_present,
    COUNT(sales) AS sales_present,
    COUNT(sale_date) AS sale_date_present,
    COUNT(sale_time) AS sale_time_present,
    COUNT(payment) AS payment_present,
    COUNT(cogs) AS cogs_present,
    COUNT(gross_margin_percentage) AS gross_margin_present,
    COUNT(gross_income) AS gross_income_present,
    COUNT(rating) AS rating_present
FROM supermarket_analysis;
-- FINDING:
-- All 17 columns contain 1,000 non-NULL values.
-- No missing NULL values were found.





-- 1.3 CHECK FOR DUPLICATE INVOICE IDs
SELECT
    invoice_id,
    COUNT(*) AS number_of_records
FROM supermarket_analysis
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY number_of_records DESC;
-- FINDING:
-- No duplicate invoice IDs were found.


-- =====================================================
-- 1.4 CHECK FOR IDENTICAL DUPLICATE ROWS
-- Purpose: Check whether any complete records are repeated.
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        invoice_id,
        branch,
        city,
        customer_type,
        gender,
        product_line,
        unit_price,
        quantity,
        tax_5,
        sales,
        sale_date,
        sale_time,
        payment,
        cogs,
        gross_margin_percentage,
        gross_income,
        rating
    )) AS unique_rows
FROM supermarket_analysis;

-- FINDING:
-- Total rows: 1000.
-- Unique rows: 1000.
-- No completely identical duplicate rows were found.


-- =====================================================
-- 1.5 CHECK THE SALES DATE RANGE
-- Purpose: Find the earliest and latest sales dates.
-- =====================================================

SELECT
    MIN(sale_date) AS earliest_sale_date,
    MAX(sale_date) AS latest_sale_date,
    COUNT(DISTINCT sale_date) AS number_of_sales_days
FROM supermarket_analysis;

-- FINDING:
-- Earliest sale date: 2019-01-01..
-- Latest sale date: 2019-03-30.
-- Number of distinct sales days: 89.
-- These results show the period covered by the dataset.

-- =====================================================
-- 1.6 CHECK FOR INVALID NUMERIC VALUES
-- Purpose: Identify zero, negative, or out-of-range values.
-- =====================================================

SELECT
    COUNT(*) FILTER (WHERE unit_price <= 0) AS invalid_unit_prices,
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantities,
    COUNT(*) FILTER (WHERE sales <= 0) AS invalid_sales,
    COUNT(*) FILTER (WHERE cogs <= 0) AS invalid_cogs,
    COUNT(*) FILTER (WHERE gross_income <= 0) AS invalid_gross_income,
    COUNT(*) FILTER (WHERE rating < 0 OR rating > 10) AS invalid_ratings
FROM supermarket_analysis;

-- FINDING:
-- Invalid unit prices: 0.
-- Invalid quantities: 0.
-- Invalid sales: 0.
-- Invalid COGS: 0.
-- Invalid gross income: 0.
-- Invalid ratings: 0.
-- Investigate any unexpected values before analysis.


-- =====================================================
-- 1.7A CHECK DISTINCT BRANCHES AND CITIES
-- Purpose: Identify the branches and cities in the dataset.
-- =====================================================

SELECT DISTINCT
    branch,
    city
FROM supermarket_analysis
ORDER BY city;
-- FINDING:
-- Branch Alex: Yangon.
-- Branch Cairo: Mandalay.
-- Branch Giza: Naypyitaw.
-- The dataset contains three branches across three cities.


-- =====================================================
-- 1.7A VERIFY BRANCH AND CITY COMBINATIONS
-- Purpose: Confirm each branch's associated city.
-- =====================================================

SELECT
    branch,
    city,
    COUNT(*) AS number_of_records
FROM supermarket_analysis
GROUP BY branch, city
ORDER BY branch, city;

FINDING:
-- Alex is associated with Yangon: 340 records.
-- Cairo is associated with Mandalay: 332 records.
-- Giza is associated with Naypyitaw: 328 records.
-- Total records across the three branch-city combinations: 1000.
-- Each branch is associated with one city in this dataset.
-- The original CSV uses Alex, Cairo, and Giza as branch values.
-- These values will be preserved without modification

-- =====================================================
--  CHECK DISTINCT CUSTOMER AND SALES CATEGORIES
-- Purpose: Identify the categories in the dataset.
-- =====================================================

SELECT DISTINCT
    customer_type,
    gender,
    product_line,
    payment
FROM supermarket_analysis
ORDER BY customer_type, gender, product_line, payment;

-- FINDING:
-- Record the customer types, genders, product lines,
-- and payment methods found in the results.


-- =====================================================
-- 1.7B CHECK DISTINCT CUSTOMER AND SALES CATEGORIES
-- Purpose: Count records in each category.
-- =====================================================

SELECT
    'Customer Type' AS category_type,
    customer_type AS category_name,
    COUNT(*) AS number_of_records
FROM supermarket_analysis
GROUP BY customer_type

UNION ALL

SELECT
    'Gender' AS category_type,
    gender AS category_name,
    COUNT(*) AS number_of_records
FROM supermarket_analysis
GROUP BY gender

UNION ALL

SELECT
    'Product Line' AS category_type,
    product_line AS category_name,
    COUNT(*) AS number_of_records
FROM supermarket_analysis
GROUP BY product_line

UNION ALL

SELECT
    'Payment Method' AS category_type,
    payment AS category_name,
    COUNT(*) AS number_of_records
FROM supermarket_analysis
GROUP BY payment

ORDER BY category_type, category_name;

-- FINDING:
-- Customer Type:
-- Member: 565 records.
-- Normal: 435 records.
--
-- Gender:
-- Female: 571 records.
-- Male: 429 records.
--
-- Payment Method:
-- Cash: 344 records.
-- Credit card: 311 records.
-- Ewallet: 345 records.
--
-- Product Line:
-- Electronic accessories: 170 records.
-- Fashion accessories: 178 records.
-- Food and beverages: 174 records.
-- Health and beauty: 152 records.
-- Home and lifestyle: 160 records.
-- Sports and travel: 166 records.
--
-- All category counts sum to 1000 records within
-- each of the four category groups.

-- =====================================================
-- 1.8 CHECK FOR LEADING OR TRAILING SPACES
-- Purpose: Identify text values with extra spaces.
-- =====================================================

SELECT
    COUNT(*) FILTER (
        WHERE branch <> TRIM(branch)
    ) AS branch_spacing_issues,

    COUNT(*) FILTER (
        WHERE city <> TRIM(city)
    ) AS city_spacing_issues,

    COUNT(*) FILTER (
        WHERE customer_type <> TRIM(customer_type)
    ) AS customer_type_spacing_issues,

    COUNT(*) FILTER (
        WHERE gender <> TRIM(gender)
    ) AS gender_spacing_issues,

    COUNT(*) FILTER (
        WHERE product_line <> TRIM(product_line)
    ) AS product_line_spacing_issues,

    COUNT(*) FILTER (
        WHERE payment <> TRIM(payment)
    ) AS payment_spacing_issues

FROM supermarket_analysis;

-- FINDING:
-- Branch spacing issues: 0.
-- City spacing issues: 0.
-- Customer type spacing issues: 0.
-- Gender spacing issues: 0.
-- Product line spacing issues: 0.
-- Payment spacing issues: 0.
-- No leading or trailing spaces were detected in
-- the six text columns checked.




-- =====================================================
-- 2.1 TOTAL SALES BY CITY
-- Purpose: Compare sales revenue across cities.
-- =====================================================

SELECT
    city,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY city
ORDER BY total_sales DESC;

-- FINDING:
-- Naypyitaw generated the highest sales: 110568.71.
-- Yangon generated sales of 106200.37.
-- Mandalay generated the lowest sales: 106197.67.
-- Naypyitaw outperformed Mandalay by 4371.04.
-- Yangon and Mandalay had very similar total sales.


-- =====================================================
-- 2.2 TOTAL SALES BY PRODUCT LINE
-- Purpose: Identify the highest- and lowest-selling
-- product lines by total sales revenue.
-- =====================================================

SELECT
    product_line,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY product_line
ORDER BY total_sales DESC;

-- FINDING:
-- Food and beverages generated the highest sales: 56144.84.
-- Sports and travel ranked second: 55122.83.
-- Health and beauty generated the lowest sales: 49193.74.
-- Food and beverages exceeded Health and beauty by 6951.10.
-- Electronic accessories and Fashion accessories had
-- very similar total sales.


-- BUSINESS INTERPRETATION:
-- Food and beverages was the highest-performing product line
-- by revenue in this dataset.
-- Health and beauty had the lowest revenue and may deserve
-- further investigation.
-- Electronic accessories and Fashion accessories had
-- very similar sales, differing by only 31.63.


-- =====================================================
-- 2.3 TOTAL SALES BY BRANCH
-- Purpose: Compare total sales across branches.
-- =====================================================

SELECT
    branch,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY branch
ORDER BY total_sales DESC;

-- FINDING:
-- Giza generated the highest sales: 110568.71.
-- Alex generated sales of 106200.37.
-- Cairo generated the lowest sales: 106197.67.
-- Giza exceeded Cairo by 4371.04.
-- Alex and Cairo had almost identical sales,
-- differing by only 2.70.

-- BUSINESS INTERPRETATION:
-- Giza was the strongest branch by total sales revenue.
-- Alex and Cairo achieved very similar sales.
-- Further analysis of quantities sold, product lines,
-- and gross income could help explain these differences.

-- =====================================================
-- 2.4 TOTAL GROSS INCOME BY BRANCH
-- Purpose: Compare gross income across branches.
-- =====================================================

SELECT
    branch,
    ROUND(SUM(gross_income), 2) AS total_gross_income
FROM supermarket_analysis
GROUP BY branch
ORDER BY total_gross_income DESC;

-- FINDING:
-- Giza generated the highest gross income: 5265.18.
-- Alex generated gross income of 5057.16.
-- Cairo generated the lowest gross income: 5057.03.
-- Giza exceeded Cairo by 208.15.
-- Alex and Cairo differed by only 0.13.

-- BUSINESS INTERPRETATION:
-- Giza led the three branches in both total sales
-- and total gross income.
-- Alex and Cairo recorded almost identical gross income.
-- Further analysis of gross income as a percentage of sales
-- can help compare their relative performance.





-- =====================================================
-- 2.5 AVERAGE CUSTOMER RATING BY BRANCH
-- Purpose: Compare customer ratings across branches.
-- =====================================================

SELECT
    branch,
    ROUND(AVG(rating), 2) AS average_rating
FROM supermarket_analysis
GROUP BY branch
ORDER BY average_rating DESC;

-- FINDING:
-- Giza had the highest average customer rating: 7.07.
-- Alex had an average customer rating of 7.03.
-- Cairo had the lowest average customer rating: 6.82.
-- Giza's average rating exceeded Cairo's by 0.25.

-- BUSINESS INTERPRETATION:
-- Giza ranked highest in sales, gross income, and
-- average customer rating among the three branches.
-- Cairo had the lowest average customer rating.
-- Further investigation of customer feedback and
-- service factors may help explain the rating differences.


-- =====================================================
-- 2.6 TOTAL SALES BY PAYMENT METHOD
-- Purpose: Compare sales revenue by payment method.
-- =====================================================

SELECT
    payment,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY payment
ORDER BY total_sales DESC;

-- FINDING:
-- Cash generated the highest sales: 112206.57.
-- Ewallet generated sales of 109993.11.
-- Credit card generated the lowest sales: 100767.07.
-- Cash exceeded Credit card sales by 11439.50.
-- Cash and Ewallet were the two highest contributors
-- to total sales revenue.

-- BUSINESS INTERPRETATION:
-- Cash was the leading payment method by sales revenue.
-- Credit card had the lowest total sales among the
-- three payment methods.
-- The business could investigate payment preferences
-- and customer convenience before changing payment options.


-- =====================================================
-- 2.7 TOTAL SALES BY CUSTOMER TYPE
-- Purpose: Compare sales revenue from customer types.
-- =====================================================

SELECT
    customer_type,
    COUNT(*) AS number_of_transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(sales), 2) AS average_transaction_sales
FROM supermarket_analysis
GROUP BY customer_type
ORDER BY total_sales DESC;

-- FINDING:
-- Member transactions: 565.
-- Normal customer transactions: 435.
-- Member total sales: 189694.76.
-- Normal customer total sales: 133271.99.
-- Member average transaction sales: 335.74.
-- Normal average transaction sales: 306.37.
-- Members generated 56422.77 more sales than Normal customers.

-- BUSINESS INTERPRETATION:
-- Members contributed more total sales than Normal customers.
-- Members also had a higher average transaction value.
-- Members generated more revenue through both a higher
-- transaction count and a higher average transaction value.
-- The business could investigate which membership benefits
-- encourage repeat purchases and higher spending.



-- =====================================================
-- 2.8 SALES ANALYSIS BY GENDER
-- Purpose: Compare transaction count, total sales,
-- and average transaction sales by gender.
-- =====================================================

SELECT
    gender,
    COUNT(*) AS number_of_transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(AVG(sales), 2) AS average_transaction_sales
FROM supermarket_analysis
GROUP BY gender
ORDER BY total_sales DESC;

-- FINDINGS:
-- Female transactions: 571.
-- Male transactions: 429.
-- Female total sales: 194671.84.
-- Male total sales: 128294.91.
-- Female average transaction sales: 340.93.
-- Male average transaction sales: 299.06.
-- Female customers generated 66376.93 more sales than male customers.
-- Female average transaction sales exceeded male average
-- transaction sales by 41.87.

-- BUSINESS INTERPRETATION:
-- Female customers contributed more total sales than male customers.
-- Female transactions were also higher on average.
-- The difference in total sales reflects both the higher
-- number of female transactions and their higher average
-- transaction value.
-- The supermarket could investigate product preferences
-- and purchasing patterns across customer groups.
-- These results show an association, not the cause of
-- differences in spending.



-- =====================================================
-- 2.9 TOTAL QUANTITY SOLD BY PRODUCT LINE
-- Purpose: Identify product lines with the highest
-- number of items sold.
-- =====================================================

SELECT
    product_line,
    SUM(quantity) AS total_quantity_sold
FROM supermarket_analysis
GROUP BY product_line
ORDER BY total_quantity_sold DESC;


-- FINDINGS:
-- Electronic accessories had the highest quantity sold: 971 items.
-- Food and beverages ranked second: 952 items.
-- Sports and travel sold 920 items.
-- Home and lifestyle sold 911 items.
-- Fashion accessories sold 902 items.
-- Health and beauty had the lowest quantity sold: 854 items.
-- Electronic accessories sold 117 more items than Health and beauty.
-- Food and beverages generated the highest sales revenue,
-- while Electronic accessories sold the most items.

-- BUSINESS INTERPRETATION:
-- Electronic accessories led in quantity sold but did not
-- generate the highest total sales revenue.
-- Food and beverages generated the highest revenue despite
-- selling fewer items than Electronic accessories.
-- This suggests that differences in item prices and sales
-- quantities both contribute to revenue differences.
-- The supermarket can examine pricing and product demand
-- when making stocking and sales decisions.



-- =====================================================
-- 2.10 MONTHLY SALES TREND
-- Purpose: Compare total sales across months.
-- =====================================================

SELECT
    EXTRACT(MONTH FROM sale_date) AS sales_month,
    TO_CHAR(sale_date, 'Month') AS month_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY
    EXTRACT(MONTH FROM sale_date),
    TO_CHAR(sale_date, 'Month')
ORDER BY sales_month;


-- FINDINGS:
-- January recorded the highest total sales: 116291.87.
-- February recorded the lowest total sales: 97219.37.
-- March recorded total sales of 109455.51.
-- Sales decreased by 19072.50 from January to February.
-- Sales increased by 12236.14 from February to March.
-- March sales remained 6836.36 below January sales.

-- BUSINESS INTERPRETATION:
-- January was the strongest month by total sales revenue.
-- Sales declined in February before recovering in March.
-- Although sales recovered in March, they did not reach
-- January's level.
-- The supermarket could investigate seasonal demand,
-- promotions, and product availability to understand
-- the monthly changes.
-- These results show changes in revenue, but do not
-- establish the reasons for those changes.



-- =====================================================
-- 2.11 TOTAL SALES BY HOUR
-- Purpose: Identify the hours with the highest sales.
-- =====================================================

SELECT
    EXTRACT(HOUR FROM sale_time) AS sales_hour,
    COUNT(*) AS number_of_transactions,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY EXTRACT(HOUR FROM sale_time)
ORDER BY total_sales DESC;


-- FINDINGS:
-- 07:00 recorded the highest sales among the hours shown:
-- 39699.51 from 113 transactions.
-- 01:00 ranked second with sales of 34723.23
-- from 103 transactions.
-- 10:00 ranked third with sales of 31421.48
-- from 101 transactions.
-- 08:00 had the lowest sales among the hours shown:
-- 22969.53 from 75 transactions.
-- Confirm that the query returned all hours before
-- identifying the lowest-selling hour for the full day.

-- BUSINESS INTERPRETATION:
-- Sales activity varied across the hours shown.
-- 07:00 generated the highest revenue among these results.
-- The supermarket could review transaction patterns
-- when planning staff schedules and checkout coverage.
-- These results alone do not explain why sales varied.


-- =====================================================
-- CHECK ALL HOURS IN CHRONOLOGICAL ORDER
-- Purpose: Confirm which hours appear in the dataset.
-- =====================================================

SELECT
    EXTRACT(HOUR FROM sale_time) AS sales_hour,
    COUNT(*) AS number_of_transactions,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY EXTRACT(HOUR FROM sale_time)
ORDER BY sales_hour;


-- FINDINGS:
-- 07:00 recorded the highest total sales: 39699.51,
-- from 113 transactions.
-- 01:00 ranked second in total sales: 34723.23,
-- from 103 transactions.
-- 10:00 ranked third in total sales: 31421.48,
-- from 101 transactions.
-- 08:00 recorded the lowest total sales among the
-- hours returned: 22969.53, from 75 transactions.
-- Hour 9 did not appear in the query results.
-- The query results show 11 distinct hours.

-- BUSINESS INTERPRETATION:
-- 07:00 was the strongest sales hour among the
-- hours returned by this query.
-- Sales revenue varied across the reported hours.
-- The supermarket could use hourly sales patterns
-- to help plan staffing and checkout coverage.
-- Further investigation would be needed to explain
-- why sales vary across hours.



-- =====================================================
-- 2.12 TOTAL GROSS INCOME BY PRODUCT LINE
-- Purpose: Compare gross income across product lines.
-- Skills: SUM(), GROUP BY, ORDER BY.
-- =====================================================

SELECT
    product_line,
    ROUND(SUM(gross_income), 2) AS total_gross_income
FROM supermarket_analysis
GROUP BY product_line
ORDER BY total_gross_income DESC;


-- FINDINGS:
-- Food and beverages generated the highest gross income: 2673.56.
-- Sports and travel ranked second: 2624.90.
-- Electronic accessories ranked third: 2587.50.
-- Fashion accessories generated gross income of 2586.00.
-- Home and lifestyle generated gross income of 2564.85.
-- Health and beauty generated the lowest gross income: 2342.56.
-- Food and beverages exceeded Health and beauty by 331.00.
-- Food and beverages ranked highest in both total sales
-- and total gross income.

-- BUSINESS INTERPRETATION:
-- Food and beverages contributed the most gross income.
-- Health and beauty contributed the least gross income.
-- Electronic accessories sold the highest quantity of items,
-- but Food and beverages generated the highest revenue
-- and gross income.
-- The supermarket should compare sales, quantities,
-- and gross income before deciding which products to promote.
-- Gross income is not the same as net profit because
-- other operating expenses have not been deducted.



-- =====================================================
-- 2.13 GROSS INCOME PERCENTAGE BY PRODUCT LINE
-- Purpose: Compare gross income relative to sales.
-- =====================================================

SELECT
    product_line,
    ROUND(
        100.0 * SUM(gross_income) / NULLIF(SUM(sales), 0),
        2
    ) AS gross_income_percentage
FROM supermarket_analysis
GROUP BY product_line
ORDER BY gross_income_percentage DESC;


-- FINDINGS:
-- Fashion accessories gross income percentage: 4.76%.
-- Electronic accessories gross income percentage: 4.76%.
-- Health and beauty gross income percentage: 4.76%.
-- Food and beverages gross income percentage: 4.76%.
-- Sports and travel gross income percentage: 4.76%.
-- Home and lifestyle gross income percentage: 4.76%.
-- All six product lines have the same gross income percentage
-- when rounded to two decimal places.

-- BUSINESS INTERPRETATION:
-- Gross income is approximately 4.76% of sales revenue
-- across all six product lines.
-- Differences in total gross income are mainly associated
-- with differences in total sales revenue, given the same
-- gross-income percentage.
-- Because the result is rounded to two decimal places,
-- the underlying percentages may differ slightly.



-- =====================================================
-- 2.14 BRANCH PERFORMANCE COMPARISON USING A CTE
-- Purpose: Compare key performance measures by branch.
-- =====================================================

WITH branch_summary AS (
    SELECT
        branch,
        SUM(sales) AS total_sales,
        SUM(gross_income) AS total_gross_income,
        AVG(rating) AS average_rating
    FROM supermarket_analysis
    GROUP BY branch
)
SELECT
    branch,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_gross_income, 2) AS total_gross_income,
    ROUND(average_rating, 2) AS average_rating
FROM branch_summary
ORDER BY total_sales DESC;


-- FINDINGS:
-- Giza had the highest total sales: 110568.71.
-- Giza had the highest total gross income: 5265.18.
-- Giza had the highest average customer rating: 7.07.
-- Alex recorded total sales of 106200.37,
-- gross income of 5057.16, and average rating of 7.03.
-- Cairo recorded the lowest total sales: 106197.67.
-- Cairo recorded the lowest gross income: 5057.03.
-- Cairo recorded the lowest average rating: 6.82.
-- Giza led all three branches across the three measures.

-- BUSINESS INTERPRETATION:
-- Giza performed strongest across sales, gross income,
-- and average customer rating.
-- Cairo may benefit from further investigation into
-- customer feedback and sales performance.
-- These results identify differences in performance
-- but do not establish their causes.



-- =====================================================
-- 2.15 CLASSIFY SALES TRANSACTIONS USING CASE
-- Purpose: Group transactions into sales-value bands.
-- =====================================================

SELECT
    CASE
        WHEN sales >= 500 THEN 'High'
        WHEN sales >= 200 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category,
    COUNT(*) AS number_of_transactions,
    ROUND(SUM(sales), 2) AS total_sales
FROM supermarket_analysis
GROUP BY
    CASE
        WHEN sales >= 500 THEN 'High'
        WHEN sales >= 200 THEN 'Medium'
        ELSE 'Low'
    END
ORDER BY total_sales DESC;


-- FINDINGS:
-- High-value transactions: 227 transactions.
-- High-value transaction sales total: 159554.63.
-- Medium-value transactions: 363 transactions.
-- Medium-value transaction sales total: 119743.98.
-- Low-value transactions: 410 transactions.
-- Low-value transaction sales total: 43668.14.
-- Low-value transactions were the most frequent category.
-- High-value transactions contributed the most total sales.
-- High-value transactions generated 159554.63 in sales,
-- while Low-value transactions generated 43668.14.

-- BUSINESS INTERPRETATION:
-- High-value transactions contributed the largest share
-- of total sales despite being the smallest category by
-- transaction count.
-- Low-value transactions were the most frequent but
-- contributed the least total sales.
-- The supermarket could examine purchasing patterns
-- to understand what distinguishes higher-value purchases.
-- The categories use thresholds chosen for this analysis
-- and are not official supermarket classifications.
