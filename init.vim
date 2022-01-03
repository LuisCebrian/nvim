" Base Configuration
source $HOME/.config/nvim/general/providers.vim
source $HOME/.config/nvim/vimplug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/mappings.vim
source $HOME/.config/nvim/general/dbt.vim

" Themes
source $HOME/.config/nvim/themes/tokyonight.vim
luafile $HOME/.config/nvim/lua/themes/lualine.lua

" Plugin Configuration
luafile $HOME/.config/nvim/lua/telescope_config.lua
source $HOME/.config/nvim/vimplug/settings/telescope.vim
source $HOME/.config/nvim/vimplug/settings/gitgutter.vim
source $HOME/.config/nvim/vimplug/settings/start-screen.vim
source $HOME/.config/nvim/vimplug/settings/nvim-tree.vim
source $HOME/.config/nvim/vimplug/settings/fugitive.vim
source $HOME/.config/nvim/vimplug/settings/vimspector.vim
luafile $HOME/.config/nvim/lua/hop_config.lua
source $HOME/.config/nvim/vimplug/settings/hop.vim
source $HOME/.config/nvim/vimplug/settings/markdown-preview.vim
source $HOME/.config/nvim/vimplug/settings/ale.vim
source $HOME/.config/nvim/vimplug/settings/vim-commentary.vim


" LSP
source $HOME/.config/nvim/vimplug/settings/lsp-config.vim
luafile $HOME/.config/nvim/lua/lsp/compe-config.lua
luafile $HOME/.config/nvim/lua/lsp/python-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/vim-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/docker-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/yaml-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/json-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/treesitter.lua
