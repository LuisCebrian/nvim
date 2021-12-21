" Telescope config
lua require('telescope_config')

function! TelescopeLspDocumentSymbols()
    lua require('telescope.builtin').lsp_document_symbols(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Find Class', prompt_prefix = " ", default_text=" :class: "}))
endfunction

function! TelescopeLspDynamicWorkspaceSymbols()
    lua require('telescope.builtin').lsp_dynamic_workspace_symbols(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Find Class'}))
endfunction

function! TelescopeLiveGrep()
    lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown(git_files))
endfunction

function! TelescopeBuffers()
    lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Buffers', show_all_buffers = true }))
endfunction

function! TelescopeProjectFiles()
    lua require('telescope_config').project_files(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Project Files'}))
endfunction

function! TelescopeFindFiles()
    lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({previewer=false, prompt_title='Find Files'}))
endfunction

function! TelescopeFindWord()
    Telescope grep_string theme=dropdown
endfunction

function! TelescopeCommandHistory()
    Telescope command_history theme=dropdown
endfunction

function! TelescopeGitBranches()
    Telescope git_branches theme=dropdown
endfunction

nnoremap <leader>ff :call TelescopeLspDocumentSymbols()<cr>
nnoremap <leader>fn :call TelescopeLspDynamicWorkspaceSymbols()<cr>
nnoremap <leader>fg :call TelescopeLiveGrep()<cr>
nnoremap <leader>fw :call TelescopeFindWord()<cr>
nnoremap <leader>fc :call TelescopeCommandHistory()<cr>
nnoremap <leader>fb :call TelescopeBuffers()<cr>
nnoremap <leader>ft :call TelescopeGitBranches()<cr>
nnoremap <C-p> :call TelescopeProjectFiles()<cr>
nnoremap <leader>fd :call TelescopeFindFiles()<cr>
