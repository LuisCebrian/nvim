let g:isDbtProject = !empty(expand(glob("dbt_project.yml")))
let s:dbtrpcscript = resolve(expand('<sfile>:p:h:h')) . '/general/dbtrpc.py'

" Defaults settings

" DBT RPC server port
let g:dbt_rpc_server_port = get(g:, 'dbt_rpc_server_port', 8580)

" Number of results to return
let g:dbt_query_results_limit = get(g:, 'dbt_query_results_limit', 200)

execute 'py3file ' . s:dbtrpcscript

" Redirect the output of the command to a file
function! s:RedirOutput(cmd)

    redir => output
    execute a:cmd
    redir END

    return output
endfunction


function! Redir(cmd, filetype='')

    let l:output = trim(execute("silent call s:RedirOutput(a:cmd)"))

    if l:output == ''
        echom 'Query returned no results'
        return 0
    endif

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
    call setline(1, split(l:output, "\n"))
    setlocal noma
    if a:filetype !=# ''
        let &l:filetype = a:filetype
    endif
endfunction

" command! -nargs=1 -complete=command Redir call Redir(<q-args>)

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

" From a model file, find its documentation
function FindDbtDocumentation()
    let l:qflist = getqflist()
    let l:modelName = expand('%:t:r')
    silent execute "grep -r --include \\*.yml " . "'name:\\s*" l:modelName . "' ."
    call setqflist(l:qflist, 'r')
endfunction

" warning message
function! s:WarnMsg(msg)
    echohl WarningMsg
    echom a:msg
    echohl NONE
endfunc

" error message
function! s:ErrMsg(msg)
    echohl ErrorMsg
    echom a:msg
    echohl NONE
endfunc

function! s:onError(job_id, data, event)
    call s:WarnMsg('Dbt rpc sever is not running')
endfunc

function! SpinUpDbtServer()
    let l:callbacks = {}
    let l:callbacks['on_stderr'] = function('s:onError')
    let s:serverJob = jobstart('dbt-rpc serve --port '. g:dbt_rpc_server_port, l:callbacks)
    let s:serverPid = jobpid(s:serverJob)
endfunction

function! DbtCommand(args)
    execute '25new + term://dbt '. a:args
endfunction

function! DbtCompileSql()
    call Redir('python3 print(getCompiledSqlSafe())', 'sql')
endfunction

function! DbtRunSql(count)
    if a:count ># 0
        let l:limit = a:count
    else
        let l:limit = g:dbt_query_results_limit
    endif
    call Redir('python3 print(submitQuery('. l:limit .'))')
endfunction

function! s:PrettyBytes(bytes)
  let l:bytes = a:bytes
  let l:sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
  let l:i = 0
  while l:bytes >= 1024
      let l:bytes = l:bytes / 1024.0
      let l:i += 1
  endwhile
  return l:bytes > 0 ? printf(' %.1f%s ', l:bytes, l:sizes[l:i]) : ''
endfunction

function! s:printBilledBytes(bytes)
    echom 'This query will process'
    echohl Character
    echon a:bytes
    echohl NONE
    echon ' when run.'
endfunction

function! DbtCheckSql()
    let l:output = substitute(trim(execute("python3 print(previewData())")), '\%x00', " ", "")
    if l:output =~# '^Query successfully validated'
        let l:bytes = s:PrettyBytes(str2nr(matchlist(l:output, '\d\+')[0]))
        call s:printBilledBytes(l:bytes)
        return
    elseif l:output =~# '^Error in query string:'
        let l:output = substitute(l:output, "Error in query string: ", "", "")
    elseif l:output =~# '^BigQuery error'
        let l:output = substitute(l:output, "BigQuery error in query operation: ", "", "")
    endif
    call s:ErrMsg(l:output)
endfunction

" Commands
command! -nargs=1 Dbt :call DbtCommand(<q-args>)
command! -count=0 DbtRunSql :call DbtRunSql(<count>)
command! DbtCompileSql :call DbtCompileSql()
command! DbtCheckSql :call DbtCheckSql()
command! DbtRestartRpcServer :python3 restartRpcServer()
command! DbtOpenDocFile :call FindDbtDocumentation()
command! DbtOpenSourceFile :call OpenMirrorFile('sql')
command! DbtOpenAltFile :call OpenAltFile()

" Mappings
nnoremap <leader>bq :DbtRunSql<CR>
nnoremap <leader>bc :DbtCompileSql<CR>
nnoremap <leader>bp :DbtCheckSql<CR>
nnoremap <leader>ba :DbtOpenAltFile<CR>
nnoremap <leader>bt :Dbt test -m %<CR>
nnoremap <leader>br :Dbt run -m %<CR>

if g:isDbtProject
    autocmd FocusGained,BufWritePost *.sql,*.yml,*.csv :DbtRestartRpcServer
    autocmd VimEnter * :call SpinUpDbtServer()
endif
