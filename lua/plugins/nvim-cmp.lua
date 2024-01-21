return {
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
        keys = {
            {
                "<tab>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
            { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" }
        },
        config = function()
            -- Completion
            local kind_icons = {
                Array         = "",
                Boolean       = "󰨙",
                Class         = "",
                Codeium       = "󰘦",
                Color         = "",
                Control       = "",
                Collapsed     = "",
                Constant      = "󰏿",
                Constructor   = "",
                Copilot       = "",
                Enum          = "",
                EnumMember    = "",
                Event         = "",
                Field         = "",
                File          = "",
                Folder        = "",
                Function      = "󰊕",
                Interface     = "",
                Key           = "",
                Keyword       = "",
                Method        = "󰊕",
                Module        = "",
                Namespace     = "󰦮",
                Null          = "",
                Number        = "󰎠",
                Object        = "",
                Operator      = "",
                Package       = "",
                Property      = "",
                Reference     = "",
                Snippet       = "",
                String        = "",
                Struct        = "󰆼",
                TabNine       = "󰏚",
                Text          = "",
                TypeParameter = "",
                Unit          = "",
                Value         = "",
                Variable      = "󰀫",
            }

            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
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
                            path = "",
                            buffer = "",
                            luasnip = "",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp", keyword_length = 2 },
                    { name = "luasnip",  keyword_length = 2 },
                    { name = "path" },
                }, {
                    { name = "buffer", keyword_length = 3 },
                }),
            })

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,

    }
}
