return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npx --yes yarn install && cd .. && git checkout -- yarn.lock",
    ft = "markdown",
    config = function()
        vim.g.mkdp_auto_close = 0
    end,
}
