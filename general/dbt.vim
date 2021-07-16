python3 << en

import os
import json
import base64
import time

import requests
import uuid

import vim


def poll(url, headers, payload, retries=3):
    while True:
        response = requests.post(
            url, data=json.dumps(payload), headers=headers
                ).json()
        if response['result']['state'] == 'success':
            return response
        time.sleep(0.1)


def submitRpc():
    url = "http://0.0.0.0:8580/jsonrpc"
    headers = {'content-type': 'application/json'}
    cb = '\n'.join(vim.current.buffer)
    sql = cb.encode('ascii')
    encoded_sql = base64.b64encode(sql).decode('utf-8')
    filepath = vim.current.buffer.name
    filename = os.path.splitext(os.path.basename(filepath))[0]
    payload = {
            "jsonrpc": "2.0",
            "method": "compile_sql",
            "id": uuid.uuid1().int,
            "params": {
                "timeout": 60,
                "sql": encoded_sql,
                "name": filename
                }
            }
    try:
        response = requests.post(
            url, data=json.dumps(payload), headers=headers
                ).json()
    except:
        print('Rpc Server is not running')
        return


    request_token = response['result']['request_token']

    payload = {
        "jsonrpc": "2.0",
        "method": "poll",
        "id": uuid.uuid1().int,
        "params": {"request_token": request_token}
        }

    response = poll(url, headers, payload, retries=5)

    query = response['result']['results'][0]['compiled_sql']

    dest_file = '/tmp/bigquery.txt'

    with open(dest_file, 'w') as f:
        f.write(query)

    command = 'bq query --use_legacy_sql=false < {}'.format(dest_file)
    print(os.popen(command).read())
en

function! Redir(cmd)
    for win in range(1, winnr('$'))
        if getwinvar(win, 'scratch')
            execute win . 'windo close'
        endif
    endfor

    redir => output
    execute a:cmd
    redir END

    new
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile cc=
    call setline(1, split(output, "\n"))
    setlocal noma
endfunction

command! -nargs=1 -complete=command Redir silent call Redir(<q-args>)

nmap <leader>bq :Redir python3 submitRpc()<CR>
