local projectName = string.gsub(vim.fn.system("yq -r '.name' dbt_project.yml"), "\n$", "")

local function openBotRightWindow(lines, ft)
    vim.cmd('botright new')

    vim.cmd('setlocal buftype=nofile')
    vim.cmd('setlocal bufhidden=wipe')

    if ft and ft ~= '' then
        vim.cmd('set filetype=' .. ft)
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    vim.cmd('setlocal nomodifiable')
end

local function getCompilePath(rel_path)
    return "target/compiled/" .. projectName .. "/" .. rel_path
end

local function dbtCompile()
    local file = vim.api.nvim_buf_get_name(0)
    local rel_path = vim.fn.fnamemodify(file, ':.') -- ej: models/my_model.sql

    local compile_cmd = "dbt compile --no-use-colors --warn-error -s path:" .. rel_path
    local compile_output = vim.fn.systemlist(compile_cmd)

    local exit_code = vim.v.shell_error

    if exit_code ~= 0 then
        openBotRightWindow(compile_output, '')
        return
    end

    local compiled_file_path = getCompilePath(rel_path)

    -- Si existe, lo leemos y lo mostramos con filetype=sql
    if vim.fn.filereadable(compiled_file_path) == 1 then
        local compiled_code = vim.fn.readfile(compiled_file_path)
        openBotRightWindow(compiled_code, 'sql')
    else
        vim.notify(
            "No se encontró el archivo compilado en: " .. compiled_file_path,
            vim.log.levels.ERROR
        )
    end
end

local function dbtTerminal(dbt_cmd)
    local file = vim.api.nvim_buf_get_name(0)
    local rel_path = vim.fn.fnamemodify(file, ':.')
    local cmd = { "dbt", dbt_cmd, "-s", "path:" .. rel_path }

    -- Abre una split abajo y arranca termopen con tu comando
    vim.cmd("botright new")

    vim.fn.termopen(cmd)
    vim.cmd("startinsert")
end

local function dbtRun()
    dbtTerminal("run")
end

local function dbtTest()
    dbtTerminal("test")
end

local function submitQuery(file_name)
    local run_command = "bq query --use_legacy_sql=false -n 100 < " .. file_name .. " 2>/dev/null"
    local command_output = vim.fn.systemlist(run_command)
    openBotRightWindow(command_output, '')
end

local function dbtQuery()
    local file = vim.api.nvim_buf_get_name(0)
    local rel_path = vim.fn.fnamemodify(file, ':.') -- ej: models/my_model.sql

    local compile_cmd = "dbt compile --no-use-colors --warn-error -s path:" .. rel_path
    local compile_output = vim.fn.systemlist(compile_cmd)

    local exit_code = vim.v.shell_error

    if exit_code ~= 0 then
        openBotRightWindow(compile_output, '')
        return
    end

    local compiled_file_path = getCompilePath(rel_path)
    submitQuery(compiled_file_path)
end

local function dbtCommand(args)
    -- Create new split window with height 25
    vim.cmd('25new')
    -- Open terminal with dbt command
    vim.fn.termopen('dbt ' .. args)
    vim.cmd("startinsert")
end

local function generateDocs()
    local filepath = vim.api.nvim_buf_get_name(0)
    local yaml_filepath = filepath:gsub("%.sql$", ".yml")

    -- Check if file already exists
    local f = io.open(yaml_filepath, "r")
    if f then
        f:close()
        return "File already exists " .. yaml_filepath
    end

    -- Get model name from filepath
    -- Get model name from filepath
    local model_name = vim.fn.fnamemodify(filepath, ":t:r")
    local cmd_models = string.format('{"model_names": ["%s"]}', model_name)

    -- Execute dbt command
    local command = string.format("dbt run-operation generate_model_yaml --args '%s'", cmd_models)
    local output = vim.fn.system(command)

    local models_start = output:find("models:")
    if models_start then
        output = output:sub(models_start)
    end

    -- Write to file
    f = io.open(yaml_filepath, "w")
    if not f then
        return "Error: Could not create file " .. yaml_filepath
    end
    f:write(output)
    f:close()
end

local function openMirrorFile(extension)
    local current_file = vim.fn.expand("%:r") -- Obtiene la ruta sin extensión.
    local doc_file = current_file .. "." .. extension
    vim.cmd("edit " .. doc_file)
end

-- Función que abre el fichero alternativo según la extensión del buffer actual.
local function openAltFile()
    local extension = vim.fn.expand("%:e") -- Obtiene la extensión del fichero actual.
    if extension:lower() == "sql" then
        openMirrorFile("yml")
    elseif extension:lower() == "yml" then
        openMirrorFile("sql")
    end
end

vim.api.nvim_create_user_command("DbtCompile", dbtCompile, {})
vim.api.nvim_create_user_command("DbtRun", dbtRun, {})
vim.api.nvim_create_user_command("DbtTest", dbtTest, {})
vim.api.nvim_create_user_command("DbtQuery", dbtQuery, {})
vim.api.nvim_create_user_command(
    'Dbt',
    function(opts) dbtCommand(opts.args) end,
    { nargs = 1, desc = "Execute dbt command in a new terminal window" }
)

vim.api.nvim_create_user_command("DbtGenerateDocFile", generateDocs, {})

vim.keymap.set('n', '<leader>bc', dbtCompile, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>br', dbtRun, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bt', dbtTest, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bq', dbtQuery, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ba', openAltFile, { noremap = true, silent = true })
