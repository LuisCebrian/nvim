vim.g.mapleader = " "

-- Better horizontal scroll
vim.keymap.set("n", "<C-A-L>", "5zl")
vim.keymap.set("n", "<C-A-H>", "5zh")

--Better indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Alternate way to close
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>bd", ":bd<CR>")

-- Run last command
vim.keymap.set("n", "<leader>c", "@:")

vim.keymap.set("n", "<silent><C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<silent><C-Down>", ":resize +2<CR>")
vim.keymap.set("n", "<silent><C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<silent><C-Right>", ":vertical resize +2<CR>")
