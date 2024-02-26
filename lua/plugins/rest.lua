return {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "http",
    config = function()
        require("rest-nvim").setup({
            result = {
                show_headers = false,
            }
        })

        function SetupKeymaps()
            -- TODO: figure out how to make this command work: vim.keymap.set('n', '<c-cr>', '<Plug>RestNvim', {})
            vim.keymap.set('n', '<leader>xr', '<Plug>RestNvim', { buffer = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "http",
            callback = SetupKeymaps,
            group = vim.api.nvim_create_augroup("RestNvimKeymaps", { clear = true })
        })
    end
}
