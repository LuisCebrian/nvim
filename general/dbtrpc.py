import os
import json
import base64
import time

import requests
import uuid

import vim


SERVER_URL = "http://0.0.0.0:8580/jsonrpc"
HEADERS = {'content-type': 'application/json'}


def uniqueId():
    return uuid.uuid1().int

def checkErrors(response):
    if 'error' not in response:
        return
    code = response['error']['code']
    message = response['error']['message']
    error_type = response['error']['data']['type']
    error_message = response['error']['data']['message']
    raise Exception(f'({code}, {message}): {error_type}, {error_message}')


def pollResults(payload):
    while True:
        response = requests.post(
            SERVER_URL, data=json.dumps(payload), headers=HEADERS
        ).json()

        checkErrors(response)

        if response['result']['state'] == 'success':
            return response
        time.sleep(0.1)


def submitCompileJob():
    cb = '\n'.join(vim.current.buffer)
    sql = cb.encode('ascii')
    encoded_sql = base64.b64encode(sql).decode('utf-8')
    filepath = vim.current.buffer.name
    filename = os.path.splitext(os.path.basename(filepath))[0]
    payload = {
            "jsonrpc": "2.0",
            "method": "compile_sql",
            "id": uniqueId(),
            "params": {
                "timeout": 60,
                "sql": encoded_sql,
                "name": filename
                }
            }
    response = requests.post(
        SERVER_URL, data=json.dumps(payload), headers=HEADERS
    ).json()
    return response


def requestCompiledResult(request_token):
    payload = {
        "jsonrpc": "2.0",
        "method": "poll",
        "id": uniqueId(),
        "params": {"request_token": request_token}
    }
    response = pollResults(payload)
    return response

def getCompiledSql():
    try:
        response = submitCompileJob()
    except:
        raise Exception('DBT Server Rpc is not running. Run: \'dbt rpc\'')

    request_token = response['result']['request_token']

    response = requestCompiledResult(request_token)

    query = response['result']['results'][0]['compiled_sql']
    return query


def submitQuery(tmp_file='/tmp/bigquery.txt'):
    try:
        compiled_sql = getCompiledSql()
    except Exception as e:
        return str(e)

    with open(tmp_file, 'w') as f:
        f.write(compiled_sql)

    command = 'bq query --use_legacy_sql=false < {}'.format(tmp_file)
    output = os.popen(command).read()
    return output

def getCompiledSqlSafe():
    try:
        return getCompiledSql()
    except Exception as e:
        return str(e)

def restartRpcServer():
    payload = {
        "jsonrpc": "2.0",
        "method": "status",
        "id": uniqueId(),
    }
    try:
        response = requests.post(
            SERVER_URL, data=json.dumps(payload), headers=HEADERS
        ).json()
    except:
        # Server not running
        return

    pid = response['result']['pid']
    os.system(f'kill -HUP {pid}')

