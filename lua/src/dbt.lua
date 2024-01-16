local path = vim.fn.stdpath("config")

vim.cmd(string.format("source %s/general/providers.vim", path))
vim.cmd(string.format("source %s/general/dbt.vim", path))
