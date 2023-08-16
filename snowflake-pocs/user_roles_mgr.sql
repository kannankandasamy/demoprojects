--login using mgr_usr wh has mgr_role access and execute below:

create warehouse SMALL_ELT_WH;
create warehouse LOAD_WH with warehouse_size = "large";

create database DEV_DB;

show warehouses;

create or replace database SALES_DWH;

create schema SALES_SCHEMA;

CREATE TABLE ORDERS(order_id int, order_name varchar);
CREATE or replace TABLE ORDERS_LINE_ITEM(order_item_id int, order_id int, order_name varchar);

grant usage on database SALES_DWH to role "DEV_ROLE";
grant all privileges on schema SALES_SCHEMA to role "DEV_ROLE";
grant all privileges on all tables in schema SALES_SCHEMA to role "DEV_ROLE";

grant usage on warehouse LOAD_WH to role "DEV_ROLE";
grant usage on warehouse SMALL_ELT_WH to role "DEV_ROLE";

grant usage on database SALES_DWH to role "ANLST_ROLE";
grant usage on schema SALES_SCHEMA to role "ANLST_ROLE";
grant select on all tables in schema SALES_SCHEMA to role "ANLST_ROLE";
grant select on all views in schema SALES_SCHEMA to role "ANLST_ROLE";
grant usage on warehouse SMALL_ELT_WH to role "ANLST_ROLE";

grant usage on database SALES_DWH to role "QA_ROLE";
grant usage on schema SALES_SCHEMA to role "QA_ROLE";
grant select on all tables in schema SALES_SCHEMA to role "QA_ROLE";
grant select on all views in schema SALES_SCHEMA to role "QA_ROLE";
grant usage on warehouse SMALL_ELT_WH to role "QA_ROLE";


insert into orders (order_id, order_name) values (1, 'from mgr role');



