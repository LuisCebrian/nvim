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
        },
        highlight_git = true,
        icons = {
            glyphs = {
                default = '',
                symlink = '',
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★"
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = ""
                }
            }
        }
    }
}

vim.keymap.set('n', '<leader>e', vim.cmd.NvimTreeToggle)
vim.keymap.set('n', '<leader>fe', vim.cmd.NvimTreeFindFile)
