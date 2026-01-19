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
                    show_all_buffers = true,
                    mappings = {
                        i = {
                            ["<C-d>"] = actions.delete_buffer
                        }
                    }
                },
                lsp_definitions = {
                    theme = "dropdown",
                },
                lsp_declarations = {
                    theme = "dropdown",
                },
                lsp_references = {
                    theme = "dropdown",
                },
                lsp_implementations = {
                    theme = "dropdown",
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
                    prompt_title = 'Project Files',
                    show_untracked = true,
                    layout_config = {
                        width = 0.7
                    },
                },
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    prompt_title = 'Find Files',
                    layout_config = {
                        width = 0.7
                    },
                },
                grep_string = {
                    theme = "dropdown",
                    layout_config = {
                        width = 0.7
                    },
                },
                command_history = {
                    theme = "dropdown",
                },
                git_branches = {
                    theme = "dropdown",
                    mappings = {
                        i = {
                            ["<C-b>"] = "git_create_branch"
                        }
                    }
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
                    theme = "dropdown",
                    layout_config = {
                        width = 0.7
                    },
                },
                projects = {
                    sync_with_nvim_tree = true
                }
            }
        }

        telescope.load_extension("live_grep_args")
        telescope.load_extension('dap')
        telescope.load_extension('projects')
        telescope.load_extension('yank_history')

        function SearchClass()
            builtin.lsp_dynamic_workspace_symbols({ prompt_title = "Classes", symbols = { "class" } })
        end

        function ProjectFiles()
            local opts = {} -- define here if you want to define something
            vim.fn.system("git rev-parse --is-inside-work-tree")
            if vim.v.shell_error == 0 then
                builtin.git_files(opts)
            else
                builtin.find_files(opts)
            end
        end

        vim.keymap.set('n', '<leader>ff', builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<leader>fn', builtin.lsp_dynamic_workspace_symbols, {})
        vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args, {})
        vim.keymap.set({ 'n', 'v' }, '<leader>fw', builtin.grep_string, {})
        vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>ft', builtin.git_branches, {})
        vim.keymap.set('n', '<leader>fr', builtin.resume, {})
        vim.keymap.set('n', '<C-p>', ProjectFiles, {})
        vim.keymap.set('n', '<C-n>', SearchClass, {})

        local dropdown = require('telescope.themes').get_dropdown()
        vim.keymap.set('n', '<leader>p', function() telescope.extensions.yank_history.yank_history(dropdown) end, {})

        vim.keymap.set('n', '<leader>dp', function() telescope.extensions.dap.list_breakpoints(dropdown) end, {})
        vim.keymap.set('n', '<leader>de', telescope.extensions.projects.projects, {})
    end
}
