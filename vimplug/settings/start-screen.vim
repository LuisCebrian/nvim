let g:startify_session_dir = '~/.local/share/nvim/sessions'
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 1

let g:startify_lists = [
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ { 'type': 'files',     'header': ['   MRU']            },
\ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
\ { 'type': 'sessions',  'header': ['   Sessions']       },
\ ]

let g:startify_bookmarks = [
\ { 'd': '~/GIT/dotfiles' },
\ { 'n': '~/GIT/nvim/init.vim' },
\ ]
