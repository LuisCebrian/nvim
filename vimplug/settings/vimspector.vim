let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy']
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         13,
  \    'vimspectorBPCond':     12,
  \    'vimspectorBPLog':      12,
  \    'vimspectorBPDisabled': 11,
  \    'vimspectorPC':         999,
  \ }

nmap <A-down> <Plug>VimspectorStepInto
nmap <A-right> <Plug>VimspectorStepOver
nmap <A-up> <Plug>VimspectorStepOut

nmap <A-1> :VimspectorReset<CR>
