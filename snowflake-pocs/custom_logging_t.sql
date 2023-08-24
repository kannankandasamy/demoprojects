USE DATABASE dev_db;
CREATE SCHEMA logs;

USE dev_db.logs;

CREATE OR REPLACE TABLE JOB_LOG(
     JOB_LOG_ID  INT
    ,JOB_NAME   VARCHAR(100)
    ,START_DATE DATETIME
    ,END_DATE   DATETIME
    ,JOB_STATUS VARCHAR(100)
    ,JOB_ORCHESTRATOR   VARCHAR(100)
    ,MODIFIED_DATE  DATETIME DEFAULT CURRENT_TIMESTAMP()
    ,CREATED_DATE   DATETIME DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE PROCESS_LOG(
     PROCESS_LOG_ID INT IDENTITY(1,1)
    ,JOB_LOG_ID  INT
    ,PROCESS_NAME   VARCHAR(100)
    ,START_DATE DATETIME
    ,END_DATE   DATETIME
    ,PROCESS_STATUS VARCHAR(100)
    ,MODIFIED_DATE  DATETIME DEFAULT CURRENT_TIMESTAMP()
    ,CREATED_DATE   DATETIME DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE TASK_LOG(
     TASK_LOG_ID INT  IDENTITY(1,1)
    ,PROCESS_LOG_ID INT
    ,TASK_NAME   VARCHAR(100)
    ,LOG_DATE DATETIME
    ,TASK_STATUS VARCHAR(100)
    ,MODIFIED_DATE  DATETIME DEFAULT CURRENT_TIMESTAMP()
    ,CREATED_DATE   DATETIME DEFAULT CURRENT_TIMESTAMP()    
);

CREATE OR REPLACE SEQUENCE JOB_SEQ start = 1 increment = 1;
CREATE OR REPLACE SEQUENCE PROCESS_SEQ start = 1 increment = 1;


CREATE OR REPLACE PROCEDURE SP_AUDIT_JOB_INSERT(P_JOB_NAME STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS 
    $$

    var V_JOB_NAME = P_JOB_NAME;
    var RET_VAL = ""

    var sql_command1 = `SET next_job_id = JOB_SEQ.NEXTVAL;`

    var sql_command2 = `INSERT INTO JOB_LOG(
         JOB_LOG_ID
        ,JOB_NAME
        ,START_DATE
        ,END_DATE
        ,JOB_STATUS
        ,JOB_ORCHESTRATOR
    )
    SELECT $next_job_id as JOB_LOG_ID
    ,'` + V_JOB_NAME + `' AS JOB_NAME
    ,CURRENT_TIMESTAMP() AS START_DATE
    ,NULL AS END_DATE
    ,'STARTED' AS JOB_STATUS
    ,NULL AS JOB_ORCHESTRATOR`;

    var sql_command3 = `SELECT $next_job_id;`

    try 
    {
        snowflake.execute(
            {sqlText: sql_command1}
        );

        snowflake.execute(
            {sqlText: sql_command2}
        );
        rs = snowflake.execute(
            {sqlText: sql_command3}
        );

        if (rs.next())
        {
            RET_VAL = rs.getColumnValue(1);
        }
        return RET_VAL;
    }
    catch (err) {
        return "FAILED" + err
    }
$$;


CREATE OR REPLACE PROCEDURE SP_AUDIT_JOB_UPDATE(P_JOB_LOG_ID STRING, P_JOB_STATUS STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS 
    $$

    var V_JOB_LOG_ID = P_JOB_LOG_ID;
    var V_JOB_STATUS = P_JOB_STATUS;
    var RET_VAL = "SUCCESS"

    var sql_command1 = `UPDATE JOB_LOG SET JOB_STATUS =,'` + V_JOB_STATUS + `',
        END_DATE = CURRENT_TIMESTAMP()
        WHERE JOB_LOG_ID = ` + V_JOB_LOG_ID + `;`;

    try 
    {
        snowflake.execute(
            {sqlText: sql_command1}
        );

        return RET_VAL;
    }
    catch (err) {
        return "FAILED" + err
    }
$$;

show sequences;

CREATE OR REPLACE PROCEDURE SP_AUDIT_PROCESS_INSERT(P_PROCESS_NAME STRING, P_JOB_LOG_ID STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS 
    $$

    var V_PROCESS_NAME  = P_PROCESS_NAME;
    var V_JOB_LOG_ID    = P_JOB_LOG_ID;
    var RET_VAL         = ""

    var sql_command1 = `SET next_proc_id = PROCESS_SEQ.NEXTVAL;`

    var sql_command2 = `INSERT INTO PROCESS_LOG(
         JOB_LOG_ID
        ,PROCESS_LOG_ID 
        ,PROCESS_NAME
        ,START_DATE
        ,END_DATE
        ,PROCESS_STATUS
    )
    SELECT '` + V_JOB_LOG_ID + `' AS JOB_LOG_ID
    ,$next_proc_id as PROCESS_LOG_ID
    ,'` + V_PROCESS_NAME + `' AS PROCESS_NAME
    ,CURRENT_TIMESTAMP() AS START_DATE
    ,NULL AS END_DATE
    ,'STARTED' AS PROCESS_STATUS;`;

    var sql_command3 = `SELECT $next_proc_id;`

    try 
    {
        snowflake.execute(
            {sqlText: sql_command1}
        );

        snowflake.execute(
            {sqlText: sql_command2}
        );

        rs = snowflake.execute(
            {sqlText: sql_command3}
        );

        if (rs.next())
        {
            RET_VAL += rs.getColumnValue(1);
        }

        return RET_VAL;
    }
    catch (err) {
        return "FAILED" + err
    }
$$;



CREATE OR REPLACE PROCEDURE SP_AUDIT_PROCESS_UPDATE(P_JOB_LOG_ID STRING, P_PROCESS_LOG_ID STRING, P_PROCESS_STATUS STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS 
    $$

    var V_JOB_LOG_ID = P_JOB_LOG_ID;
    var V_PROCESS_LOG_ID = P_PROCESS_LOG_ID;
    var V_PROCESS_STATUS = P_PROCESS_STATUS;
    var RET_VAL = "SUCCESS"

    var sql_command1 = `UPDATE PROCESS_LOG SET PROCESS_STATUS =,'` + V_PROCESS_STATUS + `',
        END_DATE = CURRENT_TIMESTAMP()
        WHERE JOB_LOG_ID = ` + V_JOB_LOG_ID + `
        AND PROCESS_LOG_ID = ` + V_PROCESS_LOG_ID + `;`;

    try 
    {
        snowflake.execute(
            {sqlText: sql_command1}
        );

        return RET_VAL;
    }
    catch (err) {
        return "FAILED" + err
    }
$$;

SHOW PROCEDURES ;
--drop procedure SP_PROCESS_JOB_INSERT(VARCHAR, VARCHAR);



CREATE OR REPLACE PROCEDURE SP_AUDIT_TASK_INSERT(P_TASK_NAME STRING, P_PROCESS_LOG_ID STRING, P_TASK_STATUS STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS 
    $$

    var V_TASK_NAME         = P_TASK_NAME;
    var V_PROCESS_LOG_ID    = P_PROCESS_LOG_ID;
    var V_TASK_STATUS       = P_TASK_STATUS
    var RET_VAL             = "SUCCESS"

    var sql_command1 = `INSERT INTO TASK_LOG(
         PROCESS_LOG_ID
        ,TASK_NAME
        ,LOG_DATE
        ,TASK_STATUS
    )
    SELECT '` + V_PROCESS_LOG_ID + `' AS PROCESS_LOG_ID
    ,'` + V_TASK_NAME + `' AS TASK_NAME
    ,CURRENT_TIMESTAMP() AS LOG_DATE
    ,'` + V_TASK_STATUS + `'  AS TASK_STATUS;`;

    try 
    {
        snowflake.execute(
            {sqlText: sql_command1}
        );

        return RET_VAL;
    }
    catch (err) {
        return "FAILED" + err
    }
$$;



CREATE OR REPLACE PROCEDURE SP_SKELETON_LOAD(P_JOB_LOG_ID STRING)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS 
    $$

    var V_JOB_LOG_ID    = P_JOB_LOG_ID;
    var V_PROCESS_NAME  = "SP_SKELETON_LOAD"; 
    var RET_VAL = "SUCCESS";

    function process_insert(process_name, job_log_id){
        var out;
        rs = snowflake.createStatement({ sqlText: `call SP_AUDIT_PROCESS_INSERT(:1,:2)`, binds:[process_name, job_log_id] }).execute();
        rs.next();
        out = rs.getColumnValue(1);
        return out;
    }

    function process_update(job_log_id, process_log_id, process_status){
        snowflake.createStatement({ sqlText: `call SP_AUDIT_PROCESS_UPDATE(:1,:2,:3)`, binds:[job_log_id, process_log_id, process_status] }).execute();
    }

    function task_insert(task_name, process_log_id, task_status){
        snowflake.createStatement({ sqlText: `call SP_AUDIT_TASK_INSERT(:1,:2,:3)`, binds:[task_name, process_log_id, task_status] }).execute();
    }

    var sql_command1 = ``;

    var sql_command2 = ``;

    var sql_command3 = ``;

    var sql_command4 = ``;

    var sql_command5 = ``;

    var proc_id = process_insert(V_PROCESS_NAME, V_JOB_LOG_ID);

    try 
    {
        snowflake.execute(
            {sqlText: sql_command1}
        );
        task_insert("step1 completed", proc_id, "SUCCESS");

        snowflake.execute(
            {sqlText: sql_command2}
        );
        task_insert("step2 completed", proc_id, "SUCCESS");

        snowflake.execute(
            {sqlText: sql_command3}
        );
        task_insert("step3 completed", proc_id, "SUCCESS");

        snowflake.execute(
            {sqlText: sql_command4}
        );
        task_insert("step4 completed", proc_id, "SUCCESS");

        snowflake.execute(
            {sqlText: sql_command5}
        );
        task_insert("step5 completed", proc_id, "SUCCESS");

        process_update(V_JOB_LOG_ID, proc_id, "SUCCESS")
        return RET_VAL;
    }
    catch (err) {
        return "FAILED" + err
    }
$$;

show procedures;

