vim.g.mapleader = " "

-- Better horizontal scroll
vim.keymap.set("n", "<C-]>", "5zl")
vim.keymap.set("n", "<C-[>", "5zh")

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

-- Transform selected text to markdown link in visual mode
vim.keymap.set('v', '<C-k>', function()
    vim.cmd('normal! "vy')
    local selected_text = vim.fn.getreg('v')

    local markdown_link = '[' .. selected_text .. ']()'

    vim.cmd('normal! gv')
    vim.cmd('normal! c' .. markdown_link)

    vim.cmd('normal! F(')
    vim.cmd('normal! l')
    vim.cmd('startinsert')
end, { desc = "Transform selection to markdown link" })
