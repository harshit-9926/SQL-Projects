🛒 Retail Analytics SQL Project
📌 Project Overview

This project focuses on Retail Data Analysis using SQL, where raw transactional, product, and customer data is cleaned,
transformed, and analyzed to generate meaningful business insights.

-~ Links:- Dataset = -<a href="https://github.com/harshit-9926/SQL-Projects/blob/main/customer_profiles.csv"> Customer Profile Retail </a>,
Dataset = -<a href="https://github.com/harshit-9926/SQL-Projects/blob/main/product_inventory.csv"> product_inventory Retail </a>,
Dataset = -<a href="https://github.com/harshit-9926/SQL-Projects/blob/main/sales_transaction.csv"> sales_transaction Retail </a>,
Workbook = -<a href="https://github.com/harshit-9926/SQL-Projects/blob/main/Retail%20Analytics.sql"> Retail Workbook </a>,
Query Output = -<a href="https://github.com/harshit-9926/SQL-Projects/blob/main/Screenshot%202026-03-29%20131200.png"> Screenshot </a>

#The goal is to understand:
Product performance
Sales trends
Customer behavior
Revenue growth patterns

🗂️ Dataset Description
The project uses three main tables:

customer_profiles
Customer demographics (Age, Gender, Location, Join Date)
product_inventory
Product details (Product ID, Name, Category, Price, Stock Level)
sales_transaction
Transaction-level data (Customer ID, Product ID, Quantity, Price, Date)

🧹 Data Cleaning Steps
Performed extensive data preprocessing to ensure data quality:

Renamed inconsistent column names
Fixed date formats using STR_TO_DATE
Removed duplicate records
Handled missing/null values
Replaced incorrect or inconsistent values
Removed invalid data (e.g., negative price, unrealistic age)
Standardized price discrepancies between tables

📊 Key Analysis & Insights
🔹 1. Product Performance Analysis
Identified top-selling products
Detected low-performing products
Evaluated category-wise performance
Compared stock vs sales trends

🔹 2. Sales Trend Analysis
Daily sales and transaction trends
Month-on-Month (MoM) growth analysis using window functions
Revenue and quantity-based performance tracking

🔹 3. Customer Segmentation
Customers were segmented based on purchase behavior:
No Orders
Low Orders (1–10)
Medium Orders (11–30)
High Orders (30+)

🔹 4. Customer Behavior Analysis
Purchase frequency per customer
High-value vs occasional customers
Repeat purchase patterns
Customer loyalty tracking using transaction duration

🔹 5. Advanced SQL Techniques Used
Common Table Expressions (CTEs)
Window Functions (LAG, ROW_NUMBER, PERCENTILE_CONT)
Aggregations (SUM, COUNT, AVG)
Joins for relational insights
Case statements for segmentation

🛠️ Tools & Technologies
SQL (MySQL Workbench)
Data Cleaning & Transformation
Data Analysis & Aggregation
Window Functions for advanced analytics

📈 Key Business Insights
Identified products contributing maximum revenue
Detected underperforming inventory
Found high-value and loyal customers
Analyzed customer churn behavior
Discovered monthly sales growth trends

🚀 How to Use This Project
Import dataset into MySQL
Run the SQL script step-by-step:
Data Cleaning
Data Transformation
Analysis Queries
Modify queries for further insights

📌 Future Improvements
Build dashboards using Power BI / Tableau
Add predictive analysis (sales forecasting)
Integrate Python for advanced analytics
Automate reporting pipeline

👤 Author
Harshit Jain
Data Analyst
