return {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    config = function()
        require('venv-selector').setup({
            dap_enabled = true,
            name = { "venv", ".env" },
            fd_binary_name = "fdfind"
        })
        -- Load the python environment automatically
        local group = vim.api.nvim_create_augroup("VenvAutoActivation", { clear = true })

        vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter" }, {
            desc = "Auto select virtualenv when reading a python file",
            pattern = "*.py",
            group = group,
            callback = function()
                -- If there is a venv active, dont load it again
                if require('venv-selector').get_active_venv() == nil and os.getenv("VIRTUAL_ENV") == nil then
                    -- Defer the callback to give some time to the diagnostics to detect the new environment
                    vim.defer_fn(require("venv-selector").retrieve_from_cache, 2000)
                end
            end,
        })

        -- Deactivate if the current working directory has changed
        vim.api.nvim_create_autocmd("DirChanged", {
            desc = "Auto select virtualenv when cwd is changed",
            pattern = "*",
            callback = function()
                require("venv-selector").deactivate_venv()
            end
        })

        vim.keymap.set('n', '<leader>vs', '<cmd>VenvSelect<cr>', {})
    end
}
