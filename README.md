# Sales Data Analysis & Outlier Handling

## 📌 Project Overview
This SQL project is designed to analyze a sales dataset and apply a common data cleaning technique to handle outliers.  
The script specifically identifies and updates outliers in the `quantityordered` column using the **Interquartile Range (IQR) method**.  

The code is written to be clear and easy to follow, demonstrating a practical approach to **data quality management** in a SQL database.  

👉 **Note:** This project is part of the preparation for **Project 3 (SQL)**, an upcoming continuation project.  

---

## ⚙️ Prerequisites
- **Database**: MySQL  
- **Client Tool**: SQL Workbench (or any MySQL client)  
- **Server**: Localhost  

---

## 🔧 Data Preparation
Before performing outlier detection, the dataset required several preprocessing steps:  

1. **Data Type Conversion**  
   - Original table columns were all created as `VARCHAR`.  
   - Used **ALTER / UPDATE DDL statements** to convert columns into the correct data type formats, such as:  
     - `VARCHAR → DATETIME`  
     - `VARCHAR → DECIMAL`  

2. **Data Quality Checks**  
   - Verified if columns contained `NULL` or blank values.  
   - Applied handling strategies to clean incomplete or invalid data.  

3. **Splitting Full Name Column**  
   - Extracted `firstname` and `lastname` columns from the original `fullname` column for better data normalization.  

4. **Date Feature Engineering**  
   - Extracted **Month**, **Quarter**, and **Year** from the `orderdate` column (`DATETIME` type).  
   - Created 3 new columns:  
     - `order_month`  
     - `order_quarter`  
     - `order_year`  
---

## ✨ Key Features
- **Outlier Detection**: Uses the `NTILE` window function to calculate quartiles (Q1 and Q3) and the Interquartile Range (IQR).  
- **Dynamic Thresholds**: Calculates lower & upper bounds for outliers using the standard: Q1 − (1.5 × IQR), Q3 + (1.5 × IQR)

- **Data Cleaning**: Updates outlier values in `quantityordered` to the **average value** of the dataset (a common imputation method).  

---

## 🛠️ How the SQL Logic Works
The script is divided into **two main parts**, executed sequentially:

### 1. Identifying Outliers
- **Step 1**: `IQR_Min_Max` CTE calculates Q1, Q3, IQR, Min_value, and Max_value.  
- **Step 2**: `Outlier_Value` CTE selects all `ordernumber` and `quantityordered` values outside the min/max thresholds.

### 2. Updating the Data
- **UPDATE Statement** modifies `quantityordered` in `sales_dataset_rfm_prj`.  
- **WHERE Clause** checks if the order exists in the identified outlier list.  
- **SET Clause** replaces outlier values with the **average `quantityordered`** across the dataset.  

This ensures that:  
1. Outlier detection is isolated.  
2. Data modification is done logically and cleanly.  

---

## 📂 File Structure
- `project1.sql` → Main SQL script  

---

## ✅ Summary
This project demonstrates:
- A practical example of **data preparation and cleaning** in SQL.  
- **Data type conversion** from raw `VARCHAR` fields to meaningful types (`DATETIME`, `DECIMAL`).  
- **Null/blank data validation** and correction.  
- **Full name normalization** into `firstname` and `lastname`.  
- **Date feature extraction**: added `order_month`, `order_quarter`, and `order_year` from `orderdate`.  
- A practical example of **outlier detection** using the IQR method.  
- A common **data cleaning technique** (replacing with dataset mean).  
- Clear step-by-step logic for **data quality improvement**.  
- Serves as **preparation for Project 3 (SQL)**.  
