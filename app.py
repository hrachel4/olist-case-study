import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sqlalchemy import create_engine
import pymysql
from datetime import datetime


# Connecting to MySQL database
engine = create_engine('mysql+pymysql://root:12345678@localhost/olist_intelligence')

#? ------------ Converting dates from 'olist_orders_dataset' table from VARCHAR to DATETIME data types ------------
# 1. Define the list of date columns from the orders table
date_columns = [
    'order_purchase_timestamp', 
    'order_approved_at', 
    'order_delivered_carrier_date', 
    'order_delivered_customer_date', 
    'order_estimated_delivery_date'
]

# 2. Pull the orders table from MySQL into a DataFrame
df_orders = pd.read_sql('SELECT * FROM olist_orders_dataset', con=engine)

# 3. The Date Challenge Loop
for col in date_columns:
    df_orders[col] = pd.to_datetime(df_orders[col], errors='coerce')

# 4. Quick check to verify the data types
print(df_orders.dtypes)


# #? ---------------------------------- Price Validation in 'olist_order_items_dataset ------------------------------------
# Pull the order items table
df_items = pd.read_sql('SELECT * FROM olist_order_items_dataset', con=engine)

# Price validation check
invalid_prices = df_items[df_items['price'] <= 0]

print(f"Total rows with invalid prices: {len(invalid_prices)}")
if len(invalid_prices) > 0:
    print(invalid_prices[['order_id','product_id','price']])
else:
    print("clean Data: All prices are positive.")

# Creating a visual for the findings
plt.figure(figsize=(10, 6))
plt.hist(df_items['price'], bins= 50, color='skyblue', edgecolor='black')
plt.title('Distribution of Product Prices')
plt.xlabel('Price (BRL)')
plt.ylabel('Number of Items')
plt.xlim(0, 1000)
plt.savefig('price_distribution.png')
plt.show()


#? -------------------------- Phase 3: Advanced Data Cleaning & Outlier Detection --------------------------

# 1. Join items with products to handle 'Uncategorized' products in Pandas
query = """
SELECT oi.product_id, oi.price, p.product_category_name 
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p ON oi.product_id = p.product_id
"""
df_clean = pd.read_sql(query, con=engine)

# 2. Apply your 'Uncategorized' logic (equivalent to your SQL CASE statement)
df_clean['product_category_name'] = df_clean['product_category_name'].fillna('Uncategorized').replace('', 'Uncategorized')

# 3. Investigate 'utilidades_domesticas' outliers specifically
utilidades = df_clean[df_clean['product_category_name'] == 'utilidades_domesticas']

# Calculate the IQR (Interquartile Range) to mathematically identify outliers
Q1 = utilidades['price'].quantile(0.25)
Q3 = utilidades['price'].quantile(0.75)
IQR = Q3 - Q1
upper_bound = Q3 + 1.5 * IQR

# Identify records that are statistically extreme
outliers = utilidades[utilidades['price'] > upper_bound]
print(f"Mathematical outliers in utilidades_domesticas: {len(outliers)}")
print(f"Price threshold for outliers: {upper_bound:.2f}")

# 4. Final step: Create a clean CSV for Power BI
# This version has categorical gaps filled and is ready for visualization
df_clean.to_csv('olist_final_cleaned_data.csv', index=False)
print("Phase 3 complete: Final dataset exported for Power BI.")

#? ----------------- Scatter Plot for Individual Price Points -----------------
plt.figure(figsize=(10, 5))
plt.scatter(range(len(utilidades)), utilidades['price'].values, alpha=0.5, color='teal', s=10)
# Add a horizontal line at the $5,000 threshold to highlight the extreme values
plt.axhline(y=5000, color='red', linestyle='--', label='High-Value Threshold')

plt.title('Individual Price Points: utilidades_domesticas')
plt.ylabel('Price (BRL)')
plt.xlabel('Record Index')
plt.legend()
plt.savefig('outlier_analysis.png')
plt.show()