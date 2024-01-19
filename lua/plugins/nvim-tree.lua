return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- for file icons
    },
    config = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require 'nvim-tree'.setup {
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
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
    end
}
