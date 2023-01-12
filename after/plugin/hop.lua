require('hop').setup({
    case_insensitive = false,
    char2_fallback_key = '<cr>'
})

local hop = require('hop')
local directions = require('hop.hint').HintDirection

-- Cannot be set through vimscript
vim.keymap.set('', 'f', function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end, {remap = true})
vim.keymap.set('', 'F', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end, {remap = true})
vim.keymap.set('', 't', function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, {remap = true})
vim.keymap.set('', 'T', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = -1 }) end, {remap = true})
vim.keymap.set({'n', 'x'}, 's', hop.hint_char2)
