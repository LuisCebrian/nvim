let g:ale_disable_lsp = 1

let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {'python': ['black', 'isort']}
let g:ale_fix_on_save = 1

let g:ale_python_flake8_executable = $HOME . '/.virtualenvs/nvim/bin/flake8'
let g:ale_python_flake8_options = '--max-line-length=100'
let g:ale_python_black_executable = $HOME . '/.virtualenvs/nvim/bin/black'
let g:ale_python_isort_executable = $HOME . '/.virtualenvs/nvim/bin/isort'

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_sign_priority = 10

