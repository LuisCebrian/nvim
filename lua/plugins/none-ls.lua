return {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

        null_ls.setup({
            debug = true,
            diagnostic_config = {
                signs = {
                    priority = 9 -- Less than 10 so that breakpoints show above diagnostics
                }
            },
            sources = {
                -- Python
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.black,
                -- null_ls.builtins.diagnostics.flake8.with({
                --     extra_args = { "--max-line-length=100" },
                -- }),
                -- Lua
                null_ls.builtins.formatting.stylua.with({
                    extra_args = { "--indent-width", "Spaces" }
                }),
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })
    end
}
