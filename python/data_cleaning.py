import pandas as pd
import numpy as np

# Load dataset
df = pd.read_csv("data/processed/customer_support_tickets_cleaned.csv")

# Basic inspection
print(df.head())
print(df.info())
print(df.shape)

# Data Quality Checks
print("Data Quality Checks:")

print("\nColumns:")
print(df.columns.tolist())

print("\nData Types:")
print(df.dtypes)

print("\nMissing Values:")
print(df.isnull().sum())

print("\nDuplicate Rows:")
print(df.duplicated().sum())

print("\nSummary Statistics:")
print(df.describe(include="all"))

print(df["Ticket Status"].value_counts())

print(df["Ticket ID"].nunique())

print(df[["Date of Purchase", "First Response Time", "Time to Resolution"]].head(10))

df["Date of Purchase"] = pd.to_datetime(df["Date of Purchase"])

df["First Response Time"] = pd.to_datetime(df["First Response Time"])

df["Time to Resolution"] = pd.to_datetime(df["Time to Resolution"])

print(df.dtypes)

text_columns = df.select_dtypes(include="str").columns
df[text_columns] = df[text_columns].apply(lambda col: col.str.strip())

categorical_columns = [
    "Ticket Status",
    "Ticket Priority",
    "Ticket Channel",
    "Ticket Type",
    "Customer Gender",
    "Product Purchased"
]

for column in categorical_columns:
    print(f"\n{column}")
    print(df[column].value_counts())

df["Purchase Year"] = df["Date of Purchase"].dt.year

df["Purchase Month"] = df["Date of Purchase"].dt.month_name()

df["Is Resolved"] = df["Ticket Status"].eq("Closed")

df["Satisfaction Category"] = np.select(
    [
        df["Customer Satisfaction Rating"] <= 2,
        df["Customer Satisfaction Rating"] == 3,
        df["Customer Satisfaction Rating"] >= 4
    ],
    [
        "Dissatisfied",
        "Neutral",
        "Satisfied"
    ],
    default="Not Rated"
)

df.to_csv(
    "data/Processed/customer_support_tickets_cleaned.csv",
    index=False,
    na_rep="NULL"
)


print(df[[
    "Purchase Year",
    "Purchase Month",
    "Is Resolved",
    "Satisfaction Category"
]].head(10))