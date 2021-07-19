let g:isDbtProject = !empty(expand(glob("dbt_project.yml")))
let s:dbtrpcscript = resolve(expand('<sfile>:p:h:h')) . '/general/dbtrpc.py'

execute 'py3file ' . s:dbtrpcscript

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

nmap <leader>bq :Redir python3 print(submitQuery())<CR>
nmap <leader>bc :Redir python3 print(getCompiledSqlSafe())<CR>

if g:isDbtProject
    autocmd BufWritePost *.sql :python3 restartRpcServer()
endif
