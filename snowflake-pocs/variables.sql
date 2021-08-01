/*
 * Script Details	:	POC using variables on snowflake
 * Author			:	Kannan
 */

USE demo_db;
USE ROLE sysadmin;
USE WAREHOUSE compute_wh;

USE SCHEMA PUBLIC;

SHOW VARIABLES;

SHOW TABLES;



set tvar = 10;

select $tvar;

set (var1,var2) = (1,'test2');

set var3 = '%test%';

select $var2;

CREATE OR REPLACE table TEST(i int, v varchar);

insert into TEST(i, v) values(1,'test1');
insert into TEST(i, v) values(2,'test2');

select * from TEST where v like $var3;

create table identifier($var2) (i int autoincrement, v varchar);

select * from TEST2;

select * from identifier($var2);
SELECT * FROM table($var2);

insert into identifier($var2) (i, v) values(2,'test2');

SHOW VARIABLES;

SELECT getvariable('VAR2');

UNSET var1;