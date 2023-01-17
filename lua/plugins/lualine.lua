return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    config = function()
        require('lualine').setup{
            options = {
                theme = 'tokyonight'
            },
            sections = {
                lualine_b = {'branch', 'diff'},
                lualine_x = {'lsp_progress', 'encoding', 'fileformat', 'filetype'}
            }
        }
    end
}
