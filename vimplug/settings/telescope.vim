" Telescope config
lua require('telescope_config')
nnoremap <leader>ff :lua require('telescope.builtin').lsp_document_symbols(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Find Class', prompt_prefix = " ", default_text=" :class: "}))<cr>
nnoremap <leader>fn :lua require('telescope.builtin').lsp_dynamic_workspace_symbols(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Find Class'}))<cr>
nnoremap <leader>fg :lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown(git_files))<cr>

nnoremap <leader>fb :lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Buffers', show_all_buffers = true }))<cr>
nnoremap <C-p> :lua require('telescope_config').project_files(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Project Files'}))<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Find Files'}))<cr>
