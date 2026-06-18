-- finance_analytics.sql
USE finance_analysis_db;

-- 1. Total Transaction Amount
SELECT SUM(amount) AS total_amount FROM finance_transactions;

-- 2. Total Transactions
SELECT COUNT(*) AS total_transactions FROM finance_transactions;

-- 3. Average Transaction Value
SELECT AVG(amount) AS avg_transaction_value FROM finance_transactions;

-- 4. Total Fees
SELECT SUM(fee_amount) AS total_fees FROM finance_transactions;

-- 5. Total Tax
SELECT SUM(tax_amount) AS total_tax FROM finance_transactions;

-- 6. Amount by Month
SELECT YEAR(transaction_date), MONTH(transaction_date), SUM(amount)
FROM finance_transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date);

-- 7. Amount by Status
SELECT transaction_status, SUM(amount)
FROM finance_transactions
GROUP BY transaction_status;

-- 8. Amount by Customer Segment
SELECT c.customer_segment, SUM(t.amount)
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_segment;

-- 9. Amount by State
SELECT c.state, SUM(t.amount)
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.state;

-- 10. Transaction Type Analysis
SELECT transaction_type, SUM(amount), SUM(fee_amount),
       SUM(tax_amount), COUNT(*)
FROM finance_transactions
GROUP BY transaction_type;

-- 11. Amount by Gender
SELECT c.gender, SUM(t.amount)
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.gender;

-- 12. Top 5 States by Amount
SELECT c.state, SUM(t.amount) total_amount
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.state
ORDER BY total_amount DESC
LIMIT 5;

-- 13. Top 5 Customers
SELECT customer_id, SUM(amount) total_amount
FROM finance_transactions
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 5;

-- 14. Success vs Failed Transactions
SELECT transaction_status, COUNT(*)
FROM finance_transactions
GROUP BY transaction_status;

-- 15. Fraud Transactions
SELECT is_fraud, COUNT(*)
FROM finance_transactions
GROUP BY is_fraud;

-- 16. Channel-wise Amount
SELECT channel, SUM(amount)
FROM finance_transactions
GROUP BY channel;

-- 17. Merchant Category Analysis
SELECT merchant_category, SUM(amount)
FROM finance_transactions
GROUP BY merchant_category;

-- 18. Gender-wise Average Transaction
SELECT c.gender, AVG(t.amount)
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.gender;

-- 19. Occupation-wise Amount
SELECT c.occupation, SUM(t.amount)
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.occupation;

-- 20. Customer Segment Ranking
SELECT c.customer_segment,
       SUM(t.amount) total_amount,
       RANK() OVER (ORDER BY SUM(t.amount) DESC) rnk
FROM finance_transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_segment;
