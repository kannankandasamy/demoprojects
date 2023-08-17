use role DEV_ROLE;
use database SALES_DWH;
use schema sales_schema;
use warehouse small_elt_wh;

--sample data loading 
create or replace table DIM_CUSTOMER(
    cust_id int identity(1,1),
    cust_name varchar,
    phone varchar,
    dob date,
    insert_date timestamp default current_timestamp()
);

select * from snowflake_sample_data.tpch_sf10.customer;

/*
insert into DIM_CUSTOMER
select top 100 c_custkey, c_name, c_phone, null, getdate() from  snowflake_sample_data.tpch_sf10.customer;
*/

insert into dim_customer (cust_name, phone, dob) select 'cust1', '23542345','2000-02-01';

--creating tasks 
--schedule must be minute it should not seconds or values
create or replace task tsk1
    warehouse = small_elt_wh
    schedule = "1 minute"
as
insert into dim_customer (cust_name, phone, dob) select 'cust1', '23542345','2000-02-01';

--show tasks

show tasks;

desc task tsk1;

--execute tasks/resume task does not resume
alter task tsk1 resume;

--to see the task history
select *
  from table(information_schema.task_history())
  order by scheduled_time;

--task suspend
alter task tsk1 suspend;

--creating tasks 
--cron to schedule daily at 5 am
create or replace task tsk2
    warehouse = small_elt_wh
    schedule = 'USING CRON 0 5 * * * UTC'
as
insert into dim_customer (cust_name, phone, dob) select 'cust2task2', '23542345','2000-02-01';

alter task tsk2 resume;

select *
  from table(information_schema.task_history())
  where name = 'TSK2'
  order by scheduled_time;

--creating tasks 
--using serverless task
create or replace task tsk3
    user_task_managed_initial_warehouse_size = 'XSMALL'
    schedule = 'USING CRON 0 21 * * * EST'
as
insert into dim_customer (cust_name, phone, dob) select 'cust2task2', '23542345','2000-02-01';  

show tasks;


alter task tsk3 resume;

select *
  from table(information_schema.task_history())
  where name = 'TSK3'
  order by scheduled_time;

--creating task tree
/*
                root_tsk1

        lvl1_tsk21                lvl1_tsk22

lvl2_21_31    lvl2_21_32     lvl2_22_33    lvl2_22_34

*/
create or replace task ROOT_TSK1
    warehouse = small_elt_wh
    schedule = "1 minute"
as
insert into dim_customer (cust_name, phone, dob) select 'ROOT_TSK1', '23542345','2000-02-01';


create or replace task LVL1_TSK21
    warehouse = small_elt_wh
    after ROOT_TSK1
as
insert into dim_customer (cust_name, phone, dob) select 'LVL1_TSK21', '23542345','2000-02-01';

create or replace task LVL1_TSK22
    warehouse = small_elt_wh
    after ROOT_TSK1
as
insert into dim_customer (cust_name, phone, dob) select 'LVL1_TSK22', '23542345','2000-02-01';

create or replace task LVL2_21_TSK31
    warehouse = small_elt_wh
    after LVL1_TSK21
as
insert into dim_customer (cust_name, phone, dob) select 'LVL2_21_TSK31', '23542345','2000-02-01';

create or replace task LVL2_21_TSK32
    warehouse = small_elt_wh
    after LVL1_TSK21
as
insert into dim_customer (cust_name, phone, dob) select 'LVL2_21_TSK32', '23542345','2000-02-01';

create or replace task LVL2_22_TSK33
    warehouse = small_elt_wh
    after LVL1_TSK22
as
insert into dim_customer (cust_name, phone, dob) select 'LVL2_22_TSK33', '23542345','2000-02-01';


create or replace task LVL2_22_TSK34
    warehouse = small_elt_wh
    after LVL1_TSK22
as
insert into dim_customer (cust_name, phone, dob) select 'LVL2_22_TSK34', '23542345','2000-02-01';

show tasks;

alter task LVL1_TSK21 resume;
alter task LVL1_TSK22 resume;
alter task LVL2_21_TSK31 resume;
alter task LVL2_21_TSK32 resume;
alter task LVL2_22_TSK33 resume;
alter task LVL2_22_TSK34 resume;
alter task ROOT_TSK1 resume;


select *
  from table(information_schema.task_history())
  where name = 'ROOT_TSK1'
  order by scheduled_time;

select * from dim_customer;

alter task ROOT_TSK1 suspend;

--with stream 

create table STG_CUSTOMER as select * from DIM_CUSTOMER where 1=2;

--creating stream
create stream STG_CUSTOMER_STREAM on table STG_CUSTOMER;

select * from dim_customer;
--truncate table dim_customer;

select * from stg_customer;
desc table stg_customer;
select * from stg_customer_stream;
insert into stg_customer (cust_name, phone, dob) select 'stream_data', '23542345','2000-02-01';

create or replace task TSK_WITH_STREAM
    warehouse = small_elt_wh
    schedule = "1 minute"
when 
    SYSTEM$STREAM_HAS_DATA('STG_CUSTOMER_STREAM')
as
insert into dim_customer (cust_name, phone, dob) select cust_name, phone, dob from stg_customer_stream where metadata$action = 'INSERT' and metadata$isupdate = 'FALSE';

alter TASK TSK_WITH_STREAM resume;
show tasks;