/*
 * Script 	:	POC for warehouses on snowflake
 * Author	:	Kannan Kandasamy
 */

USE DATABASE TEST;
USE WAREHOUSE compute_wh;

CREATE WAREHOUSE PROCESS_WH 
WITH WAREHOUSE_SIZE = 'MEDIUM' WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 600 AUTO_RESUME = TRUE MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 6 SCALING_POLICY = 'STANDARD';

USE WAREHOUSE PROCESS_WH;

SHOW WAREHOUSES;

SELECT current_warehouse();

SELECT count(*) FROM testtable; --show the history

SELECT * FROM testtable;--show the history
--In second query see the warehouses - question

--In history show all system queries warehouses


