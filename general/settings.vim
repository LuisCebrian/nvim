syntax enable
set noerrorbells
set iskeyword+=_
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smarttab
set autoindent
set number
set relativenumber
set nowrap
set noswapfile
set nobackup
set autoindent
set incsearch
set showmatch
set cursorline
set splitbelow
set splitright
set clipboard=unnamedplus "Use the same clipboard as system
set colorcolumn=120
set scroll=10
set scrolloff=3

" Coc settings
set updatetime=300
set shortmess+=c " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes

" Make visible tabs and trailing whitespaces
set list listchars=tab:»·,trail:·

" Airline settings
set noshowmode
set showtabline=2

"Tree
set termguicolors
"set undodir=~/.vim/undodir
"set undofile

" If inside a git repo, auto save and auto read on branch change
silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
  set hidden
  au FocusGained,BufEnter * :silent! !
  au FocusLost,WinLeave,BufLeave * :silent! silent! w
endif

" Don't insert comments for next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
