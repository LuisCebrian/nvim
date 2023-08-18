return {
    "mfussenegger/nvim-dap",
    -- This could be loaded when we enter a debugging session but right now it is
    -- loaded by telescope. Figure out how to lazy load telescope on key mapping.
    event = "VeryLazy",
    dependencies = {
        {
            "mfussenegger/nvim-dap-python",
            config = function()
                local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python")
                require('dap-python').setup(mason_path)
                table.insert(require('dap').configurations.python, {
                    console = "integratedTerminal",
                    name = "Launch file (justMyCode = false)",
                    program = "${file}",
                    request = "launch",
                    justMyCode = false,
                    type = "python"
                })
            end
        },
        {
            "rcarriga/nvim-dap-ui",
            config = function()
                local dapui = require("dapui")
                local dap = require("dap")

                dapui.setup({
                    icons = { expanded = "", collapsed = "", current_frame = "" },
                })

                dap.listeners.after.event_initialized["dapui_config"] = dapui.open

                vim.keymap.set("n", "<A-1>", dapui.close)
                vim.keymap.set({ "v", "n" }, "<leader>dv", dapui.eval)
            end
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            config = function()
                require("nvim-dap-virtual-text").setup({})
            end,
        }
    },
    config = function()
        local dap = require('dap')
        local noremap = { remap = false }

        local conditionalBreakpoint = function()
            dap.set_breakpoint(vim.fn.input("Breakdpoint condition: "))
        end

        vim.keymap.set("n", "<F5>", dap.continue, noremap)
        vim.keymap.set("n", "<A-right>", dap.step_over, noremap)
        vim.keymap.set("n", "<A-down>", dap.step_into, noremap)
        vim.keymap.set("n", "<A-up>", dap.step_out, noremap)
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, noremap)
        vim.keymap.set("n", "<leader>dB", conditionalBreakpoint, noremap)
        vim.keymap.set("n", "<leader>dl", dap.run_last, noremap)

        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "ErrorMsg", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "WarningMsg", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "▶ ", texthl = "Special", linehl = "CursorLine", numhl = "" })
    end
}
