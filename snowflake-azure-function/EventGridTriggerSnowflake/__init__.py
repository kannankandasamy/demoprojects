import os
import json
import logging

import azure.functions as func
import snowflake.connector


def main(event: func.EventGridEvent):
    connstr = os.getenv("connectionstring").split('|')
    conn = snowflake.connector.connect(
                user=connstr[0],
                password=connstr[1],
                account=connstr[2],
                warehouse=connstr[3],
                database=connstr[4],
                schema=connstr[5],
                role=connstr[6]
                )
    
    cur = conn.cursor()
    op = cur.execute('call "TESTDB"."PUBLIC".sp_test_azure();')

    cur.close()
    conn.close()

    result = json.dumps({
        'id': event.id,
        'data': event.get_json(),
        'topic': event.topic,
        'subject': event.subject,
        'event_type': event.event_type,
    })

    logging.info('Python EventGrid trigger processed an event: %s', result)
