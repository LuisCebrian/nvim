" Base Configuration
source $HOME/.config/nvim/vimplug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/mappings.vim

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
source $HOME/.config/nvim/vimplug/settings/easymotion.vim

" LSP
source $HOME/.config/nvim/vimplug/settings/lsp-config.vim
luafile $HOME/.config/nvim/lua/lsp/compe-config.lua
luafile $HOME/.config/nvim/lua/lsp/python-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/vim-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/docker-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/yaml-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/treesitter.lua
