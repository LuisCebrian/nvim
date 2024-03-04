return {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
        require("Comment").setup()
        -- Enable comments for dbt buffers
        local ft = require("Comment.ft")
        ft.set('dbt', '--%s')
    end
}
