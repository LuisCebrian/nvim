local dapui = require("dapui")
local dap = require("dap")

dapui.setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open

vim.keymap.set("n", "<A-1>", dapui.close)
