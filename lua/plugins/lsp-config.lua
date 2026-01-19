return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "folke/neodev.nvim"
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                automatic_installation = true
            })

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                    }
                }
            })

            -- Setup language servers
            require("neodev").setup() -- Setup lua development config before other lsp

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Configure LSP servers using the new vim.lsp.config API
            vim.lsp.config.lua_ls = {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            missing_parameters = false
                        }
                    }
                }
            }

            vim.lsp.config.pyright = { capabilities = capabilities }
            vim.lsp.config.dockerls = { capabilities = capabilities }
            vim.lsp.config.jsonls = { capabilities = capabilities }
            vim.lsp.config.vimls = { capabilities = capabilities }
            vim.lsp.config.yamlls = { capabilities = capabilities }

            -- Enable LSP servers
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('pyright')
            vim.lsp.enable('dockerls')
            vim.lsp.enable('jsonls')
            vim.lsp.enable('vimls')
            vim.lsp.enable('yamlls')

            -- Setup lsp-related mappings
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local noremap = { buffer = ev.buf, remap = false, silent = true }
                    vim.keymap.set('n', 'gd', "<cmd>Telescope lsp_definitions<cr>", noremap)
                    vim.keymap.set('n', 'gD', "<cmd>Telescope lsp_declarations<cr>", noremap)
                    vim.keymap.set('n', 'gr', "<cmd>Telescope lsp_references<cr>", noremap)
                    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, noremap)
                    vim.keymap.set('n', 'gi', "<cmd>Telescope lsp_implementations<cr>", noremap)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, noremap)
                    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, noremap)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, noremap)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, noremap)
                end
            })
        end
    }
}
