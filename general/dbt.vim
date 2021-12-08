let g:isDbtProject = !empty(expand(glob("dbt_project.yml")))
let s:dbtrpcscript = resolve(expand('<sfile>:p:h:h')) . '/general/dbtrpc.py'

" Defaults settings

" DBT RPC server port
let g:dbt_rpc_server_port = get(g:, 'dbt_rpc_server_port', 8580)

execute 'py3file ' . s:dbtrpcscript

function! Redir(cmd)

    redir => output
    execute a:cmd
    redir END

    " Close the window if it already exists
    for win in range(1, winnr('$'))
        if getwinvar(win, 'scratch')
            execute win . 'windo close'
        endif
    endfor

    " Open a new window using full width
    " no matter if we have vertical splits
    botright new

    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile cc=
    call setline(1, split(output, "\n"))
    setlocal noma
endfunction

command! -nargs=1 -complete=command Redir silent call Redir(<q-args>)

function! OpenMirrorFile(extension)
    let currentFile = expand('%:r')
    let docFile = currentFile . '.' . a:extension
    execute 'edit' docFile
endfunction

function! OpenAltFile()
    let extension = expand('%:e')
    if extension ==? 'sql'
        call OpenMirrorFile('yml')
    elseif extension ==? 'yml'
        call OpenMirrorFile('sql')
    endif
endfunction

" warning message
function! s:WarnMsg(msg)
    echohl WarningMsg
    echom a:msg
    echohl NONE
endfunc

function! s:onExit(job_id, data, event)
    call s:WarnMsg('Dbt rpc sever is not running')
endfunc

function! SpinUpDbtServer()
    let l:callbacks = {}
    let l:callbacks['on_exit'] = function('s:onExit')
    let s:serverJob = jobstart('dbt rpc --port '. g:dbt_rpc_server_port, l:callbacks)
    let s:serverPid = jobpid(s:serverJob)
endfunction

" Commands
command! DbtRunSql :Redir python3 print(submitQuery())
command! DbtCompileSql :Redir python3 print(getCompiledSqlSafe())
command! DbtRestartRpcServer :python3 restartRpcServer()
command! DbtOpenDocFile :call OpenMirrorFile('yml')
command! DbtOpenSourceFile :call OpenMirrorFile('sql')
command! DbtOpenAltFile :call OpenAltFile()

" Mappings
nnoremap <leader>bq :DbtRunSql<CR>
nnoremap <leader>bc :DbtCompileSql<CR>
nnoremap <leader>ba :DbtOpenAltFile<CR>

if g:isDbtProject
    autocmd FocusGained,BufWritePost *.sql,*.yml,*.csv :DbtRestartRpcServer
    autocmd VimEnter * :call SpinUpDbtServer()
endif
