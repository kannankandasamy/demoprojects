/*
 * Script 	:	POC for Pricing on snowflake
 * Author	:	Kannan Kandasamy
 */

USE DATABASE SNOWFLAKE;
--USE WAREHOUSE compute_wh;
USE SCHEMA ACCOUNT_USAGE;
USE ROLE AccountAdmin; -- or security admin

--seperates compute AND storage costs
--charges based ON consumed credits - NOT BY ANY SPECIFIC currency
--value OF credits changes based ON edition AND customer
--other costs DATA transfer cost, cloud services cost etc

SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS WHERE TABLE_CATALOG = 'TEST';

-- Warehouses with credits
SELECT
	top 10 
	warehouse_name,
	SUM( credits_used_cloud_services ) credits_on_cloud_services,
	SUM( credits_used_compute ) credits_on_compute,
	SUM( credits_used ) credits_tota_used
FROM
	warehouse_metering_history
WHERE
	TRUE
	AND start_time >= TIMESTAMPADD( DAY, - 30, CURRENT_TIMESTAMP )
GROUP BY
	warehouse_name
ORDER BY
	2 DESC;

	
--credits based on query types
SELECT
	top 10 
	query_type,
	SUM( credits_used_cloud_services ) cloud_services_credits,
	COUNT( 1 ) queries_count
FROM
	query_history
WHERE
	TRUE
	AND start_time >= TIMESTAMPADD( DAY, - 10, CURRENT_TIMESTAMP )
GROUP BY
	query_type
ORDER BY
	2 DESC;



--storage costs billable per tb
SELECT
	date_trunc(MONTH, usage_date) AS usage_month ,
	AVG( storage_bytes + stage_bytes + failsafe_bytes ) / POWER( 1024, 4 ) AS billable_tb
FROM
	storage_usage
GROUP BY 1
ORDER BY 1;


--query to check failed logins
SELECT
	user_name,
	COUNT(*) AS failed_logins,
	AVG( seconds_between_login_attempts ) AS average_seconds_between_login_attempts
FROM
	(
		SELECT
			user_name,
			timediff(
				seconds,
				event_timestamp,
				lead(event_timestamp) OVER(
					PARTITION BY user_name
				ORDER BY
					event_timestamp
				)
			) AS seconds_between_login_attempts
		FROM
			login_history
		WHERE
			event_timestamp > date_trunc(
				MONTH,
				CURRENT_DATE
			)
			AND is_success = 'NO'
	)
GROUP BY
	1
ORDER BY
	3;


/*
--serverless features costs
	snowpipe
	DATABASE replication
	MATERIALIZED VIEWS 
	SOS - SEARCH Optimization service -- little costly AS an exeperienced tip
*/
