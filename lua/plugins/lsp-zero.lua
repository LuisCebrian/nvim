return {
        "VonHeikemen/lsp-zero.nvim",
        event = "BufReadPost",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" }
        },
        config = function ()
            local lsp = require('lsp-zero')

            lsp.set_preferences({
                suggest_lsp_servers = true,
                setup_servers_on_start = true,
                set_lsp_keymaps = false,
                configure_diagnostics = true,
                cmp_capabilities = true,
                manage_nvim_cmp = true,
                call_servers = 'local',
                sign_icons = {
                    error = "",
                    warn = "",
                    hint = "",
                    info = ""
                }
            })

            -- Setup cmp
            local kind_icons = {
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "[]",
                Class = "",
                Interface = "",
                Module = "",
                Property = "襁",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = ""
            }

            local cmp = require('cmp')
            lsp.setup_nvim_cmp({
                formatting = {
                    fields = {
                        cmp.ItemField.Menu,
                        cmp.ItemField.Abbr,
                        cmp.ItemField.Kind
                    },
                    format = function(entry, vim_item)
                        -- Kind icons
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                        -- Source
                        vim_item.menu = ({
                            nvim_lsp = "",
                            nvim_lua = "",
                            cmdline = "",
                            path = "",
                            buffer = "﬘",
                            luasnip = "",
                        })[entry.source.name]
                        return vim_item
                    end
                }
            })

            -- So that we can confirm first suggestion
            local cmdlineMapping = cmp.mapping.preset.cmdline({
                ['<C-y>'] = {
                    c = cmp.mapping.confirm({ select = false }),
                }
            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmdlineMapping,
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmdlineMapping,
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })

            -- Setup lsp commands
            lsp.on_attach(function(client, bufnr)
                local noremap = { buffer = bufnr, remap = false, silent = true }

                -- Mappings
                vim.keymap.set('n', 'gd', "<cmd>Telescope lsp_definitions<cr>", noremap)
                vim.keymap.set('n', 'gD', "<cmd>Telescope lsp_declarations<cr>", noremap)
                vim.keymap.set('n', 'gr', "<cmd>Telescope lsp_references<cr>", noremap)
                vim.keymap.set('n', 'gR', vim.lsp.buf.rename, noremap)
                vim.keymap.set('n', 'gi', "<cmd>Telescope lsp_implementations<cr>", noremap)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, noremap)
                vim.keymap.set('n', 'gl', vim.diagnostic.open_float, noremap)
                vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, noremap)
                vim.keymap.set('n', ']d', vim.diagnostic.goto_next, noremap)

                -- Word Highlight
                if client.server_capabilities.documentHighlightProvider then
                    local highlight_group = vim.api.nvim_create_augroup("LspRefHiglight", { clear = true })
                    vim.api.nvim_create_autocmd(
                    "CursorHold",
                    {
                        callback = vim.lsp.buf.document_highlight,
                        group = highlight_group,
                        buffer = bufnr
                    }

                    )
                    vim.api.nvim_create_autocmd(
                    "CursorMoved",
                    {
                        callback = vim.lsp.buf.clear_references,
                        group = highlight_group,
                        buffer = bufnr
                    }
                    )
                end
            end)

            lsp.nvim_workspace({
                library = vim.api.nvim_get_runtime_file('', true)
            })

            -- Prevent lua server from asking for server configuration confirmation
            lsp.use('lua_ls', { settings = { Lua = { workspace = { checkThirdParty = false } } } }, true)

            lsp.setup()

            -- Load lua snippets
            require("luasnip.loaders.from_snipmate").lazy_load()
        end
}
