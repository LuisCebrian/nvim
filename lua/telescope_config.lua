local actions = require('telescope.actions')
local lga_actions = require("telescope-live-grep-args.actions")
local toggle_modes = function()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd [[startinsert]]
    return
  end
  if mode == "i" then
    vim.cmd [[stopinsert]]
    return
  end
end
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-c>"] = toggle_modes
      },
   }
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        }
      },
      theme = "dropdown"
    }
  }
}


M = {}

-- Search git files and default to project files if not in git repository
M.project_files = function(opts)
  local opts = opts or {}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then
    require'telescope.builtin'.find_files(opts)
  end
end

return M
