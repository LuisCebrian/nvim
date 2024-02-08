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

            -- Setup
            local signs = {
                Error = "",
                Warn  = "",
                Hint  = "",
                Info  = "",
            }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- Setup language servers
            require("neodev").setup() -- Setup lua development config before other lsp

            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            missing_parameters = false
                        }
                    }
                }
            })
            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.dockerls.setup({ capabilities = capabilities })
            lspconfig.jsonls.setup({ capabilities = capabilities })
            lspconfig.vimls.setup({ capabilities = capabilities })
            lspconfig.yamlls.setup({ capabilities = capabilities })

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
