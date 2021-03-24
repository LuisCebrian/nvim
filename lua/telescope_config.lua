local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
   },
   file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
   grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
   qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new
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
