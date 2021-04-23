nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :call GitDiff()<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gl :silent! Glog<CR>
nnoremap <leader>gh :0Glog<CR>

function GitDiff()
    " Open git diff in a vertical split
    silent! vert Git diff
    " Highlight trailing whitespaces
    match NvimInternalError /[^\s]\s\+$/
endfunction

" Don't fold changes by default
autocmd FileType git set nofoldenable
