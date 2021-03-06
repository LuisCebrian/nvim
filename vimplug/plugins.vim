" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif


call plug#begin(stdpath('data') . '/plugged')

" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'folke/tokyonight.nvim'

"Icons
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Telescope dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Comments
Plug 'tpope/vim-commentary'

" Status bar
Plug 'hoob3rt/lualine.nvim'

"Debug
Plug 'puremourning/vimspector'
Plug 'sagi-z/vimspectorpy', { 'do': { -> vimspectorpy#update() } }

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"Utilities
Plug 'tpope/vim-unimpaired'
Plug 'jiangmiao/auto-pairs'
Plug 'jmcantrell/vim-virtualenv'
Plug 'airblade/vim-rooter'
Plug 'phaazon/hop.nvim'
Plug 'tpope/vim-surround'

" Project
Plug 'mhinz/vim-startify'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'dense-analysis/ale'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
" Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Treesiter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Markdown previewer
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }


call plug#end()


" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
