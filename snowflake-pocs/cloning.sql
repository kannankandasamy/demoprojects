/*
 * Script 	:	POC for Zero copy cloning on snowflake
 * Author	:	Kannan Kandasamy
 */

USE DATABASE SALES_DWH;

show warehouses;

USE WAREHOUSE ESMALL_WH;

show roles;

use role DEV_ROLE;
USE SCHEMA sales_schema;

/*
 * cloned table will not affect original table
 * 
 * swap with other tables
 * 
 */

CREATE OR REPLACE TABLE CUSTOMER_DEMO2 (
	CUST_ID 		INT,
	CUST_NAME		VARCHAR(100),
	ENROLL_DATE		DATE,
	CUST_ADDRESS	VARCHAR(500)
);

use warehouse SMALL_ELT_WH;

INSERT INTO CUSTOMER_DEMO2
SELECT 1, 'Kohli', '2000-03-05','Chennai' UNION ALL
SELECT 2, 'Sachin', '2000-03-05','Mumbai' UNION ALL
SELECT 3, 'Rahul', '2000-02-05','Hydrabad'  
;

CREATE TABLE CUSTOMER_CLONE CLONE CUSTOMER_DEMO2;

SHOW TABLES;

CREATE DATABASE PERM_CONE CLONE PERM_DB;

SHOW DATABASES;

USE DATABASE PERM_CONE;

SHOW SCHEMAS;

USE SCHEMA sales_schema;

SHOW TABLES;

SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS;

SELECT * FROM customer_demo2;

--SELECT * FROM customer_tt_demo;

ALTER TABLE customer_demo SWAP WITH customer_tt_demo;
