/*
 * Script 	:	POC for General topics on snowflake
 * Author	:	Kannan Kandasamy
 */

USE DATABASE TEST;
--USE WAREHOUSE compute_wh;
USE SCHEMA SAMPLES;
USE ROLE AccountAdmin; -- or security admin

SELECT top 10 * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

CREATE  SCHEMA SAMPLES;

USE SCHEMA samples;

SELECT count(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.CUSTOMER;

SELECT  current_schema();

--CREATE TABLE CUSTOMER AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

TRUNCATE TABLE customer;

INSERT INTO customer SELECT * FROM  SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

CREATE TABLE CUSTOMER_BKP CLONE customer;

SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS;

SELECT top 10 * FROM orders;

CREATE TABLE orders AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

TRUNCATE TABLE orders;

INSERT INTO orders SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

SELECT SYSTEM$CLUSTERING_INFORMATION('ORDERS', '(O_ORDERKEY, O_CUSTKEY)');

SELECT SYSTEM$CLUSTERING_DEPTH('ORDERS','(O_CUSTKEY)');


CREATE TABLE NATION AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;

CREATE TRANSIENT TABLE SUPPLIER AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER;

SELECT top 10 * FROM orders;

INSERT INTO test.samples.LINEITEM  SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

TRUNCATE TABLE test.samples.LINEITEM;

SELECT count(*) FROM orders WHERE o_custkey IN (SELECT c_custkey FROM customer WHERE c_nationkey >= 10);

ALTER SESSION SET USE_CACHED_RESULT = TRUE;


CREATE OR REPLACE SCHEMA EXAMPLES;

USE SCHEMA samples;


use sales_dwh;
use schema SALES_SCHEMA;

show schemas;

show tables;

select * from sales_data;

create or replace table sales_fact 
(
    sale_id int, 
    sale_date date, 
    product_id int, 
    quantity int, 
    unit_price float, 
    total_amount float
);

INSERT INTO sales_fact (sale_id, sale_date, product_id, quantity, unit_price, total_amount)
VALUES
    (1, '2023-01-05', 101, 5, 10.00, 50.00),
    (2, '2023-01-10', 102, 3, 15.00, 45.00),
    (3, '2023-01-15', 101, 2, 10.00, 20.00),
    (4, '2023-02-08', 103, 7, 8.00, 56.00),
    (5, '2023-02-15', 102, 4, 15.00, 60.00),
    (6, '2023-03-02', 101, 6, 10.00, 60.00),
    (7, '2023-03-12', 103, 2, 8.00, 16.00);


-- Inserting sample sales data
INSERT INTO sales_fact (sale_id, sale_date, product_id, quantity, unit_price, total_amount)
VALUES
    -- Additional 100 rows of data
    (8, '2023-04-01', 104, 3, 12.00, 36.00),
    (9, '2023-04-10', 101, 5, 10.00, 50.00),
    (10, '2023-04-15', 103, 2, 8.00, 16.00),
    -- ... (continue with more rows)

    (108, '2023-12-20', 102, 6, 15.00, 90.00),
    (109, '2023-12-25', 101, 4, 10.00, 40.00),
    (110, '2023-12-31', 103, 3, 8.00, 24.00);


INSERT INTO sales_fact (sale_id, sale_date, product_id, quantity, unit_price, total_amount)
VALUES
    (111, '2024-01-05', 101, 3, 10.00, 30.00),
    (112, '2024-01-10', 102, 4, 15.00, 60.00),
    (113, '2024-01-15', 103, 2, 8.00, 16.00),
    (114, '2024-02-08', 101, 6, 10.00, 60.00),
    (115, '2024-02-15', 102, 5, 15.00, 75.00),
    (116, '2024-03-02', 104, 3, 12.00, 36.00),
    (117, '2024-03-12', 101, 2, 10.00, 20.00),
    (118, '2024-04-01', 103, 7, 8.00, 56.00),
    (119, '2024-04-10', 102, 4, 15.00, 60.00),
    (120, '2024-04-15', 101, 6, 10.00, 60.00);

-- Inserting additional 20 rows of sample sales data
INSERT INTO sales_fact (sale_id, sale_date, product_id, quantity, unit_price, total_amount)
VALUES
    (121, '2024-05-05', 101, 3, 10.00, 30.00),
    (122, '2024-05-10', 102, 4, 15.00, 60.00),
    (123, '2024-05-15', 103, 2, 8.00, 16.00),
    (124, '2024-06-08', 101, 6, 10.00, 60.00),
    (125, '2024-06-15', 102, 5, 15.00, 75.00),
    (126, '2024-07-02', 104, 3, 12.00, 36.00),
    (127, '2024-07-12', 101, 2, 10.00, 20.00),
    (128, '2024-08-01', 103, 7, 8.00, 56.00),
    (129, '2024-08-10', 102, 4, 15.00, 60.00),
    (130, '2024-08-15', 101, 6, 10.00, 60.00),
    (131, '2024-09-05', 101, 3, 10.00, 30.00),
    (132, '2024-09-10', 102, 4, 15.00, 60.00),
    (133, '2024-09-15', 103, 2, 8.00, 16.00),
    (134, '2024-10-08', 101, 6, 10.00, 60.00),
    (135, '2024-10-15', 102, 5, 15.00, 75.00),
    (136, '2024-11-02', 104, 3, 12.00, 36.00),
    (137, '2024-11-12', 101, 2, 10.00, 20.00),
    (138, '2024-12-01', 103, 7, 8.00, 56.00),
    (139, '2024-12-10', 102, 4, 15.00, 60.00),
    (140, '2024-12-15', 101, 6, 10.00, 60.00);


-- Inserting additional 20 rows of sample sales data
INSERT INTO sales_fact (sale_id, sale_date, product_id, quantity, unit_price, total_amount)
VALUES
    (141, '2025-01-05', 101, 3, 10.00, 30.00),
    (142, '2025-01-10', 102, 4, 15.00, 60.00),
    (143, '2025-01-15', 103, 2, 8.00, 16.00),
    (144, '2025-02-08', 101, 6, 10.00, 60.00),
    (145, '2025-02-15', 102, 5, 15.00, 75.00),
    (146, '2025-03-02', 104, 3, 12.00, 36.00),
    (147, '2025-03-12', 101, 2, 10.00, 20.00),
    (148, '2025-04-01', 103, 7, 8.00, 56.00),
    (149, '2025-04-10', 102, 4, 15.00, 60.00),
    (150, '2025-04-15', 101, 6, 10.00, 60.00),
    (151, '2025-05-05', 101, 3, 10.00, 30.00),
    (152, '2025-05-10', 102, 4, 15.00, 60.00),
    (153, '2025-05-15', 103, 2, 8.00, 16.00),
    (154, '2025-06-08', 101, 6, 10.00, 60.00),
    (155, '2025-06-15', 102, 5, 15.00, 75.00),
    (156, '2025-07-02', 104, 3, 12.00, 36.00),
    (157, '2025-07-12', 101, 2, 10.00, 20.00),
    (158, '2025-08-01', 103, 7, 8.00, 56.00),
    (159, '2025-08-10', 102, 4, 15.00, 60.00),
    (160, '2025-08-15', 101, 6, 10.00, 60.00);


select product_id, count(*) from sales_fact
group by product_id;    
