Sales Data Analysis & Outlier Handling
Project Overview
This SQL project is designed to analyze a sales dataset and apply a common data cleaning technique to handle outliers. The script specifically identifies and updates outliers in the quantityordered column using the Interquartile Range (IQR) method.

The code is written to be clear and easy to follow, demonstrating a practical approach to data quality management in a SQL database.

Prerequisites
This project uses MySQL as the database language. The script is designed to be executed using a database client like SQL Workbench, connected to a localhost server.

Key Features
Outlier Detection: Uses the NTILE window function to calculate quartiles (Q1 and Q3) and the Interquartile Range (IQR).

Dynamic Thresholds: Calculates the lower and upper bounds for outliers using the standard Q1−(1.5∗IQR) and Q3+(1.5∗IQR) formulas.

Data Cleaning: Updates the quantityordered values of identified outliers to the average quantityordered value of the entire dataset. This is a common method for handling anomalous data points.

How the SQL Logic Works
The script is divided into two main parts, which are executed sequentially.

1. Identifying Outliers
The first part of the script uses two CTEs (IQR_Min_Max and Outlier_Value) to identify the rows that are considered outliers.

The IQR_Min_Max CTE calculates the Q1 and Q3 values using the NTILE(4) window function, and then computes the IQR, Min_value, and Max_value based on these quartiles.

The Outlier_Value CTE then selects all ordernumber and quantityordered values that fall outside the Min_value and Max_value bounds.

2. Updating the Data
The second part of the script performs the actual data update.

An UPDATE statement is used to modify the quantityordered column in the sales_dataset_rfm_prj table.

The WHERE clause uses a subquery to check if the ordernumber exists in the list of outlier values identified in the previous step.

The SET clause updates the quantityordered for these outlier rows to the average of all quantityordered values in the entire table.

This two-step process ensures that the outlier detection and the data modification are handled in a structured and logical way.
