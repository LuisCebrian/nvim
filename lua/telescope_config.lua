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
