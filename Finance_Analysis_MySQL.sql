CREATE DATABASE IF NOT EXISTS finance_analysis_db;
USE finance_analysis_db;

CREATE TABLE customers(
customer_id VARCHAR(20) PRIMARY KEY,
fisrt_name VARCHAR(50),
second_name VARCHAR(50),
gender VARCHAR(20),
date_of_birth DATE,
city VARCHAR(100),
state VARCHAR(100),
occupation VARCHAR(100),
customer_segment VARCHAR(50),
annual_income DECIMAL(15,2),
join_date DATE
);

CREATE TABLE finance_transactions(
transaction_id VARCHAR(20) PRIMARY KEY,
transaction_date DATE,
account_id VARCHAR(20),
customer_id VARCHAR(20),
transaction_type VARCHAR(50),
channel VARCHAR(50),
merchant_category VARCHAR(100),
amount DECIMAL(15,2),
fee_amount DECIMAL(15,2),
tax_amount DECIMAL(15,2),
currency VARCHAR(10),
transaction_status VARCHAR(20),
is_fraud VARCHAR(10),
risk_score INT,
reference_no VARCHAR(50)
);

-- Import customers.csv and finance_transactions.csv using MySQL Workbench Import Wizard

SELECT SUM(amount) AS total_amount FROM finance_transactions;
SELECT COUNT(*) AS total_transactions FROM finance_transactions;
SELECT AVG(amount) AS avg_transaction_value FROM finance_transactions;
SELECT transaction_status, SUM(amount) FROM finance_transactions GROUP BY transaction_status;
SELECT transaction_type, SUM(amount), COUNT(*) FROM finance_transactions GROUP BY transaction_type;
