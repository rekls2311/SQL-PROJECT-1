/* 1) Check the data_type for that column in table, and in database*/
use project1;
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'project1'
  AND TABLE_NAME = 'sales_dataset_rfm_prj'
  AND COLUMN_NAME = 'orderdate';
  
/* 2) Select all the data to check the column and row*/
SELECT *
FROM sales_dataset_rfm_prj;

/* 3) Now as all the table data_type is VARCHAR we need to ALTER the data_type to match with all the column*/
/*a)Ordernumber column*/
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN ordernumber numeric; 

/*b)quantityordered column*/
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN quantityordered numeric; 

/*c)priceeach column*/
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN priceeach numeric;

/*d)orderlinenumber column*/
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN orderlinenumber numeric;

/*e)sales column*/
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN sales decimal;

/*f)orderdate column*/
SET SQL_SAFE_UPDATES = 0;
UPDATE sales_dataset_rfm_prj
SET orderdate = STR_TO_DATE(orderdate, '%m/%d/%Y %H:%i')
WHERE orderdate LIKE '%/%/% %:%';
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN orderdate datetime;

/*g)msrp column*/
ALTER TABLE sales_dataset_rfm_prj
MODIFY COLUMN msrp numeric;

/*4) Check Null/Blank in every column*/
SELECT COUNT(*)
FROM sales_dataset_rfm_prj
WHERE orderlinenumber IS NULL OR orderlinenumber = '';

/* Add in column CONTACTLASTNAME, CONTACTFIRSTNAME and Capitalize the first letter*/
/*a) add contactlastname column*/
ALTER TABLE sales_dataset_rfm_prj
ADD column contactlastname varchar(100);
/*b) add contactfirstname column*/
ALTER TABLE sales_dataset_rfm_prj
ADD column contactfirstname varchar(100);

/*c) update contactlastname column*/
UPDATE sales_dataset_rfm_prj
SET contactfirstname = SUBSTRING_INDEX(contactfullname, '-', 1);

/*d) update contactfirstname column*/
UPDATE sales_dataset_rfm_prj
SET contactlastname = SUBSTRING_INDEX(contactfullname, '-', -1);
/*d) Capitalize the first letter and lower all letter inside column*/
SET SQL_SAFE_UPDATES = 0;
UPDATE sales_dataset_rfm_prj
SET 
    contactfirstname = CONCAT(
        UPPER(SUBSTRING(contactfirstname, 1, 1)),
        LOWER(SUBSTRING(contactfirstname, 2))
    ),
    contactlastname = CONCAT(
        UPPER(SUBSTRING(contactlastname, 1, 1)),
        LOWER(SUBSTRING(contactlastname, 2))
    )
WHERE 
    contactfirstname IS NOT NULL AND contactfirstname != ''
    AND contactlastname IS NOT NULL AND contactlastname != '';

SET SQL_SAFE_UPDATES = 1;

/*5) Finding outlier for column Quantity Ordered*/
/*Using IQR/BOX Plot data to find out outliers*/
SET SQL_SAFE_UPDATES = 0;
SET @avg_quantity = (SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj);
WITH IQR_Min_Max AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN value END) AS Q1,
        MAX(CASE WHEN quartile = 3 THEN value END) AS Q3,
        (MAX(CASE WHEN quartile = 3 THEN value END) - MAX(CASE WHEN quartile = 1 THEN value END)) AS IQR,
        MAX(CASE WHEN quartile = 1 THEN value END) - (1.5 * (MAX(CASE WHEN quartile = 3 THEN value END) - MAX(CASE WHEN quartile = 1 THEN value END))) AS Min_value,
        MAX(CASE WHEN quartile = 3 THEN value END) + (1.5 * (MAX(CASE WHEN quartile = 3 THEN value END) - MAX(CASE WHEN quartile = 1 THEN value END))) AS Max_value
    FROM (
        SELECT
            quantityordered AS value,
            NTILE(4) OVER (ORDER BY quantityordered) AS quartile
        FROM
            sales_dataset_rfm_prj
    ) AS quartile_data
)
UPDATE sales_dataset_rfm_prj
SET quantityordered = @avg_quantity
WHERE quantityordered < (SELECT Min_value FROM IQR_Min_Max)
   OR quantityordered > (SELECT Max_value FROM IQR_Min_Max);

SET SQL_SAFE_UPDATES = 1;
/*6) After the data clean then save it into new table named SALES_DATASET_RFM_PRJ_CLEAN */
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM SALES_DATASET_RFM_PRJ;

/*7) Check to see if all the outliers has been deleted*/
SELECT *
FROM SALES_DATASET_RFM_PRJ_CLEAN
Where quantityordered < 67;
