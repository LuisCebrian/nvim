local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python")
require('dap-python').setup(mason_path)
