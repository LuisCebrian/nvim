import base64
import json
import os
import time
import uuid

import requests
import vim

RPC_SERVER_PORT = vim.eval("g:dbt_rpc_server_port")
TMP_FILE = "/tmp/bigquery.txt"
SERVER_URL = f"http://0.0.0.0:{RPC_SERVER_PORT}/jsonrpc"
HEADERS = {"content-type": "application/json"}


class GenericRpcError(Exception):
    @classmethod
    def from_response(cls, response):
        code = response["error"]["code"]
        message = response["error"]["message"]
        error_type = response["error"]["data"].get("type")
        error_message = response["error"]["data"]["message"]
        return cls(f"({code}, {message}): {error_type}, {error_message}")


class CompilingRpcError(GenericRpcError):
    code = 10010


class FailedCompilationRpcError(GenericRpcError):
    code = 10011

    @classmethod
    def from_response(cls, response):
        code = response["error"]["code"]
        cause = response["error"]["data"]["cause"]["message"]
        return cls(f"({code}): {cause}")


def errorFromCode(code):
    error_codes = {
        CompilingRpcError.code: CompilingRpcError,
        FailedCompilationRpcError.code: FailedCompilationRpcError,
    }
    return error_codes.get(code, GenericRpcError)


def uniqueId():
    return uuid.uuid1().int


def formatJson(data):
    return json.dumps(data, indent=2)


def guardCompilingError(func):
    def _f(*args, **kwargs):
        while True:
            try:
                return func(*args, **kwargs)
            except CompilingRpcError:
                time.sleep(0.1)

    return _f


def checkErrors(response):
    if "error" not in response:
        return
    code = response["error"]["code"]
    error = errorFromCode(code).from_response(response)
    raise error


def raiseError(func):
    def _f(*args, **kwargs):
        response = func(*args, **kwargs)
        checkErrors(response)
        return response

    return _f


@raiseError
def requestServer(data=None):
    response = requests.post(SERVER_URL, data=json.dumps(data), headers=HEADERS).json()
    return response


def pollResults(payload):
    while True:
        response = requestServer(payload)
        if response["result"]["state"] == "success":
            return response
        time.sleep(0.1)


@guardCompilingError
def submitCompileJob():
    cb = "\n".join(vim.current.buffer)
    sql = cb.encode("utf-8")
    encoded_sql = base64.b64encode(sql).decode("utf-8")
    filepath = vim.current.buffer.name
    filename = os.path.splitext(os.path.basename(filepath))[0]
    payload = {
        "jsonrpc": "2.0",
        "method": "compile_sql",
        "id": uniqueId(),
        "params": {"timeout": 60, "sql": encoded_sql, "name": filename},
    }
    response = requestServer(payload)
    return response


def requestCompiledResult(request_token):
    payload = {
        "jsonrpc": "2.0",
        "method": "poll",
        "id": uniqueId(),
        "params": {"request_token": request_token},
    }
    response = pollResults(payload)
    return response


def getCompiledSql():
    try:
        response = submitCompileJob()
    except GenericRpcError as e:
        raise e
    except Exception:
        raise Exception("DBT Server Rpc is not running. Run: 'dbt rpc'")

    try:
        request_token = response["result"]["request_token"]
    except KeyError:
        raise Exception(f"Could not submit compile job:\n {formatJson(response)}")

    response = requestCompiledResult(request_token)

    try:
        query = response["result"]["results"][0]["compiled_sql"]
    except KeyError:
        raise Exception(f"Could not read query:\n {formatJson(response)}")
    return query


def submitQuery(results=100):
    try:
        compiled_sql = getCompiledSql()
    except Exception as e:
        return str(e)

    with open(TMP_FILE, "w") as f:
        f.write(compiled_sql)

    command = f"bq query --use_legacy_sql=false -n {results} < {TMP_FILE}"
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
    except Exception:
        # Server not running
        return

    pid = response["result"]["pid"]
    os.system(f"kill -HUP {pid}")
