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
" set cmdheight=2

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
  au FocusLost,WinLeave,BufLeave,CursorHold * if &modified | silent! w | endif
endif

" Don't insert comments for next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Toggle the quickfix list
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <F2> :call ToggleQuickFix()<cr>

" Change the name tab of tmux to the file edited in vim
if exists('$TMUX')
    let windowName = system("tmux display-message -p '#W'")
    autocmd BufReadPost,FileReadPost,BufNewFile,BufEnter * call system("tmux rename-window 'vim:" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux rename-window " . windowName)
endif

" Remove trailing whitespaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

" Remove the current item from the quickfix list.
function! RemoveQFItem() range
    let l:qf_list = getqflist()
    if len(l:qf_list) > 0
        call remove(l:qf_list, a:firstline - 1, a:lastline - 1)
        call setqflist([], 'r', {'items': l:qf_list})
    endif

    if len(l:qf_list) > 0
        call setpos('.', [bufnr(), a:firstline, 1, 0])
    else
        cclose
    endif
endfunction

" command! RemoveQFItem :call RemoveQFItem()

augroup quickfixdd
  " Use map <buffer> to only map dd in the quickfix window.
  autocmd FileType qf nnoremap <silent><buffer>dd :call RemoveQFItem()<cr>
  autocmd FileType qf vnoremap <silent><buffer>d :call RemoveQFItem()<cr>
augroup end
