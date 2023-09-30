--Queries copy_history and get rows and and size of copy happened on different dates
SELECT 
  TO_DATE(LAST_LOAD_TIME) as LOAD_DATE
  ,STATUS
  ,TABLE_CATALOG_NAME as DATABASE_NAME
  ,TABLE_SCHEMA_NAME as SCHEMA_NAME
  ,TABLE_NAME
  ,CASE WHEN PIPE_NAME IS NULL THEN 'COPY' ELSE 'SNOWPIPE' END AS INGEST_METHOD
  ,SUM(ROW_COUNT) as ROW_COUNT
  ,SUM(ROW_PARSED) as ROWS_PARSED
  ,AVG(FILE_SIZE) as AVG_FILE_SIZE_BYTES
  ,SUM(FILE_SIZE) as TOTAL_FILE_SIZE_BYTES
  ,SUM(FILE_SIZE)/POWER(1024,1) as TOTAL_FILE_SIZE_KB
  ,SUM(FILE_SIZE)/POWER(1024,2) as TOTAL_FILE_SIZE_MB
  ,SUM(FILE_SIZE)/POWER(1024,3) as TOTAL_FILE_SIZE_GB
  ,SUM(FILE_SIZE)/POWER(1024,4) as TOTAL_FILE_SIZE_TB
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."COPY_HISTORY"
GROUP BY 1,2,3,4,5,6
ORDER BY 3,4,5,1,2
;


--scale up vs scale out
--queries warehouse_load_history and reports if avg_queued_load is more
--in multi cluster warehouse
SELECT TO_DATE(START_TIME) as DATE
,WAREHOUSE_NAME
,SUM(AVG_RUNNING) AS SUM_RUNNING
,SUM(AVG_QUEUED_LOAD) AS SUM_QUEUED
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_LOAD_HISTORY"
WHERE TO_DATE(START_TIME) >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
HAVING SUM(AVG_QUEUED_LOAD) > 0
;

--queries query_history
--query results bytes_spilled_to_remote_storage which means a larger warehouse could have helped in these scenarios
SELECT QUERY_ID
,USER_NAME
,WAREHOUSE_NAME
,WAREHOUSE_SIZE
,BYTES_SCANNED
,BYTES_SPILLED_TO_REMOTE_STORAGE
,BYTES_SPILLED_TO_REMOTE_STORAGE / BYTES_SCANNED AS SPILLING_READ_RATIO
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE BYTES_SPILLED_TO_REMOTE_STORAGE > BYTES_SCANNED * 5  -- Each byte read was spilled 5x on average
ORDER BY SPILLING_READ_RATIO DESC
;

--top 50 bytes spilled to remote storage
SELECT TOP 50 query_id, substr(query_text, 1, 50) partial_query_text, user_name, warehouse_name, warehouse_size, 
       BYTES_SPILLED_TO_REMOTE_STORAGE, start_time, end_time, total_elapsed_time/1000 total_elapsed_time
FROM   SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE  BYTES_SPILLED_TO_REMOTE_STORAGE > 0
AND start_time::date > dateadd('days', -45, current_date)
ORDER  BY BYTES_SPILLED_TO_REMOTE_STORAGE DESC
;

--queries query_history
--reports warehouse cache usage
SELECT WAREHOUSE_NAME
,COUNT(*) AS QUERY_COUNT
,SUM(BYTES_SCANNED) AS BYTES_SCANNED
,SUM(BYTES_SCANNED*PERCENTAGE_SCANNED_FROM_CACHE) AS BYTES_SCANNED_FROM_CACHE
,SUM(BYTES_SCANNED*PERCENTAGE_SCANNED_FROM_CACHE) / SUM(BYTES_SCANNED) AS PERCENT_SCANNED_FROM_CACHE
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE START_TIME >= dateadd(month,-1,current_timestamp())
AND BYTES_SCANNED > 0
GROUP BY 1
ORDER BY 5
;


--table scans
--queries query_history and provides details about heavy scanners by warehouse
select 
  User_name
, warehouse_name
, avg(case when partitions_total > 0 then partitions_scanned / partitions_total else 0 end) avg_pct_scanned
from   snowflake.account_usage.query_history
where  start_time::date > dateadd('days', -30, current_date)
group by 1, 2
order by 3 desc
;

--gives list of all full table scans so that we can approach table design accordingly
SELECT top 100 * 
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
WHERE START_TIME >= dateadd(month,-1,current_timestamp())
AND PARTITIONS_SCANNED > (PARTITIONS_TOTAL*0.95)
AND QUERY_TYPE NOT LIKE 'CREATE%'
ORDER BY PARTITIONS_SCANNED DESC
;


--credits used by day for automatic clustering to check any differences in pattern
WITH CREDITS_BY_DAY AS (
    SELECT TO_DATE(START_TIME) as DATE
    ,SUM(CREDITS_USED) as CREDITS_USED
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."AUTOMATIC_CLUSTERING_HISTORY"
    WHERE START_TIME >= dateadd(year,-1,current_timestamp()) 
    GROUP BY 1
  ) 
SELECT DATE_TRUNC('week',DATE)
,AVG(CREDITS_USED) as AVG_DAILY_CREDITS
FROM CREDITS_BY_DAY
GROUP BY 1
ORDER BY 1
;

--credits used by day for materialized views refresh to check any differences in pattern
WITH CREDITS_BY_DAY AS (
    SELECT TO_DATE(START_TIME) as DATE
    ,SUM(CREDITS_USED) as CREDITS_USED
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."MATERIALIZED_VIEW_REFRESH_HISTORY"
    WHERE START_TIME >= dateadd(year,-1,current_timestamp()) 
    GROUP BY 1
  )  
SELECT DATE_TRUNC('week',DATE)
,AVG(CREDITS_USED) as AVG_DAILY_CREDITS
FROM CREDITS_BY_DAY
GROUP BY 1
ORDER BY 1
;

--credits used by day for search optimization history to check any differences in pattern
WITH CREDITS_BY_DAY AS (
    SELECT TO_DATE(START_TIME) as DATE
    ,SUM(CREDITS_USED) as CREDITS_USED
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."SEARCH_OPTIMIZATION_HISTORY"
    WHERE START_TIME >= dateadd(year,-1,current_timestamp()) 
    GROUP BY 1
  )
SELECT DATE_TRUNC('week',DATE)
,AVG(CREDITS_USED) as AVG_DAILY_CREDITS
FROM CREDITS_BY_DAY
GROUP BY 1
ORDER BY 1
;

--credits used by day for snowpipe usage to check any differences in pattern
WITH CREDITS_BY_DAY AS (
    SELECT TO_DATE(START_TIME) as DATE
    ,SUM(CREDITS_USED) as CREDITS_USED
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."PIPE_USAGE_HISTORY"
    WHERE START_TIME >= dateadd(year,-1,current_timestamp()) 
    GROUP BY 1
  ) 
SELECT DATE_TRUNC('week',DATE)
,AVG(CREDITS_USED) as AVG_DAILY_CREDITS
FROM CREDITS_BY_DAY
GROUP BY 1
ORDER BY 1
;

--credits used by day for replication usage to check any differences in pattern
WITH CREDITS_BY_DAY AS (
    SELECT TO_DATE(START_TIME) as DATE
    ,SUM(CREDITS_USED) as CREDITS_USED
    FROM "SNOWFLAKE"."ACCOUNT_USAGE"."REPLICATION_USAGE_HISTORY"
    WHERE START_TIME >= dateadd(year,-1,current_timestamp()) 
    GROUP BY 1
  )
SELECT DATE_TRUNC('week',DATE)
,AVG(CREDITS_USED) as AVG_DAILY_CREDITS
FROM CREDITS_BY_DAY
GROUP BY 1
ORDER BY 1
;