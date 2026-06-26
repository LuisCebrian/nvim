return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "folke/lazydev.nvim", ft = "lua", opts = {} },
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

            vim.lsp.config.basedpyright = { capabilities = capabilities }
            vim.lsp.config.ruff = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- Format + fix imports on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                            vim.lsp.buf.code_action({
                                context = { only = { "source.organizeImports" } },
                                apply = true
                            })
                        end
                    })
                end
            }
            vim.lsp.config.dockerls = { capabilities = capabilities }
            vim.lsp.config.jsonls = { capabilities = capabilities }
            vim.lsp.config.vimls = { capabilities = capabilities }
            vim.lsp.config.yamlls = { capabilities = capabilities }

            -- Enable LSP servers
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('basedpyright')
            vim.lsp.enable("ruff")
            vim.lsp.enable('dockerls')
            vim.lsp.enable('jsonls')
            vim.lsp.enable('vimls')
            vim.lsp.enable('yamlls')

            -- Setup lsp-related mappings
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    local noremap = { buffer = ev.buf, remap = false, silent = true }

                    -- Document highlight on cursor hold
                    if client and client:supports_method("textDocument/documentHighlight") then
                        local hl_group = vim.api.nvim_create_augroup("UserLspHighlight", { clear = false })
                        vim.api.nvim_create_autocmd("CursorHold", {
                            buffer = ev.buf,
                            group = hl_group,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd("CursorMoved", {
                            buffer = ev.buf,
                            group = hl_group,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
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
