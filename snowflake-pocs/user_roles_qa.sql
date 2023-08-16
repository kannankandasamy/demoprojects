--login snowflake user as qa1_usr or qa2_usr and run below queries

show warehouses;
show databases;
show roles;
show schemas;

use role QA_ROLE;
use database SALES_DWH;
use schema sales_schema;
use warehouse small_elt_wh;

--Not allowed to insert record
insert into orders (order_id, order_name) values (2, 'from dev role');

--allowed to select
select * from orders;
select * from orders_line_item;

-- Not allowed to create db as per dev role
create database test;
-- Not allowed to create warehouse as per dev role
create warehouse TEST_WH;