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
        vim.keymap.set('n', '<leader>xr', '<Plug>RestNvim', {})
    end
}
