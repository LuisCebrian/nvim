require('lualine').setup{
    options = {
        theme = 'tokyonight'
    },
    sections = {
        lualine_b = {'branch', 'diff'},
        lualine_x = {'lsp_progress', 'encoding', 'fileformat', 'filetype'}
    }
}
