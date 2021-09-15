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
    autocmd BufWritePost *.sql,*.yml :DbtRestartRpcServer
endif
