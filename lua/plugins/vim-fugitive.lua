return {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
        local GitDiff = function()
            -- Open git diff in a vertical split
            vim.cmd('silent! vert botright Git diff')
            -- Highlight trailing whitespaces on newly added lines
            vim.cmd[[match NvimInternalError /^+.*\zs[^\s]\s\+\ze$/]]
            vim.bo.syntax = 'git'
        end

        local GitCommit = function()
            vim.cmd.Git()
            GitDiff()
            vim.cmd.Git()
        end

        vim.keymap.set('n', '<leader>gb', function() vim.cmd.Git('blame') end)
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
        vim.keymap.set('n', '<leader>gl', function() vim.cmd('vert Git log') end)
        vim.keymap.set('n', '<leader>gd', GitDiff)
        vim.keymap.set('n', '<leader>gc', GitCommit)
        vim.keymap.set('n', '<leader>gh', function() vim.cmd[[0Gclog]] end)
    end
}
