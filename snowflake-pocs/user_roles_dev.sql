--login snowflake user as dev1_usr and run below queries

show warehouses;
show databases;
show roles;
show schemas;

use role DEV_ROLE;
use database sales_fact;
use schema sales_schema;
use warehouse small_elt_wh;

insert into orders (order_id, order_name) values (2, 'from dev role');

select * from orders;

-- Not allowed to create db as per dev role
create database test;
-- Not allowed to create warehouse as per dev role
create warehouse TEST_WH;