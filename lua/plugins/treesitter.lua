return {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    build = function()
        pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects"
    },

    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            highlight = {
                enable = true, -- false will disable the whole extension
                disable = { "sql" }
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                        ['al'] = '@loop.outer',
                        ['il'] = '@loop.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = '@parameter.inner',
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@parameter.inner',
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@parameter.inner',
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@parameter.inner',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>a'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>A'] = '@parameter.inner',
                    },
                },
            },
        }
    end
}
