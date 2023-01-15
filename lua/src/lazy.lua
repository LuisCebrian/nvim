-- Install Lazy if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({

    { import = "plugins" },

    -- Git
    "tpope/vim-fugitive",
    "lewis6991/gitsigns.nvim",

    -- Tmux
    "christoomey/vim-tmux-navigator",

    -- Start screen
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end
    },

    -- Project management
    "ahmedkhalf/project.nvim",

    -- Status bar
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", lazy = true },
        }
    },

    -- Utility
    "phaazon/hop.nvim",
    "tpope/vim-surround",
    "tpope/vim-abolish",
    "tpope/vim-unimpaired",
    "windwp/nvim-autopairs",

    -- Comments
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },

    -- LSP: Linter formatters
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "mfussenegger/nvim-dap-python" },
            { "rcarriga/nvim-dap-ui" },
            {
                "theHamsta/nvim-dap-virtual-text",
                config = function()
                    require("nvim-dap-virtual-text").setup({})
                end,
            }
        },
    },

    -- Languages: Markdown
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = "markdown",
        config = function()
            vim.g.mkdp_auto_close = 0
        end,
    }

}, {
    ui = {
        border = "single"
    },
    change_detection = {
        enabled = false
    }
})
