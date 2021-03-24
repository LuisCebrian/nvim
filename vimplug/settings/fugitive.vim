nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :vert Git diff<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gl :silent! Glog<CR>

"Show the font in green / red instead of the background
hi DiffAdd cterm=reverse ctermfg=2 gui=reverse guifg=#2E3440 guibg=#A3BE8C
hi DiffDelete cterm=reverse ctermfg=1 gui=reverse guifg=#2E3440 guibg=#BF616A
