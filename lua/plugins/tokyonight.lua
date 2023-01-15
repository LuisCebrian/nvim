return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
        require('tokyonight').setup({
            styles = {
                floats = 'normal'
            }
        })

        vim.cmd('colorscheme tokyonight-night')
        vim.cmd('highlight CursorLine guibg=#212535')
    end
}
