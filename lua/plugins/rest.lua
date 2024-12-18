return {
    "rest-nvim/rest.nvim",
    ft = "http",
    config = function()
        vim.g.rest_nvim = {
            ui = {
                winbar = true
            }
        }
        function SetupKeymaps()
            -- TODO: figure out how to make this command work: vim.keymap.set('n', '<c-cr>', '<Plug>RestNvim', {})
            vim.keymap.set('n', '<leader>xr', '<cmd>Rest run<cr>', { buffer = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "http",
            callback = SetupKeymaps,
            group = vim.api.nvim_create_augroup("RestNvimKeymaps", { clear = true })
        })
    end
}
