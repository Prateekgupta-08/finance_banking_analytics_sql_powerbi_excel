# 💰 Finance & Banking Transaction Analytics | SQL + Power BI + Excel

**Turning 50,000+ raw bank transaction records into a decision-ready analytics layer for finance and operations leadership.**

---

## 📌 Business Problem

Financial organizations sit on huge volumes of transaction data (payments, transfers, EMIs, deposits) but that data is usually locked in raw operational tables — nobody outside IT/data engineering can answer basic business questions without writing SQL themselves:

- Is transaction volume growing or shrinking?
- How much revenue is at risk from failed transactions?
- Which customer segments and states actually drive the business?
- Are fees and tax collections keeping pace with volume?
- Where is fraud risk concentrated?

**Without a reporting layer, these questions get answered late (or not at all), and decisions get made on gut feel instead of data.**

I built a MySQL → Power BI pipeline to close that gap: raw transaction and customer tables in, an interactive executive dashboard out.

---

## 🎯 What I Did

1. **Modeled the data** in MySQL — a `customers` table (demographics, segment, income) joined to a `finance_transactions` table (50,069 transactions, 15 fields including amount, fees, tax, status, fraud flag, risk score).
2. **Wrote 20 analytical SQL queries** covering totals, trends, segment/state rankings, transaction-type profitability, fraud incidence, and YoY growth (`finance_analytics.sql`).
3. **Built a Power BI dashboard** on top with drill-through to transaction-level detail and dynamic filters (year, occupation, segment).
4. **Delivered a recommendations deck** translating the findings into business actions.

---

## 📊 Impact — The Numbers

*(Pulled directly from the transaction dataset, Jan 2023 – Apr 2026)*

| KPI | Value |
|---|---|
| **Total transaction value processed** | **₹45.6 crore (₹456.1M)** |
| **Total transactions analyzed** | **50,069** |
| **Average transaction value** | ₹9,110 |
| **Total fees collected** | ₹7.27 lakh |
| **Total tax collected** | ₹1.31 lakh |
| **Transaction success rate** | **85.7%** |
| **Failed transaction rate** | 10.2% (**₹4.75 crore in failed-transaction value**) |
| **Pending transaction rate** | 4.1% |
| **Flagged fraud rate** | 1.26% (632 transactions) |

### Where the value concentrates
- **Retail is the volume engine:** 54.4% of all transaction value (₹24.8 crore) and 54% of transaction count comes from the Retail segment — more than the other four segments combined.
- **Top 5 states drive ~57% of value:** Maharashtra (₹6.83 cr), Karnataka (₹5.29 cr), Gujarat (₹5.01 cr), Tamil Nadu (₹4.49 cr), Uttar Pradesh (₹4.36 cr).
- **Loan EMIs and Transfers are the two biggest transaction types by value** — ₹13.1 crore and ₹12.1 crore respectively, together ~55% of total volume.
- **Segment labels don't predict ticket size:** average transaction value is nearly flat across Retail, Premium, SME, Corporate, and Wealth (₹8,980–₹9,155) — the segments differ by *volume*, not deal size. This is a real finding: it tells the business that segment strategy should focus on transaction frequency/retention, not upselling bigger tickets.
- **Data quality finding:** the raw `channel` field had inconsistent labels (e.g. stray whitespace, "M@bile App" vs "Mobile App") that would silently fragment a "channel performance" view if not cleaned — flagged and standardized during modeling.

---

## 🧭 How This Drives Business Decisions

| Business Question | Dashboard Answer | Decision It Enables |
|---|---|---|
| Are we losing revenue to failed transactions? | 10.2% of transactions fail, representing ₹4.75 cr in value | Prioritize root-cause analysis on failure reasons/channels before scaling volume further |
| Which segment should Sales/Marketing focus retention budget on? | Retail = 54% of value but flat average ticket size | Focus on transaction *frequency* and engagement, not just deal size, for Retail |
| Where should regional teams concentrate effort? | Top 5 states = 57% of value | Concentrate account management and support resources in those states first |
| Which transaction types matter most to the P&L? | Loan EMI + Transfers = 55% of volume | Prioritize uptime/reliability investment on these transaction rails |
| Is fraud risk material? | 1.26% flagged, concentrated in specific risk-score bands | Set risk-score thresholds for manual review vs. auto-approval |

---

## 🛠 Tools & Technologies
- **MySQL** — data modeling, joins, aggregation, window functions (RANK)
- **Power BI** — data modeling, DAX, drill-through, dynamic KPI cards
- **Power Query** — data cleaning and shaping
- **Excel** — supporting analysis

## 📂 Repository Structure
```
finance_banking_analytics_sql_powerbi_excel/
│
├── README.md
├── finance_analytics.sql                          # 20 analytical queries
├── customers.csv                                  # 5,000 customer records
├── finance_transactions.csv                       # 50,069 transaction records
├── Finance_Analytics.pbix                          # Power BI dashboard
├── Finance_Banking_Analytics.pdf                   # Dashboard export
└── Finance_Analytics_Insights.pptx                 # Recommendations deck
```

## 📈 Skills Demonstrated
SQL (joins, aggregation, window functions) · Data Modeling · DAX · Power Query · KPI Development · Financial Analytics · Data Quality/Cleaning · Business Storytelling

---
## Dashboard Screenshots

### Executive Summary Dashboard
<img width="1658" height="932" alt="Screenshot 2026-06-07 033617" src="https://github.com/user-attachments/assets/7ab10553-d161-4e1b-b6cb-335deddb6de1" />

### Transaction Detail Dashboard
<img width="1654" height="918" alt="Screenshot 2026-06-07 033656" src="https://github.com/user-attachments/assets/36eed0bf-f7f8-43a0-a440-13310b2d36ca" />

### 👨‍💻 About Me
**Prateek Gupta** — Data Analyst | SQL · Python · Excel · Power BI · Financial & Healthcare Analytics
- 📧 prateekgupta545@gmail.com 
- 💼 [LinkedIn](https://linkedin.com/in/prateek-k-gupta)
- 🐙 [GitHub](https://github.com/Prateekgupta-08)

⭐ If this project is useful to you, consider starring the repo!

