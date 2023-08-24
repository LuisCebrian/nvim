return {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
        require("project_nvim").setup {
            scope_chdir = 'tab',
            detection_methods = { "pattern", "lsp" },
            patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json" }
        }
    end
}
