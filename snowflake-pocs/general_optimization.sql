--optimization - cost optimization or performance optimization, observing and reducing

use role accountadmin;
use database sales_dwh;
use schema sales_schema;

show parameters for session;

--STATEMENT_TIMEOUT_IN_SECONDS
--watch out this parameter - default values is 172800, by default its 2 days ideal value can be set it up in warehouse level at max of 3600 which is ideally 1 hour


create warehouse SALES_WH
    warehouse_size = 'XSMALL'
    statement_timeout_in_seconds = 3600
;

--Check remote data spills in network - shows warehouse is not rightly sized

describe warehouse SALES_WH;

