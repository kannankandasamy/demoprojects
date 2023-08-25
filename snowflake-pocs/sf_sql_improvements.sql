
use role accountadmin;
use database sales_dwh;
use schema sales_schema;
--New sql improvements in snowflake
--exclude and rename in select *
show tables;
select current_database();

select * exclude (dob,cust_name) from dim_customer;

select * exclude (dob,cust_name) rename (cust_id AS id) from dim_customer;

--min_by and max_by
select min_by(cust_id, insert_date), max_by(cust_id, insert_date) from dim_customer ;

--group by all
select dob, count(*) as cnt from dim_customer
group by all;

