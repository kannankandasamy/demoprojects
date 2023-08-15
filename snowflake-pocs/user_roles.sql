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

--DAC - Discretionary Access Control

    


