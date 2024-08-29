return {
    'Nedra1998/nvim-mdlink',
    ft = "markdown",
    config = function()
        local nvim_link = require("nvim-mdlink")
        nvim_link.setup({
            keymap = false,
            cmp = false
        })

        function SetupKeymaps()
            vim.keymap.set('v', '<c-k>', "<cmd>lua nvim_link.create('v')<cr>", { buffer = true })
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            callback = SetupKeymaps,
            group = vim.api.nvim_create_augroup("Nvim-mdlinkKeymaps", { clear = true })
        })
    end
}
