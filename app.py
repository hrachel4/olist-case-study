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


#? ---------------------------------- Price Validation in 'olist_order_items_dataset ------------------------------------
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
plt.show()

# Cross checking 
