" Base Configuration
source $HOME/.config/nvim/vimplug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/mappings.vim

" Themes
source $HOME/.config/nvim/themes/nord.vim
source $HOME/.config/nvim/themes/airline.vim

" Plugin Configuration
luafile $HOME/.config/nvim/lua/telescope_config.lua
source $HOME/.config/nvim/vimplug/settings/telescope.vim
source $HOME/.config/nvim/vimplug/settings/coc.vim
source $HOME/.config/nvim/vimplug/settings/gitgutter.vim
source $HOME/.config/nvim/vimplug/settings/start-screen.vim
source $HOME/.config/nvim/vimplug/settings/nvim-tree.vim

" LSP
source $HOME/.config/nvim/vimplug/settings/lsp-config.vim
luafile $HOME/.config/nvim/lua/lsp/compe-config.lua
luafile $HOME/.config/nvim/lua/lsp/python-lsp.lua
luafile $HOME/.config/nvim/lua/lsp/vim-lsp.lua
