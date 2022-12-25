vim.opt.errorbells = false
vim.opt.iskeyword:append("_")
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.opt.scroll = 10
vim.opt.scrolloff = 3
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.updatetime = 300
-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"

-- Make visible tabs and trailing whitespaces
vim.opt.list = true
vim.opt.listchars = { trail = '·' , tab = '»·'}
