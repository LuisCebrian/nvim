nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :call GitDiff()<CR>
nnoremap <leader>gc :call GitCommit()<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gl :vert Git log<CR>
nnoremap <leader>gh :0Gclog<CR>

function! GitDiff()
    " Open git diff in a vertical split
    silent! vert botright Git diff
    " Highlight trailing whitespaces
    match NvimInternalError /[^\s]\s\+$/
endfunction

function! GitCommit()
    " Call Git status
    Git
    " Open vertical diff
    call GitDiff()
    " Position cursor
    " in the Git status window
    Git
endfunction

" Don't fold changes by default
autocmd FileType git set nofoldenable
