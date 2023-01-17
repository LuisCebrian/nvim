return {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function()
        require("nvim-autopairs").setup {
            fast_wrap = {
                keys = 'qwrtyuiopzxcvbnmasdfghjkl',
                end_key = 'e'
            }
        }
    end
}
