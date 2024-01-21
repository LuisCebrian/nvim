return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({})

            local noremap = { remap = false, silent = true }
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
    }
}
