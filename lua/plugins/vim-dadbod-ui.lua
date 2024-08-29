return {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
        { 'tpope/vim-dadbod',                     lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_help = 0
        vim.g.db_adapter_bigquery_region = 'region-eu'
        vim.g.db_ui_force_echo_notifications = 1
        vim.g.db_ui_debug = 1

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

            function OnEnd(_, data, _)
                local opts = { key = "BigQueryConsumption", group = "Something", annote = "Annotation" }
                if data == 0 then
                    local bytes = PrettyBytes(tonumber(string.match(result, '%d+')))
                    fidget.notify(bytes, vim.log.levels.INFO, opts)
                else
                    fidget.notify(result, vim.log.levels.ERROR, opts)
                end
            end

            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local content = string.gsub(TableToString(lines), "'", "\'")
            local cmd = "bq query --use_legacy_sql=false --dry_run '" .. content .. "'"
            vim.fn.jobstart(cmd,
                {
                    on_stdout = OnOut,
                    on_exit = OnEnd,
                    on_stderr = OnOut
                }
            )
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "sql",
            command = "autocmd InsertLeave <buffer> lua DryRunBigQuery()",
            group = vim.api.nvim_create_augroup("DadbodSqlPreview", { clear = true })
        })
    end
}
