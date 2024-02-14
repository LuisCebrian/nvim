return {
    "gbprod/yanky.nvim",
    dependencies = {
        { "kkharji/sqlite.lua" }
    },
    opts = {
        ring = { storage = "sqlite" },
        highlight = {
            on_put = false,
            on_yank = false
        }
    },
    keys = {
        { "y", "<Plug>(YankyYank)",     mode = { "n", "x" }, desc = "Yank text" },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    },
}
