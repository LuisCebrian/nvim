return {
    "iamcco/markdown-preview.nvim",
    build = "npm install",
    ft = "markdown",
    config = function()
        vim.g.mkdp_auto_close = 0
    end,
}
