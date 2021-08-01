/*
 * Script Details	:	POC using streams on snowflake
 * Author			:	Kannan
 */

USE ROLE sysadmin;
USE SCHEMA SALES;

USE DATABASE TESTDB;

SELECT * FROM TESTDB.SALES.TBL1;

CREATE TABLE CUSTOMER (custid int, firstname varchar, city varchar);

CREATE TABLE CUSTOMERDESTINATION(custid int, firstname varchar, city varchar);

CREATE stream CUSTSTREAM ON TABLE customer;

CREATE stream CUSTSTREAM1 ON TABLE customer;


SHOW streams;

SELECT * FROM custstream;

SELECT * FROM custstream1;


INSERT INTO customer(custid, firstname, city) VALUES (1,'test1','city1');
INSERT INTO customer(custid, firstname, city) VALUES (2,'test2','city1');
INSERT INTO customer(custid, firstname, city) VALUES (3,'test3','city1');
INSERT INTO customer(custid, firstname, city) VALUES (4,'test4','city1');

UPDATE customer SET city = 'city2f' WHERE custid = 2;
UPDATE customer SET city = 'city3a' WHERE custid = 3;


SELECT * FROM customerdestination;

SELECT * FROM customer;

DELETE FROM customer WHERE custid = 3;

SELECT * FROM custstream;
SELECT * FROM custstream1;

MERGE INTO CUSTOMERDESTINATION as dest 
USING (SELECT * FROM custstream WHERE NOT ( METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE = TRUE) ) AS src
ON src.custid = dest.custid
WHEN MATCHED 
AND src.METADATA$ACTION = 'INSERT' AND src.METADATA$ISUPDATE
THEN UPDATE SET dest.city = src.city, dest.firstname = src.firstname
WHEN MATCHED AND src.METADATA$ACTION = 'DELETE' THEN DELETE 
WHEN NOT MATCHED THEN INSERT (custid, firstname, city) values(src.custid, src.firstname, src.city);


DESCRIBE stream custstream1;