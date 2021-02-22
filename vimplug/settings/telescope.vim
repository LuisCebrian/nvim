" Telescope config
lua require('telescope_config')
nnoremap <leader>ff :Telescope find_files<cr>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>fg :lua require('telescope.builtin').live_grep(git_files)<cr>
nnoremap <leader>fb :lua require('telescope.builtin').buffers{ show_all_buffers = true }<cr>
