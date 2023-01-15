return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        { "nvim-telescope/telescope-dap.nvim" }
    },

    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local builtin = require('telescope.builtin')
        local lga_actions = require("telescope-live-grep-args.actions")

        telescope.setup {
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<C-c>"] = function() vim.cmd [[stopinsert]] end
                    },
                }
            },
            pickers = {
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    prompt_title = 'Buffers',
                    show_all_buffers = true
                },
                lsp_document_symbols = {
                    theme = "dropdown",
                    previewer = false,
                },
                lsp_dynamic_workspace_symbols = {
                    theme = "dropdown",
                    previewer = false,
                },
                git_files = {
                    theme = "dropdown",
                    previewer = false,
                    prompt_title = 'Project Files'
                },
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    prompt_title = 'Find Files'
                },
                grep_string = {
                    theme = "dropdown",
                },
                command_history = {
                    theme = "dropdown",
                },
                git_branches = {
                    theme = "dropdown",
                }
            },
            extensions = {
                live_grep_args = {
                    auto_quoting = true,
                    mappings = {
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        }
                    },
                    theme = "dropdown"
                }
            }
        }

        telescope.load_extension("live_grep_args")
        telescope.load_extension('dap')

        vim.keymap.set('n', '<leader>ff', builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<leader>fn', builtin.lsp_dynamic_workspace_symbols, {})
        vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {})
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
        vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>ft', builtin.git_branches, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>fd', builtin.find_files, {})

        local theme = require('telescope.themes').get_dropdown()
        vim.keymap.set('n', '<leader>dp', function() telescope.extensions.dap.list_breakpoints(theme) end, {})
    end
}