return {
    "nvim-neotest/neotest",
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                })
            },
            quickfix = {
                open = false
            },
            output = {
                open = false,
                enabled = false
            }
        })

        vim.diagnostic.config({ virtual_text = true }, vim.api.nvim_create_namespace("neotest"))
        vim.keymap.set('n', '<leader>tt', neotest.run.run, {})
        vim.keymap.set('n', '<leader>ta', function() neotest.run.run({ suite = true }) end, {})
        vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand("%")) end, {})
        vim.keymap.set('n', '<leader>td', function() neotest.run.run({ strategy = "dap" }) end, {})
        vim.keymap.set('n', '<leader>tq', neotest.run.stop, {})
        vim.keymap.set('n', '<leader>ts', neotest.summary.toggle, {})
        vim.keymap.set('n', '<leader>to', neotest.output_panel.toggle, {})
    end,
    dependencies = {
        {
            "nvim-neotest/neotest-python"
        }
    }
}
