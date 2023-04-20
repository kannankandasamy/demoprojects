/*
 * Script 	:	POC for Query History on snowflake
 * Author	:	Kannan Kandasamy
 */

USE DATABASE TEST;
--USE WAREHOUSE compute_wh;
USE SCHEMA SAMPLES;
--USE WAREHOUSE PROCESS_WH;

ALTER WAREHOUSE RUN_WH SUSPEND;

SELECT count(*) FROM TEST.SAMPLES.ORDERS;
--check warehouses tab

SELECT top 10 * FROM TEST.SAMPLES.ORDERS;
--check warehouses tab

SELECT top 10 * FROM TEST.SAMPLES.ORDERS;
--check execution plan for last 2 queries

SELECT * FROM TEST.SAMPLES.ORDERS WHERE O_ORDERKEY <= 100;
--show history tab

--query history by warehouse
USE WAREHOUSE RUN_WH;

SELECT *
FROM TABLE( information_schema.query_history_by_warehouse())
ORDER BY start_time DESC;

--change warehouse to compute_wh
USE WAREHOUSE COMPUTE_WH;

SELECT *
FROM TABLE( information_schema.query_history_by_warehouse())
ORDER BY start_time DESC;



--last 100 queries by session
SELECT *
FROM TABLE( information_schema.query_history_by_session())
ORDER BY start_time;

--Queries run LAST 1 DAY
--SELECT dateadd('DAY',-1,current_timestamp());

SELECT *
FROM TABLE( information_schema.query_history( dateadd( 'DAY',- 1, CURRENT_TIMESTAMP()), CURRENT_TIMESTAMP()))
ORDER BY start_time DESC;
