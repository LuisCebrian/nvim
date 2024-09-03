return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    branch = "regexp",
    config = function()
        require('venv-selector').setup({
            dap_enabled = true,
            name = { "venv", ".env" },
            fd_binary_name = "fdfind"
        })
        vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<cr>', {})
    end
}
