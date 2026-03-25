# Case Study: Olist Brazilian E-Commerce 🇧🇷

## Project Overview
This project involves a comprehensive analysis of the Olist e-commerce dataset, focusing on delivery performance and price validation. I am currently building a robust ETL pipeline and performing deep-dive data audits to ensure integrity before visualization.

## Current Progress: Phase 2 (Price Validation)
I am currently investigating data anomalies and validating pricing models across **100,000+ transaction records**.

### 🚀 Key Technical Achievements:
* **Relational Modeling:** Engineered a primary/foreign key schema to link orders, products, and sellers.
![EER Diagram](EED_Olist.png)
* **Large-Scale Data Audit:** Managed and audited a high-volume ecosystem (100k+ rows), ensuring sub-second query performance through strategic indexing.
* **Data Integrity:** Identified 1,603 uncategorized sales originating from 610 unique 'orphan' Product IDs.
* **Outlier Detection:** Flagged extreme price variances in categories like *utilidades_domesticas* (Gap: 6,644) for cleaning.

## 📂 Repository Structure
* `/sql_scripts`: Contains `01_schema_setup.sql` (architecture) and `02_audit_queries.sql` (analysis).
* `data_links.txt`: Documentation for sourcing the raw Olist datasets.
* `app.py`: Initial Python framework for data processing.

## 🛠️ Tech Stack
* **Database:** MySQL
* **Languages:** SQL, Python (Pandas)
* **Tools:** VS Code, MySQL Workbench
