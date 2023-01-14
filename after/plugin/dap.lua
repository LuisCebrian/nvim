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
