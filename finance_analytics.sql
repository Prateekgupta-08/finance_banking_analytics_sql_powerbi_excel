-- ================================================================
--  FINANCE ANALYTICS PROJECT — MySQL Script
--  Author       : [Your Name]
--  Dataset      : 50,069 Transactions | 5,000 Customers | 2023-2025
--  Tool         : MySQL Workbench
--  GitHub Repo  : github.com/your-username/finance-analytics
-- ================================================================
--  HOW TO USE
--  1. Run Section 0 to create DB and tables.
--  2. Import your CSVs via Table Data Import Wizard in Workbench
--     OR use the LOAD DATA examples at the bottom.
--  3. Run each section independently — every query is self-contained.
-- ================================================================


-- ================================================================
-- SECTION 0 : DATABASE & TABLE SETUP
-- ================================================================

CREATE DATABASE IF NOT EXISTS finance_analytics;
USE finance_analytics;

-- ---- Drop tables if they already exist (clean re-run) ----------
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;

-- ---- customers table ------------------------------------------
CREATE TABLE customers (
    customer_id        VARCHAR(10)     NOT NULL PRIMARY KEY,
    fisrt_name         VARCHAR(50),          -- column name kept as-is from CSV
    second_name        VARCHAR(50),
    gender             VARCHAR(10),
    date_of_birth      DATE,
    city               VARCHAR(100),
    state              VARCHAR(100),
    occupation         VARCHAR(50),
    customer_segment   VARCHAR(20),   -- Retail | Premium | SME | Corporate | Wealth
    annual_income      DECIMAL(15,2),
    join_date          DATE
);

-- ---- transactions table ----------------------------------------
CREATE TABLE transactions (
    transaction_id      VARCHAR(20)    NOT NULL PRIMARY KEY,
    transaction_date    DATE,
    account_id          VARCHAR(20),
    customer_id         VARCHAR(10),
    transaction_type    VARCHAR(30),  -- Bill Payment | Card Payment | Deposit | Fee Charge
                                      -- Interest Credit | Investment | Loan EMI
                                      -- Refund | Transfer | Withdrawal
    channel             VARCHAR(30),  -- Mobile App | UPI | Net Banking | ATM | POS | Branch | Auto Debit
    merchant_category   VARCHAR(50),
    amount              DECIMAL(15,2),
    fee_amount          DECIMAL(15,2),
    tax_amount          DECIMAL(15,2),
    currency            VARCHAR(5),
    transaction_status  VARCHAR(10),  -- Success | Failed | Pending
    is_fraud            VARCHAR(5),   -- Yes | No
    risk_score          INT,          -- 1 to 100
    reference_no        VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ================================================================
-- DATA QUALITY NOTE
-- The raw CSV has dirty channel values (e.g. 'M@bile App', extra
-- spaces in '   Net Banking'). The queries below use TRIM() and
-- REPLACE() to handle this. If you want to fix it permanently run:
-- ================================================================
-- UPDATE transactions
-- SET channel = TRIM(REPLACE(REPLACE(channel, 'M@bile App', 'Mobile App'), '  ', ' '));


-- ================================================================
-- SECTION 1 : MAIN KPIs   (matches Power BI KPI cards)
-- ================================================================

-- 1a. Total Transaction Amount
SELECT
    ROUND(SUM(amount), 2)  AS total_amount
FROM transactions
WHERE transaction_status = 'Success';      -- Change to remove WHERE for ALL statuses

-- 1b. Total Number of Transactions
SELECT
    COUNT(*)  AS total_transactions
FROM transactions;

-- 1c. Average Transaction Value
SELECT
    ROUND(AVG(amount), 2)  AS avg_transaction_value
FROM transactions;

-- 1d. Total Fees Collected
SELECT
    ROUND(SUM(fee_amount), 2)  AS total_fees
FROM transactions;

-- 1e. Total Tax Generated
SELECT
    ROUND(SUM(tax_amount), 2)  AS total_tax
FROM transactions;

-- 1f. ALL 5 KPIs in one single query (run this one for quick check)
SELECT
    COUNT(*)                       AS total_transactions,
    ROUND(SUM(amount),     2)      AS total_amount,
    ROUND(AVG(amount),     2)      AS avg_transaction_value,
    ROUND(SUM(fee_amount), 2)      AS total_fees,
    ROUND(SUM(tax_amount), 2)      AS total_tax
FROM transactions;


-- ================================================================
-- SECTION 2 : YEAR-OVER-YEAR (YoY) PERFORMANCE
--             Matches the YoY comparison shown next to each KPI
-- ================================================================

-- 2a. Total Amount per Year
SELECT
    YEAR(transaction_date)    AS txn_year,
    COUNT(*)                  AS total_transactions,
    ROUND(SUM(amount),  2)    AS total_amount,
    ROUND(AVG(amount),  2)    AS avg_amount
FROM transactions
WHERE YEAR(transaction_date) BETWEEN 2023 AND 2025
GROUP BY YEAR(transaction_date)
ORDER BY txn_year;

-- 2b. YoY Growth % — Amount
--     Uses a self-join so you don't need window functions
SELECT
    curr.txn_year,
    curr.total_amount                             AS current_year_amount,
    prev.total_amount                             AS previous_year_amount,
    ROUND(
        (curr.total_amount - prev.total_amount)
        / prev.total_amount * 100
    , 2)                                          AS yoy_growth_pct
FROM
    (SELECT YEAR(transaction_date) AS txn_year, SUM(amount) AS total_amount
     FROM transactions GROUP BY YEAR(transaction_date)) AS curr
LEFT JOIN
    (SELECT YEAR(transaction_date) AS txn_year, SUM(amount) AS total_amount
     FROM transactions GROUP BY YEAR(transaction_date)) AS prev
    ON curr.txn_year = prev.txn_year + 1
WHERE curr.txn_year BETWEEN 2023 AND 2025
ORDER BY curr.txn_year;

-- 2c. YoY Growth % — Total Transactions
SELECT
    curr.txn_year,
    curr.txn_count                                AS current_year_txns,
    prev.txn_count                                AS previous_year_txns,
    ROUND(
        (curr.txn_count - prev.txn_count)
        / prev.txn_count * 100
    , 2)                                          AS yoy_txn_growth_pct
FROM
    (SELECT YEAR(transaction_date) AS txn_year, COUNT(*) AS txn_count
     FROM transactions GROUP BY YEAR(transaction_date)) AS curr
LEFT JOIN
    (SELECT YEAR(transaction_date) AS txn_year, COUNT(*) AS txn_count
     FROM transactions GROUP BY YEAR(transaction_date)) AS prev
    ON curr.txn_year = prev.txn_year + 1
WHERE curr.txn_year BETWEEN 2023 AND 2025
ORDER BY curr.txn_year;


-- ================================================================
-- SECTION 3 : TOTAL AMOUNT BY MONTH  (Line / Area Chart)
--             Chart 1 from the business requirements
-- ================================================================

-- 3a. Monthly trend — all years combined
SELECT
    MONTH(transaction_date)           AS month_num,
    MONTHNAME(transaction_date)       AS month_name,
    ROUND(SUM(amount), 2)             AS total_amount,
    COUNT(*)                          AS total_transactions
FROM transactions
GROUP BY MONTH(transaction_date), MONTHNAME(transaction_date)
ORDER BY month_num;

-- 3b. Monthly trend split by year (good for multi-line chart)
SELECT
    YEAR(transaction_date)            AS txn_year,
    MONTH(transaction_date)           AS month_num,
    MONTHNAME(transaction_date)       AS month_name,
    ROUND(SUM(amount), 2)             AS total_amount,
    COUNT(*)                          AS total_transactions
FROM transactions
WHERE YEAR(transaction_date) BETWEEN 2023 AND 2025
GROUP BY txn_year, month_num, month_name
ORDER BY txn_year, month_num;


-- ================================================================
-- SECTION 4 : TOTAL AMOUNT BY TRANSACTION STATUS  (Donut Chart)
--             Chart 2 — Success / Failed / Pending split
-- ================================================================

SELECT
    transaction_status,
    COUNT(*)                                                AS txn_count,
    ROUND(SUM(amount), 2)                                   AS total_amount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM transactions), 2)
                                                            AS pct_of_txns,
    ROUND(SUM(amount) * 100.0 / (SELECT SUM(amount) FROM transactions), 2)
                                                            AS pct_of_amount
FROM transactions
GROUP BY transaction_status
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 5 : TOTAL AMOUNT BY CUSTOMER SEGMENT  (Horizontal Bar)
--             Chart 3 — Retail / Premium / SME / Corporate / Wealth
-- ================================================================

SELECT
    c.customer_segment,
    COUNT(DISTINCT t.customer_id)    AS customer_count,
    COUNT(t.transaction_id)          AS total_transactions,
    ROUND(SUM(t.amount),     2)      AS total_amount,
    ROUND(AVG(t.amount),     2)      AS avg_amount,
    ROUND(SUM(t.fee_amount), 2)      AS total_fees,
    ROUND(SUM(t.tax_amount), 2)      AS total_tax
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 6 : TOTAL AMOUNT BY STATE  (Horizontal Bar)
--             Chart 4 — State-wise performance
-- ================================================================

SELECT
    c.state,
    COUNT(DISTINCT t.customer_id)    AS customer_count,
    COUNT(t.transaction_id)          AS total_transactions,
    ROUND(SUM(t.amount),  2)         AS total_amount,
    ROUND(AVG(t.amount),  2)         AS avg_amount,
    ROUND(SUM(t.fee_amount), 2)      AS total_fees
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 7 : TRANSACTION TYPE ANALYSIS  (Matrix / Heatmap Table)
--             Chart 5 — Amount, Fees, Tax, Count per type
-- ================================================================

SELECT
    transaction_type,
    COUNT(*)                       AS txn_count,
    ROUND(SUM(amount),     2)      AS total_amount,
    ROUND(SUM(fee_amount), 2)      AS total_fees,
    ROUND(SUM(tax_amount), 2)      AS total_tax,
    ROUND(AVG(amount),     2)      AS avg_amount,
    ROUND(
        SUM(CASE WHEN transaction_status = 'Success' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                              AS success_rate_pct
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 8 : TOTAL AMOUNT BY GENDER  (Donut Chart)
--             Chart 6 — Male / Female contribution
-- ================================================================

SELECT
    c.gender,
    COUNT(DISTINCT t.customer_id)    AS customer_count,
    COUNT(t.transaction_id)          AS total_transactions,
    ROUND(SUM(t.amount), 2)          AS total_amount,
    ROUND(
        SUM(t.amount) * 100.0
        / (SELECT SUM(amount) FROM transactions), 2
    )                                AS amount_share_pct
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.gender
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 9 : OCCUPATION FILTER  (Slicer / Filter Panel)
--             Matches the Occupation slicer on the dashboard
-- ================================================================

SELECT
    c.occupation,
    COUNT(DISTINCT t.customer_id)    AS customer_count,
    COUNT(t.transaction_id)          AS total_transactions,
    ROUND(SUM(t.amount),  2)         AS total_amount,
    ROUND(AVG(t.amount),  2)         AS avg_amount,
    ROUND(SUM(t.fee_amount), 2)      AS total_fees
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.occupation
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 10 : CHANNEL ANALYSIS
--              (TRIM fixes dirty data — extra spaces, typos)
-- ================================================================

SELECT
    TRIM(REPLACE(channel, 'M@bile App', 'Mobile App'))   AS channel_clean,
    COUNT(*)                                             AS total_transactions,
    ROUND(SUM(amount),  2)                               AS total_amount,
    ROUND(AVG(amount),  2)                               AS avg_amount,
    ROUND(
        SUM(CASE WHEN transaction_status = 'Success' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                                                    AS success_rate_pct,
    ROUND(
        SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    )                                                    AS failure_rate_pct
FROM transactions
GROUP BY TRIM(REPLACE(channel, 'M@bile App', 'Mobile App'))
ORDER BY total_amount DESC;


-- ================================================================
-- SECTION 11 : FRAUD & RISK OVERVIEW
-- ================================================================

-- 11a. Fraud summary
SELECT
    is_fraud,
    COUNT(*)                          AS txn_count,
    ROUND(SUM(amount),  2)            AS total_amount,
    ROUND(AVG(risk_score), 1)         AS avg_risk_score
FROM transactions
GROUP BY is_fraud;

-- 11b. High-risk transactions — risk_score > 75
--      ALL 444 rows in the dataset with risk > 75 are fraudulent
SELECT
    t.transaction_id,
    t.transaction_date,
    CONCAT(c.fisrt_name, ' ', c.second_name)  AS customer_name,
    c.state,
    t.transaction_type,
    t.amount,
    t.risk_score,
    t.transaction_status,
    t.is_fraud
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.risk_score > 75
ORDER BY t.risk_score DESC;

-- 11c. Fraud count & amount by transaction type
SELECT
    transaction_type,
    COUNT(*)                    AS fraud_count,
    ROUND(SUM(amount), 2)       AS fraud_amount
FROM transactions
WHERE is_fraud = 'Yes'
GROUP BY transaction_type
ORDER BY fraud_count DESC;


-- ================================================================
-- SECTION 12 : DASHBOARD 2 — DETAILED DRILL-DOWN GRID
--              Underlying records view (Page 2 of the dashboard)
-- ================================================================

SELECT
    t.transaction_id,
    t.transaction_date,
    YEAR(t.transaction_date)                           AS txn_year,
    MONTHNAME(t.transaction_date)                      AS txn_month,
    c.customer_id,
    CONCAT(c.fisrt_name, ' ', c.second_name)           AS customer_name,
    c.gender,
    c.state,
    c.city,
    c.occupation,
    c.customer_segment,
    t.transaction_type,
    TRIM(REPLACE(t.channel, 'M@bile App', 'Mobile App')) AS channel,
    t.merchant_category,
    t.amount,
    t.fee_amount,
    t.tax_amount,
    ROUND(t.amount + t.fee_amount + t.tax_amount, 2)   AS gross_amount,
    t.transaction_status,
    t.is_fraud,
    t.risk_score,
    t.reference_no
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY t.transaction_date DESC;


-- ================================================================
-- SECTION 13 : SINGLE-ROW EXECUTIVE SUMMARY
--              Quick sanity check — paste this into any slide/email
-- ================================================================

SELECT
    COUNT(*)                                                         AS total_transactions,
    ROUND(SUM(amount),     2)                                        AS total_amount_inr,
    ROUND(AVG(amount),     2)                                        AS avg_transaction_value,
    ROUND(SUM(fee_amount), 2)                                        AS total_fees,
    ROUND(SUM(tax_amount), 2)                                        AS total_tax,
    SUM(CASE WHEN transaction_status = 'Success' THEN 1 ELSE 0 END) AS successful,
    SUM(CASE WHEN transaction_status = 'Failed'  THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN transaction_status = 'Pending' THEN 1 ELSE 0 END) AS pending,
    SUM(CASE WHEN is_fraud = 'Yes'               THEN 1 ELSE 0 END) AS fraud_transactions
FROM transactions;


-- ================================================================
-- OPTIONAL : LOAD DATA INFILE  (bulk import — faster than wizard)
-- ================================================================

-- Step 1: Load customers first (no FK dependency)
-- LOAD DATA INFILE 'C:/path/to/customers.csv'
-- INTO TABLE customers
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES  TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (customer_id, fisrt_name, second_name, gender,
--  @dob, city, state, occupation, customer_segment,
--  annual_income, @jd)
-- SET date_of_birth = STR_TO_DATE(@dob, '%d-%m-%Y'),
--     join_date      = STR_TO_DATE(@jd,  '%d-%m-%Y');

-- Step 2: Load transactions
-- LOAD DATA INFILE 'C:/path/to/finance_transactions.csv'
-- INTO TABLE transactions
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES  TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (transaction_id, @td, account_id, customer_id,
--  transaction_type, channel, merchant_category,
--  amount, fee_amount, tax_amount, currency,
--  transaction_status, is_fraud, risk_score, reference_no)
-- SET transaction_date = STR_TO_DATE(@td, '%d-%m-%Y');

-- ================================================================
-- END OF SCRIPT
-- ================================================================
