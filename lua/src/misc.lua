---------------------------
-- QuickFix manipulation --
---------------------------
local function SelectionRange()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return csrow, cscol, cerow, cecol
    else
        return cerow, cecol, csrow, cscol
    end
end

function RemoveQFItem(mode)
    local initr, lastr

    if mode == "v" then
        initr, _, lastr, _ = SelectionRange()
    else
        local currow = vim.fn.line(".")
        initr = currow
        lastr = currow
    end

    local qflist = vim.fn.getqflist()
    local nitems = lastr - initr
    for i = 1, nitems + 1 do
        table.remove(qflist, initr)
    end

    -- Set QF contents
    vim.fn.setqflist({}, "r", { items = qflist })

    if #qflist > 0 then
        vim.fn.setpos(".", { vim.fn.bufnr(), initr, 1, 0 })
    else
        vim.cmd.cclose()
    end
    return qflist
end

local qf_group = vim.api.nvim_create_augroup("ManipulateQFList", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    -- TODO: Find out why this does not work with the callback function
    command = "vnoremap <silent><buffer>d <esc><cmd>lua RemoveQFItem('v')<cr>",
    group = qf_group
}
)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    -- TODO: Find out why this does not work with the callback function
    command = "nnoremap <silent><buffer>dd <esc><cmd>lua RemoveQFItem('n')<cr>",
    group = qf_group
}
)

function ToggleQuickFix()
    local wininfo = vim.fn.getwininfo()
    local qf = vim.fn.filter(wininfo, 'v:val.quickfix')
    if #qf > 0 then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end

vim.keymap.set("n", "<F2>", ToggleQuickFix)

-------------------------------
-- END QuickFix manipulation --
-------------------------------
----------------------
-- Trim Whitespaces --
----------------------

function TrimWhiteSpace()
    local post = vim.fn.winsaveview()
    vim.cmd [[keeppatterns %s/\s\+$//e]]
    vim.fn.winrestview(post)
end

--------------------------
-- END Trim Whitespaces --
--------------------------

------------------------
-- Formatting Options --
------------------------

function SetFormatOptions()
    vim.opt.formatoptions:remove("c")
    vim.opt.formatoptions:remove("r")
    vim.opt.formatoptions:remove("o")
end

local format_group = vim.api.nvim_create_augroup("FormattingOptions", { clear = true })
vim.api.nvim_create_autocmd("FileType",
    { pattern = "*", callback = SetFormatOptions, group = format_group }
)

----------------------------
-- END Formatting Options --
----------------------------

---------------------------
-- Auto save on Git repo --
---------------------------

local function SaveBuffer()
    if vim.o.modified then
        vim.cmd("silent! w")
    end
end

local function SetAutoSaveCommands(au_group)
    vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" },
        { pattern = "*", command = "silent! !", group = au_group }
    )
    vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave", "BufLeave", "CursorHold" },
        { pattern = "*", callback = SaveBuffer, group = au_group }
    )
end

local function RemoveAutoSaveCommands(au_group)
    vim.api.nvim_del_augroup_by_id(au_group)
end

function SetAutoSave()
    local auto_save_group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true })
    vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error == 0 then
        vim.opt.hidden = true
        SetAutoSaveCommands(auto_save_group)
    else
        vim.opt.hidden = false
        RemoveAutoSaveCommands(auto_save_group)
    end
end

local auto_save_trigger = vim.api.nvim_create_augroup("AutoSaveTriggerGroup", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" },
    { pattern = "*", callback = SetAutoSave, group = auto_save_trigger }
)

-------------------------------
-- END Auto save on Git repo --
-------------------------------

----------------------------------
-- Resize splits if vim resized --
----------------------------------

vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})
--------------------------------------
-- END Resize splits if vim resized --
--------------------------------------

---------------------------------
-- Toggle invisible characters --
---------------------------------
function ToggleInvisibleChars()
    if vim.opt_local.listchars:get()["space"] ~= nil then
        vim.opt_local.listchars = { trail = '·', tab = '»·' }
    else
        vim.opt_local.listchars = {
            trail = '·',
            tab = '»·',
            space = '·',
            nbsp = '␣',
            eol = '¶',
            precedes = '«',
            extends = '»'
        }
    end
end

vim.keymap.set("n", "<F3>", ToggleInvisibleChars)
-------------------------------------
-- END Toggle invisible characters --
-------------------------------------

---------------------------------
-- Toggle invisible characters --
---------------------------------
function TableToString(table)
    local result = ""

    for _, line in ipairs(table) do
        result = result .. line .. "\n"
    end

    return result
end

function PrettyBytes(bytes)
    local sizes = { 'B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB' }
    local i = 1
    while bytes >= 1024 and i < #sizes do
        bytes = bytes / 1024.0
        i = i + 1
    end
    return bytes > 0 and string.format(' %.1f%s ', bytes, sizes[i]) or ''
end

function DryRunBigQuery()
    local fidget = require("fidget")

    local result = ""
    function OnOut(_, data, _)
        result = result .. TableToString(data)
    end

    function OnEnd(jobid, data, event)
        if data == 0 then
            local bytes = PrettyBytes(tonumber(string.match(result, '%d+')))
            fidget.notify(bytes, vim.log.levels.INFO)
        else
            fidget.notify(result, vim.log.levels.ERROR)
        end
        print(jobid)
        print(data)
        print(event)
    end

    local currentFile = vim.fn.expand("%")
    local cmd = "bq query --use_legacy_sql=false --dry_run < " .. currentFile
    vim.fn.jobstart(cmd,
        {
            on_stdout = OnOut,
            on_exit = OnEnd,
            on_stderr = OnOut
        }
    )
end

-------------------------------------
-- END Toggle invisible characters --
-------------------------------------

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        vim.bo.formatprg = "jq"
    end,
})
