from library.utils import *
from sqlalchemy import create_engine
import os

# main function to connect sqlalchemy
if __name__ == '__main__':
    #Getting data from config
    testconf = get_proc_config('snow.conf', 'SNOW_APP_CONFIGS')
    #Getting connection string from environment variable
    conn_str = os.getenv(testconf['conn_string']).split('---')
    print(testconf['conn_string'])
    snowaccount = conn_str[0]
    snowuser = conn_str[1]
    snowpwd = conn_str[2]
    print(snowaccount)
    engine = create_engine(
        'snowflake://{user}:{password}@{account_identifier}/'.format(
            user=snowuser,
            password=snowpwd,
            account_identifier=snowaccount,
        )
    )

    try:
        print("Connecting..")
        engine.echo = True
        connection = engine.connect()
        print("Executing... select version...")
        results = connection.execute('select current_version()').fetchone()
        print(results[0])
        connection.close()
    except:
        print("Error")
    finally:
        connection.close()
        engine.dispose()



