-- Creating an user

select current_role();

--change role to accountadmin
use role accountadmin;

--testusr1 creation
--without default role - it will create with public role
create user testusr1 password = '********' must_change_password = FALSE;

show grants to role public;

desc user testusr1;

show grants to user testusr1;
show grants on user testusr1;

--testusr2 creation
--with default role - sysadmin
create or replace user testusr2 
    password = '********' 
    default_role = 'SYSADMIN'
    must_change_password = FALSE;
    
grant role "SYSADMIN" to user testusr2;
grant role "SECURITYADMIN" to user testusr2;
grant role "USERADMIN" to user testusr2;

--orgadmin

use role accountadmin;
use warehouse esmall_wh;

create or replace user orgadminusr 
    password = "********"
    must_change_password = FALSE;

grant usage on warehouse ESMALL_WH to role ORGADMIN;    
grant role "ORGADMIN" to user orgadminusr;

--DAC - Discretionary Access Control
use role accountadmin;
show users;

--RBAC

/*
MGR_ROLE - manages whole project
DEV_ROLE - Can do the development inside a subject area database
LOAD_ROLE - Used only to load the data but does not have any read access but only have write access
ANLST_ROLE - analyst role can read all the data for analysis
QA_ROLE - read all the data for testing 
*/

use role securityadmin;
create role "MGR_ROLE";
grant role "MGR_ROLE" to role SECURITYADMIN;

create role "LOAD_ROLE";
grant role "LOAD_ROLE" to role "MGR_ROLE";

create role "DEV_ROLE";
grant role "DEV_ROLE" to role "MGR_ROLE";

create role "ANLST_ROLE";
grant role "ANLST_ROLE" to role "MGR_ROLE";

create role "QA_ROLE";
grant role "QA_ROLE" to role "ANLST_ROLE";


-- Creating users

use role USERADMIN;

create or replace user mgr_usr password = "********" must_change_password = false;
create or replace user load_usr password = "********" must_change_password = false;
create or replace user anlst1_usr password = "********" must_change_password = false;
create or replace user anlst2_usr password = "********" must_change_password = false;
create or replace user dev1_usr password = "********" must_change_password = false;
create or replace user dev2_usr password = "********" must_change_password = false;
create or replace user qa1_usr password = "********" must_change_password = false;
create or replace user qa2_usr password = "********" must_change_password = false;

--granting roles to users
--for that using securityadmin role as best practices

use role SECURITYADMIN;

grant role "MGR_ROLE" to user mgr_usr;

grant role "LOAD_ROLE" to user load_usr;

grant role "ANLST_ROLE" to user anlst1_usr;
grant role "ANLST_ROLE" to user anlst2_usr;

grant role "DEV_ROLE" to user dev1_usr;
grant role "DEV_ROLE" to user dev2_usr;

grant role "QA_ROLE" to user qa1_usr;
grant role "QA_ROLE" to user qa2_usr;




