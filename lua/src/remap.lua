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

vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Copy file name
vim.keymap.set("n", "cp", ":let @+ = expand(\"%:t:r\")<cr>")

-- Exit insert mode in terminal with C-e
vim.keymap.set('t', '<C-e>', '<C-\\><C-n>', { noremap = true, silent = true })
