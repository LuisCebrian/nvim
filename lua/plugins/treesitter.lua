return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({})

            require("nvim-treesitter").install({
                "bash",
                "c",
                "css",
                "csv",
                "diff",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitcommit",
                "gitignore",
                "go",
                "graphql",
                "hcl",
                "html",
                "java",
                "javascript",
                "jinja",
                "jinja_inline",
                "jq",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "ruby",
                "rust",
                "sql",
                "ssh_config",
                "terraform",
                "tmux",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")

            -- Select
            for _, mode in ipairs({ "x", "o" }) do
                vim.keymap.set(mode, "aa", function()
                    select.select_textobject("@parameter.outer", "textobjects")
                end)
                vim.keymap.set(mode, "ia", function()
                    select.select_textobject("@parameter.inner", "textobjects")
                end)
                vim.keymap.set(mode, "af", function()
                    select.select_textobject("@function.outer", "textobjects")
                end)
                vim.keymap.set(mode, "if", function()
                    select.select_textobject("@function.inner", "textobjects")
                end)
                vim.keymap.set(mode, "ac", function()
                    select.select_textobject("@class.outer", "textobjects")
                end)
                vim.keymap.set(mode, "ic", function()
                    select.select_textobject("@class.inner", "textobjects")
                end)
                vim.keymap.set(mode, "al", function()
                    select.select_textobject("@loop.outer", "textobjects")
                end)
                vim.keymap.set(mode, "il", function()
                    select.select_textobject("@loop.inner", "textobjects")
                end)
                vim.keymap.set(mode, "as", function()
                    select.select_textobject("@statement.outer", "textobjects")
                end)
                vim.keymap.set(mode, "ab", function()
                    select.select_textobject("@block.outer", "textobjects")
                end)
                vim.keymap.set(mode, "ib", function()
                    select.select_textobject("@block.inner", "textobjects")
                end)
            end

            -- Move
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "n", "o" }, "[m", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@parameter.inner", "textobjects")
            end)

            -- Swap
            vim.keymap.set("n", "<leader>a", function()
                swap.swap_next("@parameter.inner")
            end)
            vim.keymap.set("n", "<leader>A", function()
                swap.swap_previous("@parameter.inner")
            end)
        end,
    },
}
