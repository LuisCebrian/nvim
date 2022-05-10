let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★"
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>fe :NvimTreeFindFile<CR>

autocmd FocusGained * :NvimTreeRefresh

lua << EOF
require'nvim-tree'.setup {
    update_cwd = true,
    update_focused_file = {
        enable = false
    },
    filters = {
        custom = {
            '.git',
            'node_modules',
            '.cache',
            '__pycache__'
        }
    },
    view = {
        width = 40
    },
    renderer = {
        indent_markers = {
            enable = true
        }
    }
}
EOF
