/*
 * Script 	:	POC for Different Table types on snowflake
 * Author	:	Kannan Kandasamy
 */

USE DATABASE TEST;
USE WAREHOUSE PROCESS_WH;
USE SCHEMA SAMPLES;

--ALTER SESSION SET USE_CACHED_RESULT = TRUE;
--SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS;

/*
	Permanent - Default, max time travel and 7 days failsafe based on editions
	Temporary - for a given session, temporary data, no time travel or failsafe or cloning available
	Transient - Equivalent to permanent table but do not have failsafe, we can create transient databases and schemas, all objects
				under transient database or schemas also be transient
*/

CREATE OR REPLACE DATABASE PERM_DB;
CREATE OR REPLACE TRANSIENT DATABASE TRANS_DB;

SHOW DATABASES;

USE DATABASE PERM_DB;

CREATE SCHEMA perm_DB.MARKETING;

USE DATABASE TRANS_DB;

CREATE SCHEMA TRANS_DB.MARKETING;

SHOW SCHEMAS;

CREATE OR REPLACE TABLE CUSTOMER (
	CUST_ID 		INT,
	CUST_NAME		VARCHAR(100),
	ENROLL_DATE		DATE,
	CUST_ADDRESS	VARCHAR(500)
);


SHOW TABLES;

USE DATABASE PERM_DB;

USE SCHEMA MARKETING;

--creating same table in permanent db
CREATE OR REPLACE TABLE CUSTOMER (
	CUST_ID 		INT,
	CUST_NAME		VARCHAR(100),
	ENROLL_DATE		DATE,
	CUST_ADDRESS	VARCHAR(500)
);

SHOW TABLES;

USE DATABASE PERM_DB;

CREATE OR REPLACE TRANSIENT SCHEMA FINANCE; 

SHOW SCHEMAS;

USE SCHEMA FINANCE;

--creating same table in permanent db and transient schema
CREATE OR REPLACE TABLE CUSTOMER (
	CUST_ID 		INT,
	CUST_NAME		VARCHAR(100),
	ENROLL_DATE		DATE,
	CUST_ADDRESS	VARCHAR(500)
);

SHOW TABLES;

USE DATABASE PERM_DB;

USE SCHEMA MARKETING;

SHOW TABLES;

CREATE OR REPLACE TEMPORARY TABLE CUSTOMER_TEMP (
	CUST_ID 		INT,
	CUST_NAME		VARCHAR(100),
	ENROLL_DATE		DATE,
	CUST_ADDRESS	VARCHAR(500)
);


SELECT * FROM customer_temp;

INSERT INTO CUSTOMER_TEMP 
SELECT 1, 'Kohli', '2000-03-05','Chennai' UNION ALL
SELECT 2, 'Sachin', '2000-03-05','Mumbai'; 

SHOW TABLES;
--check in snowflake UI the icons
--Try running IN different worksheet

SELECT current_schema();

CREATE OR REPLACE TRANSIENT TABLE CUSTOMER_TRANS CLONE customer_temp;


SHOW TABLES;